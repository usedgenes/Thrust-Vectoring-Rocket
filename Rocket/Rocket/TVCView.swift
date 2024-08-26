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
                Spacer()
                Button(action: {
                    bluetoothDevice.setUtilities(input: "Arm")
                }) {
                    Text("Arm Rocket")
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(Color("Gray"))
                .cornerRadius(10)
                Button(action: {
                    bluetoothDevice.setUtilities(input: "Reset")
                    rocket.reset()
                }) {
                    Text("Reset Rocket")
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(Color("Gray"))
                .cornerRadius(10)
                Spacer()
            }
            Section {
                    NavigationLink {
                        BluetoothConnectView()
                    } label: {
                        Text("Connect Bluetooth:")
                            .foregroundColor(.black)
                    }
                    ..frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color("Gray"))
                    .cornerRadius(10)
                
                    NavigationLink {
                        OrientationView()
                    } label: {
                        Text("View Orientation:")
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color("Gray"))
                    .cornerRadius(10)

                    NavigationLink {
                        BMI088View()
                    } label: {
                        Text("View BMI088:")
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color("Gray"))
                    .cornerRadius(10)
                
                NavigationLink {
                    AltimeterView()
                } label: {
                    Text("View Altimeter:")
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(Color("Gray"))
                .cornerRadius(10)
                
                NavigationLink {
                    ServoView()
                } label: {
                    Text("View Servos:")
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(Color("Gray"))
                .cornerRadius(10)

                NavigationLink {
                    PIDView()
                } label: {
                    Text("View PID:")
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(Color("Gray"))
                .cornerRadius(10)
            }
            
            HStack {
                Button(action: {
                    if(!getLoopTime) {
                        bluetoothDevice.setUtilities(input: "Time Get")
                    }
                    else {
                        bluetoothDevice.setUtilities(input: "Time Stop")
                    }
                    getLoopTime.toggle()
                }) {
                    Text("Refresh Rate: ")
                        .foregroundColor(.black)
                }.padding(.leading)
                Text(rocket.deltaTime + " ms")
                Spacer()
                Text(bluetoothDevice.isConnected ? "Connected" : "Not Connected")
                    .foregroundColor(bluetoothDevice.isConnected ? .green : .red)
                    .padding()
            }
            .background(Color("Gray"))
            .cornerRadius(10)
            .padding()
            
            Section {
                HStack {
                    Button(action: {
                        bluetoothDevice.setUtilities(input: "Bypass Pad")
                    }) {
                        Text("On Pad")
                    }
                    .padding()
                    .buttonStyle(.borderless)
                    Image(systemName: rocket.onPad ? "checkmark" : "xmark")
                        .foregroundColor(rocket.onPad ? .green : .red)
                        .padding()
                }
                HStack {
                    Button(action: {
                        bluetoothDevice.setUtilities(input: "Bypass TVC")
                    }) {
                        Text("TVC Active")
                    }
                    .padding()
                    .buttonStyle(.borderless)
                    Image(systemName: rocket.tvcActive ? "checkmark" : "xmark")
                        .foregroundColor(rocket.tvcActive ? .green : .red)
                        .padding()
                }
                HStack {
                    Button(action: {
                        bluetoothDevice.setUtilities(input: "Bypass Coasting")
                    }) {
                        Text("Coasting")
                    }
                    .padding()
                    .buttonStyle(.borderless)
                    Image(systemName: rocket.coasting ? "checkmark" : "xmark")
                        .foregroundColor(rocket.coasting ? .green : .red)
                        .padding()
                }
                HStack {
                    Button(action: {
                        bluetoothDevice.setUtilities(input: "Bypass Parachute")
                    }) {
                        Text("Parachute Out")
                    }
                    .padding()
                    .buttonStyle(.borderless)
                    Image(systemName: rocket.parachuteOut ? "checkmark" : "xmark")
                        .foregroundColor(rocket.parachuteOut ? .green : .red)
                        .padding()
                }
                HStack {
                    Button(action: {
                    }) {
                        Text("Touchdown")
                    }
                    .padding()
                    .buttonStyle(.borderless)
                    Image(systemName: rocket.touchdown ? "checkmark" : "xmark")
                        .foregroundColor(rocket.touchdown ? .green : .red)
                        .padding()
                }
            }
            Divider()
            Section {
                HStack {
                    Text(rocket.logs)
                        .padding()
                        .font(.title3)
                    Spacer()
                    Button(action: {
                        rocket.clearLogs()
                    }) {
                        Text("Clear Logs")
                            .font(.title3)
                            .buttonStyle(.borderless)
                            .padding()
                    }
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
