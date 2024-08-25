import SwiftUI

struct OrientationView : View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    
    var body : some View {
        Section {
            Text("Orientation Graphs")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            HStack {
                Button(action: {
                    bluetoothDevice.setBMI088(input: "Orientation Get")
                    getData.toggle()
                }) {
                    Text("Get Data")
                }.disabled(getData)
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    bluetoothDevice.setBMI088(input: "Orientation Stop")
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
            }.padding(.bottom)
        }.onDisappear(perform: {
            bluetoothDevice.setBMI088(input: "Orientation Stop")
        })
        
        Text("Pitch")
        ChartStyle().getGraph(datasets: rocket.getPitch(), colour: .green)
        
        Text("Roll")
        ChartStyle().getGraph(datasets: rocket.getRoll(), colour: .blue)
        
        Text("Yaw")
        ChartStyle().getGraph(datasets: rocket.getYaw(), colour: .red)
    }
}

struct OrientationView_Previews: PreviewProvider {
    static var previews: some View {
        OrientationView()
    }
}
