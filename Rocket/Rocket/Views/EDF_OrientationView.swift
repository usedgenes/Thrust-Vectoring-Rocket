//
//  EDF_ORientationView.swift
//  Rocket
//
//  Created by Eugene on 8/31/24.
//

import SwiftUI

struct EDF_OrientationView : View {
    @EnvironmentObject var edf : EDF
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    var body : some View {
        ScrollView {
            Section {
                Text("Orientation Graphs")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Divider()
                HStack {
                    Text("EDF Power: " + String(Int(edf.edfPower)))
                        .padding(.trailing)
                        .font(.title3)
                    Slider(value: Binding(get: {
                        edf.edfPower
                    }, set: { (newVal) in
                        edf.edfPower = newVal
                    }), in: 50...180, step: 1) { editing in
                        if(!editing) {
                            bluetoothDevice.setServos(input: "4" + String(Int(edf.edfPower)))
                        }
                    }
                }.padding()
                Divider()
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            if(!getData) {
                                bluetoothDevice.setBNO08X(input: "11")
                            }
                            else {
                                bluetoothDevice.setBNO08X(input: "10")
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
                            edf.resetRotation()
                        }) {
                            Text("Reset All")
                                .font(.title2)
                        }.buttonStyle(BorderlessButtonStyle())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .background(Color("Light Gray"))
                            .cornerRadius(10)
                        Spacer()
                    }
                }.onDisappear(perform: {
                    bluetoothDevice.setBNO08X(input: "10")
                })
                Section {
                    Text("Yaw Velocity")
                        .font(.title2)
                        .padding(.top)
                    ChartStyle().getGraph(datasets: edf.getYawVelocity(), colour: .red)
                    
                    Text("Pitch")
                        .font(.title2)
                    ChartStyle().getGraph(datasets: edf.getPitch(), colour: .green)
                    
                    Text("Roll")
                        .font(.title2)
                    ChartStyle().getGraph(datasets: edf.getRoll(), colour: .blue)
                }
            }
        }
    }
}

struct EDF_OrientationView_Previews: PreviewProvider {
    static var previews: some View {
        EDF_OrientationView()
    }
}
