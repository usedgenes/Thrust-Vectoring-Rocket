//
//  ControlPanelView.swift
//  Rocket
//
//  Created by Eugene on 8/25/24.
//

import SwiftUI

struct TVCView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @EnvironmentObject var rocket : Rocket
    @State var getLoopTime = false
    
    var body: some View {
        ScrollView {
            Text("TVC Control Panel")
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
                
                HStack {
                    Spacer()
                    NavigationLink {
                        TVC_OrientationView()
                    } label: {
                        Text("View Orientation")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color("Light Gray"))
                    .cornerRadius(10)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    NavigationLink {
                        TVC_AltimeterView()
                    } label: {
                        Text("View Altimeter")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color("Light Gray"))
                    .cornerRadius(10)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    NavigationLink {
                        TVC_BMI088View()
                    } label: {
                        Text("View BMI088")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color("Light Gray"))
                    .cornerRadius(10)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    NavigationLink {
                        TVC_ServoView()
                    } label: {
                        Text("View Servos")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color("Light Gray"))
                    .cornerRadius(10)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    NavigationLink {
                        TVC_PIDView()
                    } label: {
                        Text("View PID")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color("Light Gray"))
                    .cornerRadius(10)
                    Spacer()
                }
            }
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
                            bluetoothDevice.setUtilities(input: "Bypass TVC")
                        }) {
                            Text("TVC Active")
                                .frame(alignment: .leading)
                                .foregroundColor(.black)
                                .font(.title3)
                        }
                        .padding()
                        Spacer()
                        Image(systemName: rocket.tvcActive ? "checkmark" : "xmark")
                            .foregroundColor(rocket.tvcActive ? .green : .red)
                            .padding()
                    }
                    HStack {
                        Button(action: {
                            bluetoothDevice.setUtilities(input: "Bypass Coasting")
                        }) {
                            Text("Coasting")
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
                            Text("Parachute Out")
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
        }.navigationViewStyle(StackNavigationViewStyle())
            .onDisappear(perform: {
                bluetoothDevice.setUtilities(input: "Time Stop")
            })
    }
}

struct TVCView_Previews: PreviewProvider {
    static var previews: some View {
        TVCView()
            .environmentObject(BluetoothDeviceHelper())
            .environmentObject(Rocket())
    }
}
