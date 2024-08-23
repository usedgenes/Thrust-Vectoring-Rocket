import SwiftUI
import SwiftUICharts

struct ThrustVectoringRocketView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    
    @State var servo0Position : Double = 0
    @State var servo1Position : Double = 0
    
    @State var rollKp : String = "50.0"
    @State var rollKi : String = "0.5"
    @State var rollKd : String = "0.0"
    @State var pitchKp : String = "50.0"
    @State var pitchKi : String = "0.0"
    @State var pitchKd : String = "0.0"
    @State var yawKp : String = "50.0"
    @State var yawKi : String = "0.0"
    @State var yawKd : String = "0.0"
    
    @EnvironmentObject var rocket : Rocket
    
    var body: some View {
        ScrollView {
            Text("Thrust Vectoring Rocket")
            HStack {
                Button(action: {
                    bluetoothDevice.setUtilities(input: )
                }) {
                    Text("Arm Rocket")
                }
            }
            
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
            GroupBox {
                NavigationLink("View Orientation:", destination: rocketGraphView())
                    .padding()
            }
            GroupBox {
                NavigationLink("View Servo Values:", destination: rocketServoPosView())
                    .padding()
            }
            GroupBox {
                NavigationLink("View PID Values:", destination: rocketPidView())
                    .padding()
            }
        }.hideKeyboardWhenTappedAround()
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct pidValuesView : View {
    var body : some View {
        Section {
            Text("PID Values")
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Button(action: {
                    bluetoothDevice.setPID(input: "0" + rollKp + "," + rollKi + "!" + rollKd)
                    bluetoothDevice.setPID(input: "1" + pitchKp + "," + pitchKi + "!" + pitchKd)
                    bluetoothDevice.setPID(input: "2" + yawKp + "," + yawKi + "!" + yawKd)
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
                TextField(rollKp, text: Binding<String>(
                    get: { rollKp },
                    set: {
                        rollKp = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
                Text("Ki:")
                TextField(rollKi, text: Binding<String>(
                    get: { rollKi },
                    set: {
                        rollKi = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
                Text("Kd:")
                TextField(rollKd, text: Binding<String>(
                    get: { rollKd },
                    set: {
                        rollKd = $0
                        
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
            }
            HStack {
                Text("Pitch:")
                Text("Kp:")
                TextField(pitchKp, text: Binding<String>(
                    get: { pitchKp },
                    set: {
                        pitchKp = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
                Text("Ki:")
                TextField(pitchKi, text: Binding<String>(
                    get: { pitchKi },
                    set: {
                        
                        pitchKi = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
                Text("Kd:")
                TextField(pitchKd, text: Binding<String>(
                    get: { pitchKd },
                    set: {
                        pitchKd = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
            }
            HStack {
                Text("Yaw:")
                Text("Kp:")
                TextField(yawKp, text: Binding<String>(
                    get: { yawKp },
                    set: {
                        yawKp = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
                Text("Ki:")
                TextField(yawKi, text: Binding<String>(
                    get: { yawKi },
                    set: {
                        yawKi = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
                Text("Kd:")
                TextField(yawKd, text: Binding<String>(
                    get: { yawKd },
                    set: {
                        yawKd = $0
                    }))
                .keyboardType(UIKeyboardType.decimalPad)
            }
        }.padding(.leading)
    }
}

struct rocketGraphView : View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false

    
    var body : some View {
        Section {
            Text("BMI088 Data Graphs")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            HStack {
                Button(action: {
                    bluetoothDevice.setBMI088(input: )
                    getData.toggle()
                }) {
                    Text("Get Data")
                }.disabled(getData)
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    bluetoothDevice.setBMI088(input: )
                    getData.toggle()
                }) {
                    Text("Stop")
                }.disabled(!getData)
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                Button(action: {
                    rocket.resetRotation()
                }) {
                    Text("Reset All")
                }.buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                Button(action: {
                    bluetoothDevice.setBMI088(input: "1")
                }) {
                    Text("Calibrate")
                }.buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
            }.padding(.bottom)
        }.onDisappear(perform: {
            bluetoothDevice.setBMI088(input: )
        })
        
        Text("Yaw")
        ChartStyle().getGraph(datasets: rocket.getYaw(), colour: .red)
        
        Text("Pitch")
        ChartStyle().getGraph(datasets: rocket.getPitch(), colour: .green)
        
        Text("Roll")
        ChartStyle().getGraph(datasets: rocket.getRoll(), colour: .blue)
    }
}

struct rocketServoPosView : View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    
    var body: some View {
        Section {
            Text("Servo Position Graphs")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            HStack {
                Button(action: {
                    bluetoothDevice.setServos(input: )
                    getData.toggle()
                }) {
                    Text("Get Data")
                }.disabled(getData)
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    bluetoothDevice.setServos(input: )
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
        }.onDisappear(perform: {
            bluetoothDevice.setServos(input: )
        })
        
        Text("Servo 0 Position")
        ChartStyle().getGraph(datasets: rocket.getServo0Pos(), colour: .red)
        
        let servo1data = LineChartData(dataSets: rocket.getServo1Pos(), chartStyle: ChartStyle().getChartStyle())
        Text("Servo 1 Position")
        ChartStyle().getGraph(datasets: rocket.getServo1Pos(), colour: .green)
    }
}

struct rocketPidView : View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    
    var body: some View {
        Section {
            Text("PID Command Graphs")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            HStack {
                Button(action: {
                    bluetoothDevice.setPID(input: )
                    getData.toggle()
                }) {
                    Text("Get Data")
                }.disabled(getData)
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    bluetoothDevice.setPID(input: )
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
            bluetoothDevice.setPID(input: )
        })
        
        Text("Yaw Command")
        ChartStyle().getGraph(datasets: rocket.getYawCommand(), colour: .red)
        
        Text("Pitch Command")
        ChartStyle().getGraph(datasets: rocket.getPitchCommand(), colour: .green)
        
        Text("Roll Command")
        ChartStyle().getGraph(datasets: rocket.getRollCommand(), colour: .blue)
    }
}

struct ThrustVectoringRocketView_Previews: PreviewProvider {
    static var previews: some View {
        ThrustVectoringRocketView()
    }
}
