import SwiftUI
import SwiftUICharts

struct ThrustVectoringRocketView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @EnvironmentObject var rocket : Rocket
    var body: some View {
        ScrollView {
            Text("Control Panel")
                .font(.largeTitle)
                .padding(.bottom)
            Divider()
            HStack {
                Button(action: {
                    bluetoothDevice.setUtilities(input: "Arm")
                }) {
                    Text("Arm Rocket")
                        .font(.title2)
                }
                .padding()
                Button(action: {
                    bluetoothDevice.setUtilities(input: "Reset")
                }) {
                    Text("Reset Rocket")
                        .font(.title2)
                }
                .padding()
            }
            Divider()
            Section {
                HStack {
                    Text("Armed")
                        .padding()
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        .padding()
                        .disabled(rocket.armed)
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                        .padding()
                        .disabled(!rocket.armed)
                }
                HStack {
                    Text("TVC Active")
                        .padding()
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        .padding()
                        .disabled(rocket.tvcActive)
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                        .padding()
                        .disabled(!rocket.tvcActive)
                }
                HStack {
                    Text("Coasting")
                        .padding()
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        .padding()
                        .disabled(rocket.coasting)
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                        .padding()
                        .disabled(!rocket.coasting)
                }
                HStack {
                    Text("Parachute Out")
                        .padding()
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        .padding()
                        .disabled(rocket.parachuteOut)
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                        .padding()
                        .disabled(!rocket.parachuteOut)
                }
                HStack {
                    Text("Touchdown")
                        .padding()
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        .padding()
                        .disabled(rocket.touchdown)
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                        .padding()
                        .disabled(!rocket.touchdown)
                }
            }
            Section {
                HStack {
                    NavigationLink("View Orientation:", destination: rocketGraphView())
                        .padding(.horizontal)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .padding(.horizontal)
                }
                Divider()
                HStack {
                    NavigationLink("View Servo Values:", destination: rocketServoPosView())
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .padding(.horizontal)
                }
                Divider()
                HStack {
                    NavigationLink("View PID Values:", destination: pidValuesView())
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .padding(.horizontal)
                }
            }
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct pidValuesView : View {
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
                        bluetoothDevice.setPID(input: "11")
                        getData.toggle()
                    }) {
                        Text("Get Data")
                    }.disabled(getData)
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: {
                        bluetoothDevice.setPID(input: "10")
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
                bluetoothDevice.setPID(input: "10")
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
                    bluetoothDevice.setBMI088(input: "11")
                    getData.toggle()
                }) {
                    Text("Get Data")
                }.disabled(getData)
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    bluetoothDevice.setBMI088(input: "10")
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
            bluetoothDevice.setBMI088(input: "10")
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

struct ThrustVectoringRocketView_Previews: PreviewProvider {
    static var previews: some View {
        ThrustVectoringRocketView()
    }
}
