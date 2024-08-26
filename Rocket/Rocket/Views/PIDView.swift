import SwiftUI


struct PIDView : View {
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
                    HStack {
                        Spacer()
                        Text("Pitch")
                            .font(.title2)
                            .padding(.leading)
                        Menu {
                            Picker(selection: $selectedPitchCoefficient) {
                                ForEach(coefficientType, id: \.self) {
                                    Text($0)
                                }
                            } label: {}
                        } label: {
                            Text(selectedPitchCoefficient + ":")
                                .font(.title2)
                        }.padding(.trailing)
                        TextField(pitchCoefficient, text: Binding<String>(
                            get: { pitchCoefficient },
                            set: {
                                pitchCoefficient = $0
                                if(selectedPitchCoefficient == "Kp") {
                                    rocket.pitchKp = pitchCoefficient
                                }
                                else if(selectedPitchCoefficient == "Ki") {
                                    rocket.pitchKi = pitchCoefficient
                                }
                                else if(selectedPitchCoefficient == "Kd") {
                                    rocket.pitchKd = pitchCoefficient
                                }
                            }))
                        .keyboardType(UIKeyboardType.decimalPad)
                        .font(.title2)
                        .padding(.horizontal)
                        Spacer()
                    }
                    Divider()
                    Button(action: {
                        bluetoothDevice.setPID(input: "0" + rocket.pitchKp + "," + rocket.pitchKi + "!" + rocket.pitchKd)
                    }) {
                        Text("Apply")
                            .font(.title2)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(Color("Light Gray"))
                        .cornerRadius(10)
                }
                HStack {
                    HStack {
                        Spacer()
                        Text("Roll")
                            .font(.title2)
                            .padding(.leading)
                        Menu {
                            Picker(selection: $selectedRollCoefficient) {
                                ForEach(coefficientType, id: \.self) {
                                    Text($0)
                                }
                            } label: {}
                        } label: {
                            Text(selectedRollCoefficient + ":")
                                .font(.title2)
                        }.padding(.trailing)
                        TextField(rollCoefficient, text: Binding<String>(
                            get: { rollCoefficient },
                            set: {
                                rollCoefficient = $0
                                if(selectedRollCoefficient == "Kp") {
                                    rocket.rollKp = rollCoefficient
                                }
                                else if(selectedRollCoefficient == "Ki") {
                                    rocket.rollKi = rollCoefficient
                                }
                                else if(selectedRollCoefficient == "Kd") {
                                    rocket.rollKd = rollCoefficient
                                }
                            }))
                        .keyboardType(UIKeyboardType.decimalPad)
                        .font(.title2)
                        .padding(.horizontal)
                        Spacer()
                    }
                    Divider()
                    Button(action: {
                        bluetoothDevice.setPID(input: "0" + rocket.rollKp + "," + rocket.rollKi + "!" + rocket.rollKd)
                    }) {
                        Text("Apply")
                            .font(.title2)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(Color("Light Gray"))
                        .cornerRadius(10)
                }
                HStack {
                    HStack {
                        Spacer()
                        Text("Yaw")
                            .font(.title2)
                            .padding(.leading)
                        Menu {
                            Picker(selection: $selectedYawCoefficient) {
                                ForEach(coefficientType, id: \.self) {
                                    Text($0)
                                }
                            } label: {}
                        } label: {
                            Text(selectedYawCoefficient + ":")
                                .font(.title2)
                        }.padding(.trailing)
                        TextField(yawCoefficient, text: Binding<String>(
                            get: { yawCoefficient },
                            set: {
                                yawCoefficient = $0
                                if(selectedYawCoefficient == "Kp") {
                                    rocket.yawKp = yawCoefficient
                                }
                                else if(selectedRollCoefficient == "Ki") {
                                    rocket.yawKi = yawCoefficient
                                }
                                else if(selectedRollCoefficient == "Kd") {
                                    rocket.yawKd = yawCoefficient
                                }
                            }))
                        .keyboardType(UIKeyboardType.decimalPad)
                        .font(.title2)
                        .padding(.horizontal)
                        Spacer()
                    }
                    Divider()
                    Button(action: {
                        bluetoothDevice.setPID(input: "0" + rocket.rollKp + "," + rocket.rollKi + "!" + rocket.rollKd)
                    }) {
                        Text("Apply")
                            .font(.title2)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(Color("Light Gray"))
                        .cornerRadius(10)
                }
            }.hideKeyboardWhenTappedAround()
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
                Text("Yaw Command")
                    .font(.title2)
                    .padding(.top)
                ChartStyle().getGraph(datasets: rocket.getYawCommand(), colour: .red)
                
                Text("Pitch Command")
                    .font(.title2)
                ChartStyle().getGraph(datasets: rocket.getPitchCommand(), colour: .green)
                
                Text("Roll Command")
                    .font(.title2)
                ChartStyle().getGraph(datasets: rocket.getRollCommand(), colour: .blue)
            }
        }.onDisappear(perform: {
            bluetoothDevice.setUtilities(input: "10")
        })
    }
}


struct PIDView_Previews: PreviewProvider {
    static var previews: some View {
        PIDView()
    }
}
