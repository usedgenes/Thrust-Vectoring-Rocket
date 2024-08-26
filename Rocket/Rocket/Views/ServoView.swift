import SwiftUI

struct ServoView : View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    @State var servo0Position : Double = 0
    @State var servo1Position : Double = 0
    @State var setHomePosition = false
    @State var parachuteServoOpen = true
    
    var body: some View {
        Section {
            Text("Gimbal Servo Positions")
                .font(.title)
                .fontWeight(.bold)
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    parachuteServoOpen.toggle()
                }) {
                    Text(parachuteServoOpen ? "Close Parachute" : "Open Parachute")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(Color("Light Gray"))
                .cornerRadius(10)
                Spacer()
                Button(action: {
                    bluetoothDevice.setServos(input: "90")
                }) {
                    Text("Rotate Gimbal")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(Color("Light Gray"))
                .cornerRadius(10)
                .disabled(setHomePosition)
                Spacer()
            }
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    setHomePosition.toggle()
                }) {
                    Text(setHomePosition ? "Home Servos" : "Move Servos")
                        .font(.title2)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(Color("Light Gray"))
                .cornerRadius(10)
                Spacer()
                Button(action: {
                    bluetoothDevice.setServos(input: "90")
                }) {
                    Text("Set As Origin")
                        .font(.title2)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(Color("Light Gray"))
                .cornerRadius(10)
                .disabled(!setHomePosition)
                Spacer()
            }
            Divider()
            HStack {
                Text("Servo 0: " + String(Int(servo0Position)))
                    .padding(.trailing)
                    .font(.title3)
                Slider(value: Binding(get: {
                    servo0Position
                }, set: { (newVal) in
                    servo0Position = newVal
                }), in: (setHomePosition ? 0...180 : -rocket.maxPosition...rocket.maxPosition), step: 1) { editing in
                    if(!editing) {
                        bluetoothDevice.setServos(input: "0" + String(Int(servo0Position)))
                    }
                }
                Button(action: {
                    bluetoothDevice.setServos(input: "90")
                }) {
                    Text("Home")
                        .font(.title3)
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
                }), in: (setHomePosition ? 0...180 : -rocket.maxPosition...rocket.maxPosition), step: 1) { editing in
                    if(!editing) {
                        bluetoothDevice.setServos(input: "1" + String(Int(servo1Position)))
                    }
                }
                Button(action: {
                    bluetoothDevice.setServos(input: "90")
                }) {
                    Text("Home")
                        .font(.title3)
                }
            }.padding()
            Divider()
            Section {
                HStack {
                    Spacer()
                    Button(action: {
                        if(!getData) {
                            bluetoothDevice.setUtilities(input: "Servo Get")
                        }
                        else {
                            bluetoothDevice.setUtilities(input: "Servo Stop")
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
                        rocket.resetServoPos()
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
                    bluetoothDevice.setUtilities(input: "Servo Stop")
                })
                Divider()
                Section {
                    Text("Servo 0 Position")
                        .font(.title2)
                        .padding(.top)
                    ChartStyle().getGraph(datasets: rocket.getServo0Pos(), colour: .red)
                    
                    Text("Servo 1 Position")
                        .font(.title2)
                    ChartStyle().getGraph(datasets: rocket.getServo1Pos(), colour: .green)
                }
            }
        }
    }
}



struct ServoView_Previews: PreviewProvider {
    static var previews: some View {
        ServoView()
    }
}
