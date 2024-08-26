//To add new device:
//create new device cbcharacteristic variable
//update the three peripheral functions in extension BTDevice: CBPeripheralDelegate
//create a function in BTDevice
import Foundation
import CoreBluetooth

protocol BTDeviceDelegate: AnyObject {
    func deviceConnected()
    func deviceReady()
    func deviceSerialChanged(value: String)
    func deviceDisconnected()
    
}

class BTDevice: NSObject {
    private let peripheral: CBPeripheral
    private let manager: CBCentralManager
    
    private var servoChar: CBCharacteristic?
    
    private var bmp390Char: CBCharacteristic?
    
    private var buzzerChar: CBCharacteristic?
    
    private var bmi088Char: CBCharacteristic?
    
    private var pidChar: CBCharacteristic?
    
    private var utilitiesChar: CBCharacteristic?
    
    var rocket: Rocket?
    
    weak var delegate: BTDeviceDelegate?
    
    var utilitiesString: String {
        get {
            return "-1"
        }
        set {
            if let char = utilitiesChar {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    var pidString: String {
        get {
            return "-1"
        }
        set {
            if let char = pidChar {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    var bmi088String: String {
        get {
            return "-1"
        }
        set {
            if let char = bmi088Char {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    
    var buzzerString: String {
        get {
            return "-1"
        }
        set {
            if let char = buzzerChar {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    
    var bmp390String: String {
        get {
            return "-1"
        }
        set {
            if let char = bmp390Char {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    
    var servoString: String {
        get {
            return "-1"
        }
        set {
            if let char = servoChar {
                peripheral.writeValue(Data(newValue.utf8), for: char, type: .withResponse)
            }
        }
    }
    
    var name: String {
        return peripheral.name ?? "Unknown device"
    }
    var detail: String {
        return peripheral.identifier.description
    }
    private(set) var serial: String?
    
    init(peripheral: CBPeripheral, manager: CBCentralManager) {
        self.peripheral = peripheral
        self.manager = manager
        super.init()
        self.peripheral.delegate = self
    }
    
    func connect() {
        manager.connect(peripheral, options: nil)
    }
    
    func disconnect() {
        manager.cancelPeripheralConnection(peripheral)
    }
    
    func intToChar(number: Int) -> [Character] {
        return Array(String(number))
    }
}

extension BTDevice {
    // these are called from BTManager, do not call directly
    
    func connectedCallback() {
        peripheral.discoverServices([BTUUIDs.esp32Service])
        delegate?.deviceConnected()
    }
    
    func disconnectedCallback() {
        delegate?.deviceDisconnected()
    }
    
    func errorCallback(error: Error?) {
        print("Device: error \(String(describing: error))")
    }
}


extension BTDevice: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Device: discovered services")
        peripheral.services?.forEach {
            print("  \($0)")
            if $0.uuid == BTUUIDs.esp32Service {
                peripheral.discoverCharacteristics([BTUUIDs.servoUUID, BTUUIDs.esp32Service, BTUUIDs.bmp390UUID, BTUUIDs.buzzerUUID, BTUUIDs.bmi088UUID, BTUUIDs.pidUUID, BTUUIDs.utilitiesUUID], for: $0)
            } else {
                peripheral.discoverCharacteristics(nil, for: $0)
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        service.characteristics?.forEach {
            if $0.uuid == BTUUIDs.servoUUID {
                self.servoChar = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            } else if $0.uuid == BTUUIDs.bmp390UUID {
                self.bmp390Char = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            } else if $0.uuid == BTUUIDs.buzzerUUID {
                self.buzzerChar = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            } else if $0.uuid == BTUUIDs.bmi088UUID {
                self.bmi088Char = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            } else if $0.uuid == BTUUIDs.pidUUID {
                self.pidChar = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            } else if $0.uuid == BTUUIDs.utilitiesUUID {
                self.utilitiesChar = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            }
        }
        delegate?.deviceReady()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == servoChar?.uuid, let b = characteristic.value {
            var value = String(decoding: b, as: UTF8.self)
            if(value != "") {
                if(value[...value.startIndex] == "9") {
                    value.remove(at: value.startIndex)
                    if(value[...value.startIndex] == "0") {
                        value.remove(at: value.startIndex)
                        
                        let servo0pos = Float(value)!
                        rocket!.addServo0Pos(pos: servo0pos)
                        
                        return;
                    }
                    else if(value[...value.startIndex] == "1") {
                        value.remove(at: value.startIndex)
                        
                        let servo0pos = Float(value)!
                        rocket!.addServo0Pos(pos: servo0pos)
                        
                        return;
                    }
                }
                if(value[...value.startIndex] == "0") {
                    value.remove(at: value.startIndex)
                    rocket!.maxPosition = Double(value)!
                }
            }
        }
        else if characteristic.uuid == pidChar?.uuid, let b = characteristic.value {
            var value = String(decoding: b, as: UTF8.self)
            if(value != "") {
                if(value[...value.startIndex] == "9") {
                    value.remove(at: value.startIndex)
                    if(value[...value.startIndex] == "0") {
                        value.remove(at: value.startIndex)
                        rocket!.addPitchCommand(cmd: Float(value)!)
                        return;
                    }
                    else if(value[...value.startIndex] == "1") {
                        value.remove(at: value.startIndex)
                        rocket!.addRollCommand(cmd: Float(value)!)
                        return;
                    }
                    else if(value[...value.startIndex] == "2") {
                        value.remove(at: value.startIndex)
                        rocket!.addYawCommand(cmd: Float(value)!)
                        return;
                    }
                }
            }
        }
        else if characteristic.uuid == bmp390Char?.uuid, let b = characteristic.value {
            var value = String(decoding: b, as: UTF8.self)
            if(value != "") {
                if(value[...value.startIndex] == "9") {
                    value.remove(at: value.startIndex)
                    if(value[...value.startIndex] == "0") {
                        value.remove(at: value.startIndex)
                        rocket!.addAltitude(altitude: Float(value)!)
                        return;
                    }
                    if(value[...value.startIndex] == "1") {
                        value.remove(at: value.startIndex)
                        rocket!.addTemperature(temperature: Float(value)!)
                        return;
                    }
                    if(value[...value.startIndex] == "2") {
                        value.remove(at: value.startIndex)
                        rocket!.addPressure(pressure: Float(value)!)
                        return;
                    }
                }
            }
        }
        else if characteristic.uuid == bmi088Char?.uuid, let b = characteristic.value {
            var value = String(decoding: b, as: UTF8.self)
            if(value != "") {
                if(value[...value.startIndex] == "9") {
                    value.remove(at: value.startIndex)
                    if(value[...value.startIndex] == "0") {
                        value.remove(at: value.startIndex)
                        rocket!.addAccelX(accelX: Float(value)!)
                        return;
                    }
                    else if(value[...value.startIndex] == "1") {
                        value.remove(at: value.startIndex)
                        rocket!.addAccelY(accelY: Float(value)!)
                        return;
                    }
                    else if(value[...value.startIndex] == "2") {
                        value.remove(at: value.startIndex)
                        rocket!.addAccelZ(accelZ: Float(value)!)
                        return;
                    }
                    else if(value[...value.startIndex] == "3") {
                        value.remove(at: value.startIndex)
                        rocket!.addGyroX(gyroX: Float(value)!)
                        return;
                    }
                    else if(value[...value.startIndex] == "4") {
                        value.remove(at: value.startIndex)
                        rocket!.addGyroY(gyroY: Float(value)!)
                        return;
                    }
                    else if(value[...value.startIndex] == "5") {
                        value.remove(at: value.startIndex)
                        rocket!.addGyroZ(gyroZ: Float(value)!)
                        return;
                    }
                    else if(value[...value.startIndex] == "6") {
                        value.remove(at: value.startIndex)
                        rocket!.addPitch(pitch: Float(value)!)
                        return;
                    }
                    else if(value[...value.startIndex] == "7") {
                        value.remove(at: value.startIndex)
                        rocket!.addRoll(roll: Float(value)!)
                        return;
                    }

                }
            }
        }
        else if characteristic.uuid == utilitiesChar?.uuid, let b = characteristic.value {
            var value = String(decoding: b, as: UTF8.self)
            if(value != "") {
                if(value[...value.startIndex] == "1") {
                    value.remove(at: value.startIndex)
                    rocket!.logs.append(value + "\n")
                }
                else if(value[...value.startIndex] == "2") {
                    value.remove(at: value.startIndex)
                    if(value == "On Pad") {
                        rocket!.onPad = true;
                    }
                    else if(value == "TVC Active") {
                        rocket!.tvcActive = true;
                    }
                    else if(value == "Coasting") {
                        rocket!.coasting = true;
                    }
                    else if(value == "Parachute Out") {
                        rocket!.parachuteOut = true;
                    }
                    else if(value == "Touchdown") {
                        rocket!.touchdown = true;
                    }
                }
                if(value[...value.startIndex] == "9") {
                    value.remove(at: value.startIndex)
                    if(value[...value.startIndex] == "0") {
                        value.remove(at: value.startIndex)
                        rocket!.deltaTime = value
                    }
                }
            }
        }
    }
}


