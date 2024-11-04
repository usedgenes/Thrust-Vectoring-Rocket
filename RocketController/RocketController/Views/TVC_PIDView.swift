import SwiftUI


struct TVC_PIDView : View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @EnvironmentObject var rocket : Rocket
    @State var getData = false
    let coefficientType = ["Kp", "Ki", "Kd"]
    @State var selectedPitchCoefficient = "Kp"
    @State var selectedRollCoefficient = "Kp"
    @State var selectedYawCoefficient = "Kp"
    @State var pitchCoefficient = "10.0"
    @State var rollCoefficient = "10.0"
    @State var yawCoefficient = "10.0"
    
    var body : some View {
        ScrollView {
            Text("PID Values")
                .font(.title)
                .fontWeight(.bold)
            Divider()
            Section {
                HStack {
                    VStack {
                        Text("Pitch")
                            .font(.title2)
                        HStack {
                            Text("Kp:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(rocket.pitchKp, text: Binding<String>(
                                get: { rocket.pitchKp },
                                set: {
                                    rocket.pitchKp = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                        HStack {
                            Text("Ki:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(rocket.pitchKi, text: Binding<String>(
                                get: { rocket.pitchKi },
                                set: {
                                    rocket.pitchKi = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                        HStack {
                            Text("Kd:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(rocket.pitchKd, text: Binding<String>(
                                get: { rocket.pitchKd },
                                set: {
                                    rocket.pitchKd = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                    }
                    Divider()
                    VStack {
                        Text("Roll")
                            .font(.title2)
                        HStack {
                            Text("Kp:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(rocket.rollKp, text: Binding<String>(
                                get: { rocket.rollKp },
                                set: {
                                    rocket.rollKp = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                        HStack {
                            Text("Ki:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(rocket.rollKi, text: Binding<String>(
                                get: { rocket.rollKi },
                                set: {
                                    rocket.rollKi = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                        HStack {
                            Text("Kd:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(rocket.rollKd, text: Binding<String>(
                                get: { rocket.rollKd },
                                set: {
                                    rocket.rollKd = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                    }
                    Divider()
                    VStack {
                        Text("Yaw")
                            .font(.title2)
                        HStack {
                            Text("Kp:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(rocket.yawKp, text: Binding<String>(
                                get: { rocket.yawKp },
                                set: {
                                    rocket.yawKp = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                        HStack {
                            Text("Ki:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(rocket.yawKi, text: Binding<String>(
                                get: { rocket.yawKi },
                                set: {
                                    rocket.yawKi = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                        HStack {
                            Text("Kd:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(rocket.yawKd, text: Binding<String>(
                                get: { rocket.yawKd },
                                set: {
                                    rocket.yawKd = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                    }
                }.hideKeyboardWhenTappedAround()
                HStack {
                    Spacer()
                    Button(action: {
                        bluetoothDevice.setPID(input: "0" + rocket.pitchKp + "," + rocket.pitchKi + "!" + rocket.pitchKd)
                        bluetoothDevice.setPID(input: "1" + rocket.rollKp + "," + rocket.rollKi + "!" + rocket.rollKd)
                        bluetoothDevice.setPID(input: "2" + rocket.yawKp + "," + rocket.yawKi + "!" + rocket.yawKd)
                    }) {
                        Text("Send Values")
                            .font(.title2)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(Color("Light Gray"))
                        .cornerRadius(10)
                    Spacer()
                }

                Divider()
                HStack {
                    Spacer()
                    Button(action: {
                        if(!getData) {
                            bluetoothDevice.setUtilities(input: "PID Get")
                        }
                        else {
                            bluetoothDevice.setUtilities(input: "PID Stop")
                        }
                        getData.toggle()
                        
                    }) {
                        Text(!getData ? "Get Data" : "Stop")
                            .font(.title2)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(Color("Light Gray"))
                        .cornerRadius(10)
                    Spacer()
                    Button(action: {
                        rocket.resetPIDCommands()
                    }) {
                        Text("Reset All")
                            .font(.title2)
                    }.buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(Color("Light Gray"))
                        .cornerRadius(10)
                    Spacer()
                }.onDisappear(perform: {
                    bluetoothDevice.setUtilities(input: "PID Stop")
                })
                Section {
                    Text("Pitch Command")
                        .font(.title2)
                        .padding(.top)
                    ChartStyle().getGraph(datasets: rocket.getPitchCommand(), colour: .green)
                    
                    Text("Roll Command")
                        .font(.title2)
                    ChartStyle().getGraph(datasets: rocket.getRollCommand(), colour: .blue)
                    
                    Text("Yaw Command")
                        .font(.title2)
                    ChartStyle().getGraph(datasets: rocket.getYawCommand(), colour: .red)
                }
            }.onDisappear(perform: {
                bluetoothDevice.setUtilities(input: "10")
            })
            .hideKeyboardWhenTappedAround()
        }
    }
}

struct TVC_PIDView_Previews: PreviewProvider {
    static var previews: some View {
        TVC_PIDView()
    }
}
