import SwiftUI
import SwiftUICharts

struct EDFView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @EnvironmentObject var edf : EDF
    
    var body: some View {
        ScrollView {
            Text("EDF Control Panel")
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
            Section {
                HStack {
                    Spacer()
                    Button(action: {
                        edf.resetEDF()
                    }) {
                        Text("Reset EDF")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color("Light Gray"))
                    .cornerRadius(10)
                    Spacer()
                }
                HStack {
                    Spacer()
                    NavigationLink {
                        BluetoothConnectView()
                    } label: {
                        Text("Connect Bluetooth")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color("Light Gray"))
                    .cornerRadius(10)
                    Spacer()
                }
                HStack {
                    Spacer()
                    NavigationLink {
                        EDF_ServoView()
                    } label: {
                        Text("View Servos")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color("Light Gray"))
                    .cornerRadius(10)
                    Spacer()
                }
                HStack {
                    Spacer()
                    NavigationLink {
                        EDF_OrientationView()
                    } label: {
                        Text("View Orientation")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color("Light Gray"))
                    .cornerRadius(10)
                    Spacer()
                }
                HStack {
                    Spacer()
                    NavigationLink {
                        EDF_PIDView()
                    } label: {
                        Text("View PID")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color("Light Gray"))
                    .cornerRadius(10)
                    Spacer()
                }
            }
        }
    }
}

struct EDFView_Previews: PreviewProvider {
    static var previews: some View {
        EDFView()
    }
}
