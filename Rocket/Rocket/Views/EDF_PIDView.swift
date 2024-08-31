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
            Section {
                Text("PID Command Graphs")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                HStack {
                    Button(action: {
                        bluetoothDevice.setPID(input: "31")
                        getData.toggle()
                    }) {
                        Text("Get Data")
                    }.disabled(getData)
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: {
                        bluetoothDevice.setPID(input: "30")
                        getData.toggle()
                    }) {
                        Text("Stop")
                    }.disabled(!getData)
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    Button(action: {
                        edf.resetPIDCommands()
                    }) {
                        Text("Reset All")
                    }.buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                }.padding(.bottom)
            }.onDisappear(perform: {
                bluetoothDevice.setPID(input: "30")
            })
            
            Text("Yaw Command")
            ChartStyle().getGraph(datasets: edf.getYawCommand(), colour: .red)
            
            Text("Pitch Command")
            ChartStyle().getGraph(datasets: edf.getPitchCommand(), colour: .green)
            
            Text("Roll Command")
            ChartStyle().getGraph(datasets: edf.getRollCommand(), colour: .blue)
        }
    }
}

struct EDF_PIDView_Previews: PreviewProvider {
    static var previews: some View {
        EDF_PIDView()
    }
}
