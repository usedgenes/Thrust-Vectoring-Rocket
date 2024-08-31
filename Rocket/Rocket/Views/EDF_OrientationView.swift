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
                Text("BMI088 Data Graphs")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                HStack {
                    Button(action: {
                        bluetoothDevice.setBNO08X(input: "11")
                        getData.toggle()
                    }) {
                        Text("Get Data")
                    }.disabled(getData)
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: {
                        bluetoothDevice.setBNO08X(input: "10")
                        getData.toggle()
                    }) {
                        Text("Stop")
                    }.disabled(!getData)
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    Button(action: {
                        edf.resetRotation()
                    }) {
                        Text("Reset All")
                    }.buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                }.padding(.bottom)
            }.onDisappear(perform: {
                bluetoothDevice.setBNO08X(input: "10")
            })
            
            Text("Yaw Velocity")
            ChartStyle().getGraph(datasets: edf.getYawVelocity(), colour: .red)
            
            Text("Pitch")
            ChartStyle().getGraph(datasets: edf.getPitch(), colour: .green)
            
            Text("Roll")
            ChartStyle().getGraph(datasets: edf.getRoll(), colour: .blue)
        }
    }
}

struct EDF_OrientationView_Previews: PreviewProvider {
    static var previews: some View {
        EDF_OrientationView()
    }
}
