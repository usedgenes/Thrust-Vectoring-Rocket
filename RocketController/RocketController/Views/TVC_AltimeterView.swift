import SwiftUI

struct TVC_AltimeterView: View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    
    var body: some View {
        Text("Altimeter Graphs")
            .font(.title)
            .fontWeight(.bold)
        Divider()
        HStack {
            Spacer()
            Button(action: {
                if(!getData) {
                    bluetoothDevice.setUtilities(input: "Altimeter Get")
                }
                else {
                    bluetoothDevice.setUtilities(input: "Altimeter Stop")
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
                rocket.resetBMP390()
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
                bluetoothDevice.setUtilities(input: "Altimeter Stop")
            })
        Divider()
        Text("Altitude")
            .font(.title2)
            .padding(.top)
        ChartStyle().getGraph(datasets: rocket.getAltitude(), colour: .red)
        
        Text("Temperature")
            .font(.title2)
        ChartStyle().getGraph(datasets: rocket.getTemperature(), colour: .green)
        
        Text("Pressure")
            .font(.title2)
        ChartStyle().getGraph(datasets: rocket.getPressure(), colour: .blue)
    }
}

struct TVC_AltimeterView_Previews: PreviewProvider {
    static var previews: some View {
        TVC_AltimeterView()
    }
}
