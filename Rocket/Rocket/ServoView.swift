import SwiftUI

struct ServoView : View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var servo0Position : Double = 0
    @State var servo1Position : Double = 0
    @State var servo0StartingPosition : Double = 90
    @State var servo1StartingPosition : Double = 90
    
    var body: some View {
        Section {
            Section {
                Text("Gimbal Servo Positions")
                    .font(.title2)
                    .padding(.bottom)
                HStack {
                    Text("Servo 0: " + String(Int(servo0Position)))
                        .padding(.trailing)
                    Slider(value: Binding(get: {
                        servo0Position
                    }, set: { (newVal) in
                        servo0Position = newVal
                    }), in: -30...30, step: 1) { editing in
                        if(!editing) {
                            bluetoothDevice.setServos(input: "0" + String(Int(servo0Position)))
                        }
                    }
                }.padding()
                HStack {
                    Text("Servo 1: " + String(Int(servo1Position)))
                        .padding(.trailing)
                    Slider(value: Binding(get: {
                        servo1Position
                    }, set: { (newVal) in
                        servo1Position = newVal
                    }), in: -30...30, step: 1) { editing in
                        if(!editing) {
                            bluetoothDevice.setServos(input: "1" + String(Int(servo1Position)))
                        }
                    }
                }.padding()
            }
            Divider()
            Section {
                Text("Parachute Servo")
                    .font(.title2)
                    .padding()
                HStack {
                    Button(action: {
                        bluetoothDevice.setServos(input: "Open Parachute")
                    }) {
                        Text("OPEN")
                            .font(.title3)
                            .padding()
                            .buttonStyle(.borderless)
                    }
                    Button(action: {
                        bluetoothDevice.setServos(input: "Close Parachute")
                    }) {
                        Text("CLOSE")
                            .font(.title3)
                            .padding()
                            .buttonStyle(.borderless)
                    }
                }
            }
            Divider()
            Section {
                Text("Set Gimbal Servo Starting Positions")
                    .font(.title2)
                    .padding()
                HStack {
                    Text("Servo 0: " + String(Int(servo0StartingPosition)))
                        .padding(.trailing)
                    Slider(value: Binding(get: {
                        servo0StartingPosition
                    }, set: { (newVal) in
                        servo0StartingPosition = newVal
                    }), in: 0...180, step: 1) { editing in
                        if(!editing) {
                            bluetoothDevice.setServos(input: "4" + String(Int(servo0StartingPosition)))
                        }
                    }
                    Button(action: {
                        bluetoothDevice.setServos(input: "70" + String(Int(servo0StartingPosition)))
                    }) {
                        Text("Set as origin")
                    }
                }.padding()
                HStack {
                    Text("Servo 1: " + String(Int(servo1StartingPosition)))
                        .padding(.trailing)
                    Slider(value: Binding(get: {
                        servo1StartingPosition
                    }, set: { (newVal) in
                        servo1StartingPosition = newVal
                    }), in: 0...180, step: 1) { editing in
                        if(!editing) {
                            bluetoothDevice.setServos(input: "5" + String(Int(servo1StartingPosition)))
                        }
                    }
                    Button(action: {
                        bluetoothDevice.setServos(input: "71" + String(Int(servo1StartingPosition)))
                    }) {
                        Text("Set as origin")
                    }
                }.padding()
            }
            
        }
        .onDisappear(perform: {
            bluetoothDevice.setServos(input: "10")
        })
        .hideKeyboardWhenTappedAround()
    }
}



struct ServoView_Previews: PreviewProvider {
    static var previews: some View {
        ServoView()
    }
}
