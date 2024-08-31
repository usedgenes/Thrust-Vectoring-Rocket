//
//  EDF_ServoView.swift
//  Rocket
//
//  Created by Eugene on 8/31/24.
//

import SwiftUI


struct EDF_ServoView : View {
    @EnvironmentObject var edf : EDF
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    
    var body: some View {
        ScrollView {
            Section {
                Text("Servo Position Graphs")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                HStack {
                    Button(action: {
                        bluetoothDevice.setServos(input: "11")
                        getData.toggle()
                    }) {
                        Text("Get Data")
                    }.disabled(getData)
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: {
                        bluetoothDevice.setServos(input: "10")
                        getData.toggle()
                    }) {
                        Text("Stop")
                    }.disabled(!getData)
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    Button(action: {
                        edf.resetServoPos()
                    }) {
                        Text("Reset All")
                    }.buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                }.padding(.bottom)
            }.onDisappear(perform: {
                bluetoothDevice.setServos(input: "10")
            })
            
            Text("Servo 0 Position")
            ChartStyle().getGraph(datasets: edf.getServo0Pos(), colour: .red)
            
            Text("Servo 1 Position")
            ChartStyle().getGraph(datasets: edf.getServo1Pos(), colour: .green)
            
            Text("Servo 2 Position")
            ChartStyle().getGraph(datasets: edf.getServo2Pos(), colour: .blue)
            
            Text("Servo 3 Position")
            ChartStyle().getGraph(datasets: edf.getServo3Pos(), colour: .yellow)
        }
    }
}


struct EDF_ServoView_Previews: PreviewProvider {
    static var previews: some View {
        EDF_ServoView()
    }
}
