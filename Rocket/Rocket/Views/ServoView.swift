import SwiftUI

struct ServoView : View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var servo0Position : Double = 0
    @State var servo1Position : Double = 0
    @State var maxPosition : Double = 15
    @State var setHomePosition = false
    
    var body: some View {
        Section {
            Text("Gimbal Servo Positions")
                .font(.title)
                .fontWeight(.bold)
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    setHomePosition.toggle()
                }) {
                    Text("Open Parachute")
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
                    setHomePosition.toggle()
                }) {
                    Text("Close Parachute")
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
                }), in: (setHomePosition ? 0...180 : -maxPosition...maxPosition), step: 1) { editing in
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
                }), in: (setHomePosition ? 0...180 : -maxPosition...maxPosition), step: 1) { editing in
                    if(!editing) {
                        bluetoothDevice.setServos(input: "1" + String(Int(servo1Position)))
                    }
                }
            }.padding()
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

        .onAppear(perform: {
            bluetoothDevice.setServos(input: "Get Max Position")
        })
        .onDisappear(perform: {
            bluetoothDevice.setServos(input: "10")
        })
        .hideKeyboardWhenTappedAround()
    }
}



struct ServoView_Previews: PreviewProvider {
    static var previews: some View {
        ServoView()
    }
}
