import SwiftUI


struct PIDView : View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @EnvironmentObject var rocket : Rocket
    @State var getData = false
    
    var body : some View {
        Section {
            Text("PID Values")
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Button(action: {
                    bluetoothDevice.setPID(input: "0" + rocket.rollKp + "," + rocket.rollKi + "!" + rocket.rollKd)
                    bluetoothDevice.setPID(input: "1" + rocket.pitchKp + "," + rocket.pitchKi + "!" + rocket.pitchKd)
                    bluetoothDevice.setPID(input: "2" + rocket.yawKp + "," + rocket.yawKi + "!" + rocket.yawKd)
                }) {
                    Text("Apply")
                }.buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                Button(action: {
                    bluetoothDevice.setUtilities(input: "0")
                }) {
                    Text("RESET ESP32")
                }.buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
            }.padding(.bottom)
            HStack {
                Text("Roll:")
                Text("Kp:")
                TextField(rocket.rollKp, text: Binding<String>(
                    get: { rocket.rollKp },
                    set: {
                        rocket.rollKp = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
                Text("Ki:")
                TextField(rocket.rollKi, text: Binding<String>(
                    get: { rocket.rollKi },
                    set: {
                        rocket.rollKi = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
                Text("Kd:")
                TextField(rocket.rollKd, text: Binding<String>(
                    get: { rocket.rollKd },
                    set: {
                        rocket.rollKd = $0
                        
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
            }
            HStack {
                Text("Pitch:")
                Text("Kp:")
                TextField(rocket.pitchKp, text: Binding<String>(
                    get: { rocket.pitchKp },
                    set: {
                        rocket.pitchKp = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
                Text("Ki:")
                TextField(rocket.pitchKi, text: Binding<String>(
                    get: { rocket.pitchKi },
                    set: {
                        
                        rocket.pitchKi = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
                Text("Kd:")
                TextField(rocket.pitchKd, text: Binding<String>(
                    get: { rocket.pitchKd },
                    set: {
                        rocket.pitchKd = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
            }
            HStack {
                Text("Yaw:")
                Text("Kp:")
                TextField(rocket.yawKp, text: Binding<String>(
                    get: { rocket.yawKp },
                    set: {
                        rocket.yawKp = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
                Text("Ki:")
                TextField(rocket.yawKi, text: Binding<String>(
                    get: { rocket.yawKi },
                    set: {
                        rocket.yawKi = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
                Text("Kd:")
                TextField(rocket.yawKd, text: Binding<String>(
                    get: { rocket.yawKd },
                    set: {
                        rocket.yawKd = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
            }
            
            Section {
                Text("PID Command Graphs")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                HStack {
                    Button(action: {
                        bluetoothDevice.setPID(input: "PID Get")
                        getData.toggle()
                    }) {
                        Text("Get Data")
                    }.disabled(getData)
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: {
                        bluetoothDevice.setPID(input: "PID Stop")
                        getData.toggle()
                    }) {
                        Text("Stop")
                    }.disabled(!getData)
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    Button(action: {
                        rocket.resetPIDCommands()
                    }) {
                        Text("Reset All")
                    }.buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                }.padding(.bottom)
            }.onDisappear(perform: {
                bluetoothDevice.setPID(input: "PID Stop")
            })
            Section {
                Text("Yaw Command")
                ChartStyle().getGraph(datasets: rocket.getYawCommand(), colour: .red)
                
                Text("Pitch Command")
                ChartStyle().getGraph(datasets: rocket.getPitchCommand(), colour: .green)
                
                Text("Roll Command")
                ChartStyle().getGraph(datasets: rocket.getRollCommand(), colour: .blue)
            }
        }.padding(.leading)
    }
}


struct PIDView_Previews: PreviewProvider {
    static var previews: some View {
        PIDView()
    }
}
