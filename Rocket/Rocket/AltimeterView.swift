import SwiftUI

struct AltimeterView: View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    
    var body: some View {
        ScrollView {
            Section {
                Text("Altimeter Graphs")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                HStack {
                    Button(action: {
                        bluetoothDevice.setBMP390(input: "Altimeter Get")
                        getData.toggle()
                    }) {
                        Text("Get Data")
                    }.disabled(getData)
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: {
                        bluetoothDevice.setBMP390(input: "Altimeter Stop")
                        getData.toggle()
                    }) {
                        Text("Stop")
                    }.disabled(!getData)
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    Button(action: {
                        rocket.resetAltitude()
                    }) {
                        Text("Reset All")
                    }.buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                }.padding(.bottom)
            }.onDisappear(perform: {
                bluetoothDevice.setBMP390(input: "Altimeter Stop")
            })
            Section {
                Text("Altitude")
                ChartStyle().getGraph(datasets: rocket.getAltitude(), colour: .red)
            }
        }
    }
}

struct AltimeterView_Previews: PreviewProvider {
    static var previews: some View {
        AltimeterView()
    }
}
