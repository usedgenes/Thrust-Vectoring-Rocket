//
//  EDF_PIDView.swift
//  Rocket
//
//  Created by Eugene on 8/31/24.
//

import SwiftUI

struct EDF_PIDView : View {
    @EnvironmentObject var edf : EDF
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    
    var body: some View {
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
                            TextField(edf.pitchKp, text: Binding<String>(
                                get: { edf.pitchKp },
                                set: {
                                    edf.pitchKp = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                        HStack {
                            Text("Ki:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(edf.pitchKi, text: Binding<String>(
                                get: { edf.pitchKi },
                                set: {
                                    edf.pitchKi = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                        HStack {
                            Text("Kd:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(edf.pitchKd, text: Binding<String>(
                                get: { edf.pitchKd },
                                set: {
                                    edf.pitchKd = $0
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
                            TextField(edf.rollKp, text: Binding<String>(
                                get: { edf.rollKp },
                                set: {
                                    edf.rollKp = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                        HStack {
                            Text("Ki:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(edf.rollKi, text: Binding<String>(
                                get: { edf.rollKi },
                                set: {
                                    edf.rollKi = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                        HStack {
                            Text("Kd:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(edf.rollKd, text: Binding<String>(
                                get: { edf.rollKd },
                                set: {
                                    edf.rollKd = $0
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
                            TextField(edf.yawKp, text: Binding<String>(
                                get: { edf.yawKp },
                                set: {
                                    edf.yawKp = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                        HStack {
                            Text("Ki:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(edf.yawKi, text: Binding<String>(
                                get: { edf.yawKi },
                                set: {
                                    edf.yawKi = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                        HStack {
                            Text("Kd:")
                                .font(.title2)
                                .padding(.leading)
                            Spacer()
                            TextField(edf.yawKd, text: Binding<String>(
                                get: { edf.yawKd },
                                set: {
                                    edf.yawKd = $0
                                }))
                            .keyboardType(UIKeyboardType.decimalPad)
                            .font(.title2)
                        }
                    }
                }.hideKeyboardWhenTappedAround()
                HStack {
                    Spacer()
                    Button(action: {
                        bluetoothDevice.setPID(input: "0" + edf.rollKp + "," + edf.rollKi + "!" + edf.rollKd)
                        bluetoothDevice.setPID(input: "1" + edf.pitchKp + "," + edf.pitchKi + "!" + edf.pitchKd)
                        bluetoothDevice.setPID(input: "2" + edf.yawKp + "," + edf.yawKi + "!" + edf.yawKd)
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
                            bluetoothDevice.setPID(input: "31")
                        }
                        else {
                            bluetoothDevice.setPID(input: "31")
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
                        edf.resetPIDCommands()
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
                    bluetoothDevice.setPID(input: "30")
                })
                

                
                Text("Pitch Command")
                    .font(.title2)
                    .padding(.top)
                ChartStyle().getGraph(datasets: edf.getPitchCommand(), colour: .green)
                
                Text("Roll Command")
                    .font(.title2)
                ChartStyle().getGraph(datasets: edf.getRollCommand(), colour: .blue)
                
                Text("Yaw Command")
                    .font(.title2)
                ChartStyle().getGraph(datasets: edf.getYawCommand(), colour: .red)
            }
        }
    }
}

struct EDF_PIDView_Previews: PreviewProvider {
    static var previews: some View {
        EDF_PIDView()
    }
}
