//
//  AltimeterEjectionView.swift
//  Rocket
//
//  Created by Eugene on 8/30/24.
//

import SwiftUI

struct AltimeterEjectionView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @EnvironmentObject var rocket : Rocket
    @State var getLoopTime = false
    @State var timeRemaining: Int = 5
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timerOn = false
    @State var timerFired = false
    @State var servoPosition : Int = 90
    var body: some View {
        ScrollView {
            Text("Altimeter Ejection")
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
                    VStack {
                        Button(action: {
                            bluetoothDevice.setServos(input: "Close Servo")
                        }) {
                            Text("Lock Spring")
                                .font(.title2)
                        }.frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("Light Gray"))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        Button(action: {
                            bluetoothDevice.setServos(input: "Open Servo")
                        }) {
                            Text("Unlock Spring")
                                .font(.title2)
                        }.frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("Light Gray"))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        HStack {
                            Text("Servo:")
                                .font(.title2)
                            TextField("\(servoPosition)", text: Binding<String>(
                                get: { String(servoPosition) },
                                set: {
                                    if let value = NumberFormatter().number(from: $0) {
                                        servoPosition = value.intValue
                                    }
                                }))
                            .keyboardType(UIKeyboardType.numberPad)
                            .font(.title2)
                            Button(action: {
                                bluetoothDevice.setServos(input: "4" + String(servoPosition))
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                                to: nil, from: nil, for: nil)
                            }) {
                                Image(systemName: "paperplane.fill")
                            }.buttonStyle(BorderlessButtonStyle())
                        }.padding(.horizontal)
                            .padding(.top)
                    }
                    Divider()
                    VStack {
                        Text("Timer")
                            .font(.title)
                            .padding(.bottom)
                        HStack {
                            VStack {
                                Button(action: {
                                    if(timerOn) {
                                        self.timer.upstream.connect().cancel()
                                        timerOn = false
                                    }
                                    else {
                                        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                                        timerOn = true
                                    }
                                }) {
                                    Text(timerOn ? "Stop" : "Start")
                                        .font(.title2)
                                }.frame(maxWidth: .infinity)
                                    .padding(.vertical)
                                    .background(Color("Light Gray"))
                                    .cornerRadius(10)
                                Button(action: {
                                    self.timer.upstream.connect().cancel()
                                    timerOn = false
                                    timeRemaining = 5
                                }) {
                                    Text("Reset")
                                        .font(.title2)
                                }.frame(maxWidth: .infinity)
                                    .padding(.vertical)
                                    .background(Color("Light Gray"))
                                    .cornerRadius(10)
                            }
                            Text(String(timeRemaining))
                                .font(.largeTitle)
                                .onAppear() {
                                    timer.upstream.connect().cancel()
                                }
                                .onReceive(timer) { _ in
                                    if(timeRemaining > 0) {
                                        timeRemaining -= 1
                                    }
                                    else if(timeRemaining == 0 && !timerFired) {
                                        bluetoothDevice.setServos(input: "hi")
                                        timerFired = true
                                    }
                                }
                                .frame(maxWidth: .infinity)
                        }
                    }
                }.hideKeyboardWhenTappedAround()
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

struct AltimeterEjectionView_Previews: PreviewProvider {
    static var previews: some View {
        AltimeterEjectionView()
    }
}
