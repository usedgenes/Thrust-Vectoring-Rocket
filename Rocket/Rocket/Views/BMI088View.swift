import SwiftUI

struct BMI088View: View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    
    var body : some View {
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
        }.padding(.bottom)
            .onDisappear(perform: {
                bluetoothDevice.setBMI088(input: "BMI088 Stop")
            })
        Section {
            Text("Acceleration X")
                .font(.title2)
            ChartStyle().getGraph(datasets: rocket.getAccelX(), colour: .red)
            
            Text("Acceleration Y")
                .font(.title2)
            ChartStyle().getGraph(datasets: rocket.getAccelY(), colour: .green)
            
            Text("Acceleration Z")
                .font(.title2)
            ChartStyle().getGraph(datasets: rocket.getAccelZ(), colour: .blue)
        }
        Section {
            Text("Gyroscope X")
                .font(.title2)
            ChartStyle().getGraph(datasets: rocket.getGyroX(), colour: .purple)
            
            Text("Gyroscope Y")
                .font(.title2)
            ChartStyle().getGraph(datasets: rocket.getGyroY(), colour: .yellow)
            
            Text("Gyroscope Z")
                .font(.title2)
            ChartStyle().getGraph(datasets: rocket.getGyroZ(), colour: .orange)
        }
    }
}

struct BMI088View_Previews: PreviewProvider {
    static var previews: some View {
        BMI088View()
    }
}
