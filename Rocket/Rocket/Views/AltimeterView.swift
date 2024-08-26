import SwiftUI

struct AltimeterView: View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    
    var body: some View {
        Text("Altimeter Graphs")
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
        HStack {
            Spacer()
            Button(action: {
                if(!getData) {
                    bluetoothDevice.setBMP390(input: "Altimeter Get")
                }
                else {
                    bluetoothDevice.setBMP390(input: "Altimeter Stop")
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
                rocket.resetAltitude()
            }) {
                Text("Reset All")
                    .font(.title2)
            }.buttonStyle(BorderlessButtonStyle())
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(Color("Light Gray"))
                .cornerRadius(10)
            Spacer()
        }.padding(.bottom)
            .onDisappear(perform: {
                bluetoothDevice.setBMI088(input: "Altimeter Stop")
            })
        
        Text("Altitude")
            .font(.title2)
        ChartStyle().getGraph(datasets: rocket.getAltitude(), colour: .red)
    }
}

struct AltimeterView_Previews: PreviewProvider {
    static var previews: some View {
        AltimeterView()
    }
}
