import SwiftUI

struct TVC_OrientationView : View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    
    var body : some View {
        Text("Orientation Graphs")
            .font(.title)
            .fontWeight(.bold)
        Divider()
        HStack {
            Spacer()
            Button(action: {
                if(!getData) {
                    bluetoothDevice.setUtilities(input: "Orientation Get")
                }
                else {
                    bluetoothDevice.setUtilities(input: "Orientation Stop")
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
                rocket.resetRotation()
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
                bluetoothDevice.setUtilities(input: "Orientation Stop")
            })
        Divider()
        Text("Pitch")
            .font(.title2)
            .padding(.top)
        ChartStyle().getGraph(datasets: rocket.getPitch(), colour: .green)
        
        Text("Roll")
            .font(.title2)
        ChartStyle().getGraph(datasets: rocket.getRoll(), colour: .blue)
        
        Text("Yaw")
            .font(.title2)
        ChartStyle().getGraph(datasets: rocket.getYaw(), colour: .red)
    }
}

struct TVC_OrientationView_Previews: PreviewProvider {
    static var previews: some View {
        TVC_OrientationView()
    }
}
