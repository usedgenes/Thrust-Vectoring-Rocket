//
//  BMI088View.swift
//  Rocket
//
//  Created by Eugene on 8/25/24.
//

import SwiftUI

struct BMI088View: View {
    var body: some View {
        Text("BMI088 Data Graphs")
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
        HStack {
            Button(action: {
                bluetoothDevice.setBMI088(input: "BMI088 Get")
                getData.toggle()
            }) {
                Text("Get Data")
            }.disabled(getData)
                .buttonStyle(BorderlessButtonStyle())
                .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: {
                bluetoothDevice.setBMI088(input: "BMI088 Stop")
                getData.toggle()
            }) {
                Text("Stop")
            }.disabled(!getData)
                .buttonStyle(BorderlessButtonStyle())
                .frame(maxWidth: .infinity, alignment: .center)
            Button(action: {
                rocket.resetRotation()
            }) {
                Text("Reset All")
            }.buttonStyle(BorderlessButtonStyle())
                .frame(maxWidth: .infinity, alignment: .center)
            Button(action: {
                bluetoothDevice.setBMI088(input: "1")
            }) {
                Text("Calibrate")
            }.buttonStyle(BorderlessButtonStyle())
                .frame(maxWidth: .infinity, alignment: .center)
        }.padding(.bottom)
    }.onDisappear(perform: {
        bluetoothDevice.setBMI088(input: "BMI088 Stop")
    })
    
    Text("Yaw")
    ChartStyle().getGraph(datasets: rocket.getYaw(), colour: .red)
    
    Text("Pitch")
    ChartStyle().getGraph(datasets: rocket.getPitch(), colour: .green)
    
    Text("Roll")
    ChartStyle().getGraph(datasets: rocket.getRoll(), colour: .blue)
    }
}

struct BMI088View_Previews: PreviewProvider {
    static var previews: some View {
        BMI088View()
    }
}
