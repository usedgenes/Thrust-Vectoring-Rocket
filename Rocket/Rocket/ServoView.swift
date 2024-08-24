import SwiftUI

struct ServoView : View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    @State var servo0Position : Double = 0
    @State var servo1Position : Double = 0
    
    var body: some View {
        Section {
            Section {
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
                    Button(action: {
                        bluetoothDevice.setServos(input: "20")
                    }) {
                        Text("Set as origin")
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
                    Button(action: {
                        bluetoothDevice.setServos(input: "20")
                    }) {
                        Text("Set as origin")
                    }
                }.padding()
            }
            Text("Servo Position Graphs")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            HStack {
                Button(action: {
                    bluetoothDevice.setServos(input: "11")
                    getData.toggle()
                }) {
                    Text("Get Data")
                }.disabled(getData)
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    bluetoothDevice.setServos(input: "10")
                    getData.toggle()
                }) {
                    Text("Stop")
                }.disabled(!getData)
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                Button(action: {
                    rocket.resetServoPos()
                }) {
                    Text("Reset All")
                }.buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
            }.padding(.bottom)
        }
        .onDisappear(perform: {
            bluetoothDevice.setServos(input: "10")
        })
        .hideKeyboardWhenTappedAround()
        
    }
}

struct SetGimbalServosPositionView : View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    @State var servo0Position : Double = 0
    @State var servo1Position : Double = 0
    
    var body: some View {
        Section {
            Section {
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
                    Button(action: {
                        bluetoothDevice.setServos(input: "20")
                    }) {
                        Text("Set as origin")
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
                    Button(action: {
                        bluetoothDevice.setServos(input: "20")
                    }) {
                        Text("Set as origin")
                    }
                }.padding()
            }
            Text("Servo Position Graphs")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            HStack {
                Button(action: {
                    bluetoothDevice.setServos(input: "11")
                    getData.toggle()
                }) {
                    Text("Get Data")
                }.disabled(getData)
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    bluetoothDevice.setServos(input: "10")
                    getData.toggle()
                }) {
                    Text("Stop")
                }.disabled(!getData)
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                Button(action: {
                    rocket.resetServoPos()
                }) {
                    Text("Reset All")
                }.buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
            }.padding(.bottom)
        }
        .onDisappear(perform: {
            bluetoothDevice.setServos(input: "10")
        })
        .hideKeyboardWhenTappedAround()
        
        Text("Servo 0 Position")
        ChartStyle().getGraph(datasets: rocket.getServo0Pos(), colour: .red)
        
        Text("Servo 1 Position")
        ChartStyle().getGraph(datasets: rocket.getServo1Pos(), colour: .green)
    }
}



struct ServoView_Previews: PreviewProvider {
    static var previews: some View {
        ServoView()
    }
}
