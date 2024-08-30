import SwiftUI

struct ParachuteEjectionView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @EnvironmentObject var rocket : Rocket
    @State var getLoopTime = false
    @State var servoPosition : Double = 90
    var body: some View {
        ScrollView {
            Text("Parachute Ejection")
                .font(.largeTitle)
                .fontWeight(.bold)
            HStack {
                Button(action: {
                    if(!getLoopTime) {
                        bluetoothDevice.setUtilities(input: "Time Get")
                    }
                    else {
                        bluetoothDevice.setUtilities(input: "Time Stop")
                        rocket.deltaTime = "-1"
                    }
                    getLoopTime.toggle()
                }) {
                    Text("Refresh Rate: ")
                        .font(.title3)
                        .foregroundColor(.black)
                }.padding(.leading)
                Text(rocket.deltaTime + " ms")
                    .font(.title3)
                Spacer()
                Text(bluetoothDevice.isConnected ? "Connected" : "Not Connected")
                    .foregroundColor(bluetoothDevice.isConnected ? .green : .red)
                    .padding(.trailing)
                    .font(.title3)
            }
            .padding(.top, 12)
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    bluetoothDevice.setUtilities(input: "Arm")
                }) {
                    Text("Arm Rocket")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(Color("Light Gray"))
                .cornerRadius(10)
                Button(action: {
                    bluetoothDevice.setUtilities(input: "Reset")
                    rocket.reset()
                    let seconds = 0.2
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        if(bluetoothDevice.isConnected) {
                            bluetoothDevice.disconnect()
                        }
                    }
                }) {
                    Text("Reset Rocket")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(Color("Light Gray"))
                .cornerRadius(10)
                Spacer()
            }
            Divider()
            Section {
                HStack {
                    Spacer()
                    NavigationLink {
                        BluetoothConnectView()
                    } label: {
                        Text("Connect Bluetooth")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color("Light Gray"))
                    .cornerRadius(10)
                    Spacer()
                }
                Divider()
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Text("Lock Spring")
                            .font(.title2)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(Color("Light Gray"))
                        .cornerRadius(10)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Text("Unlock Spring")
                            .font(.title2)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(Color("Light Gray"))
                        .cornerRadius(10)
                    Spacer()
                }
                HStack {
                    Text("Servo: " + String(Int(servoPosition)))
                        .padding(.trailing)
                        .font(.title3)
                    Slider(value: Binding(get: {
                        servoPosition
                    }, set: { (newVal) in
                        servoPosition = newVal
                    }), in: (0...180), step: 1) { editing in
                        if(!editing) {
                            bluetoothDevice.setServos(input: "0" + String(Int(servoPosition)))
                        }
                    }
                }.padding()
                Divider()
                HStack {
                    VStack {
                        HStack {
                            Button(action: {
                                bluetoothDevice.setUtilities(input: "Bypass Pad")
                            }) {
                                Text("On Pad")
                                    .frame(alignment: .leading)
                                    .foregroundColor(.black)
                                    .font(.title3)
                            }
                            .padding(.leading)
                            Spacer()
                            Image(systemName: rocket.onPad ? "checkmark" : "xmark")
                                .foregroundColor(rocket.onPad ? .green : .red)
                                .padding()
                        }
                        HStack {
                            Button(action: {
                                bluetoothDevice.setUtilities(input: "Bypass Coasting")
                            }) {
                                Text("Ascending")
                                    .frame(alignment: .leading)
                                    .foregroundColor(.black)
                                    .font(.title3)

                            }
                            .padding()
                            Spacer()
                            Image(systemName: rocket.coasting ? "checkmark" : "xmark")
                                .foregroundColor(rocket.coasting ? .green : .red)
                                .padding()
                        }
                        HStack {
                            Button(action: {
                                bluetoothDevice.setUtilities(input: "Bypass Parachute")
                            }) {
                                Text("Altimeter Ejected")
                                    .frame(alignment: .leading)
                                    .foregroundColor(.black)
                                    .font(.title3)
                            }
                            .padding()
                            Spacer()
                            Image(systemName: rocket.parachuteOut ? "checkmark" : "xmark")
                                .foregroundColor(rocket.parachuteOut ? .green : .red)
                                .padding()
                        }
                        HStack {
                            Button(action: {
                            }) {
                                Text("Recovery")
                                    .frame(alignment: .leading)
                                    .foregroundColor(.black)
                                    .font(.title3)
                            }
                            .padding()
                            Spacer()
                            Image(systemName: rocket.touchdown ? "checkmark" : "xmark")
                                .foregroundColor(rocket.touchdown ? .green : .red)
                                .padding()
                        }
                        HStack {
                            Button(action: {
                            }) {
                                Text("Touchdown")
                                    .frame(alignment: .leading)
                                    .foregroundColor(.black)
                                    .font(.title3)
                            }
                            .padding()
                            Spacer()
                            Image(systemName: rocket.touchdown ? "checkmark" : "xmark")
                                .foregroundColor(rocket.touchdown ? .green : .red)
                                .padding()
                        }
                    }
                    Divider()
                    VStack {
                        HStack {
                            Text("Logs:")
                                .padding()
                                .font(.title3)
                            Spacer()
                            Button(action: {
                                rocket.clearLogs()
                            }) {
                                Text("Clear")
                                    .font(.title3)
                                    .buttonStyle(.borderless)
                                    .padding()
                            }
                        }
                        Text(rocket.logs)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                    }
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
            .onDisappear(perform: {
                bluetoothDevice.setUtilities(input: "Time Stop")
            })
    }
}

struct ParachuteEjectionView_Previews: PreviewProvider {
    static var previews: some View {
        ParachuteEjectionView()
    }
}
