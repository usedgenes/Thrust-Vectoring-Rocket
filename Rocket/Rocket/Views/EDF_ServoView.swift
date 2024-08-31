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
    @State var servo0Position : Double = 0
    @State var servo1Position : Double = 0
    @State var servo2Position : Double = 0
    @State var servo3Position : Double = 0
    @State var getData = false
    
    var body: some View {
        ScrollView {
            Text("Servo Position Graphs")
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
            HStack {
                Text("Servo 0: " + String(Int(servo0Position)))
                    .padding(.trailing)
                    .font(.title3)
                Slider(value: Binding(get: {
                    servo0Position
                }, set: { (newVal) in
                    servo0Position = newVal
                }), in: -30...30, step: 1) { editing in
                    if(!editing) {
                        bluetoothDevice.setServos(input: "0" + String(Int(servo0Position)))
                    }
                }
            }.padding()
            HStack {
                Text("Servo 1: " + String(Int(servo1Position)))
                    .padding(.trailing)
                    .font(.title3)
                Slider(value: Binding(get: {
                    servo1Position
                }, set: { (newVal) in
                    servo1Position = newVal
                }), in: -30...30, step: 1) { editing in
                    if(!editing) {
                        bluetoothDevice.setServos(input: "1" + String(Int(servo1Position)))
                    }
                }
            }.padding()
            HStack {
                Text("Servo 2: " + String(Int(servo2Position)))
                    .padding(.trailing)
                    .font(.title3)
                Slider(value: Binding(get: {
                    servo2Position
                }, set: { (newVal) in
                    servo2Position = newVal
                }), in: -30...30, step: 1) { editing in
                    if(!editing) {
                        bluetoothDevice.setServos(input: "2" + String(Int(servo2Position)))
                    }
                }
            }.padding()
            HStack {
                Text("Servo 3: " + String(Int(servo3Position)))
                    .padding(.trailing)
                    .font(.title3)
                Slider(value: Binding(get: {
                    servo3Position
                }, set: { (newVal) in
                    servo3Position = newVal
                }), in: -30...30, step: 1) { editing in
                    if (!editing) {
                        bluetoothDevice.setServos(input: "3" + String(Int(servo3Position)))
                    }
                }
            }.padding()
            Divider()
            Section {
                HStack {
                    Spacer()
                    Button(action: {
                        if(!getData) {
                            bluetoothDevice.setServos(input: "11")
                        }
                        else {
                            bluetoothDevice.setServos(input: "10")
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
                        edf.resetServoPos()
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
                Divider()
                Section {
                    Text("Servo 0 Position")
                        .font(.title2)
                        .padding(.top)
                    ChartStyle().getGraph(datasets: edf.getServo0Pos(), colour: .red)
                    
                    Text("Servo 1 Position")
                        .font(.title2)
                    ChartStyle().getGraph(datasets: edf.getServo1Pos(), colour: .green)
                    
                    Text("Servo 2 Position")
                        .font(.title2)
                    ChartStyle().getGraph(datasets: edf.getServo2Pos(), colour: .blue)
                    
                    Text("Servo 3 Position")
                        .font(.title2)
                    ChartStyle().getGraph(datasets: edf.getServo3Pos(), colour: .yellow)
                }.onDisappear(perform: {
                    bluetoothDevice.setServos(input: "10")
                })
            }
        }
    }
}

struct EDF_ServoView_Previews: PreviewProvider {
    static var previews: some View {
        EDF_ServoView()
    }
}
