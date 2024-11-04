import SwiftUI

struct TVC_BMI088View: View {
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State var getData = false
    
    var body : some View {
        ScrollView {
            Text("BMI088 Data Graphs")
                .font(.title)
                .fontWeight(.bold)
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    if(!getData) {
                        bluetoothDevice.setUtilities(input: "BMI088 Get")
                    }
                    else {
                        bluetoothDevice.setUtilities(input: "BMI088 Stop")
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
                    rocket.resetBMI088()
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
                bluetoothDevice.setUtilities(input: "BMI088 Stop")
            })
            Divider()
            Section {
                Text("Acceleration X")
                    .font(.title2)
                    .padding(.top)
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
}

struct TVC_BMI088View_Previews: PreviewProvider {
    static var previews: some View {
        TVC_BMI088View()
    }
}
