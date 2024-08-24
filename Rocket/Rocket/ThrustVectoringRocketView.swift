import SwiftUI
import SwiftUICharts

struct ThrustVectoringRocketView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @EnvironmentObject var rocket : Rocket
    var body: some View {
        ScrollView {
            Text("Control Panel")
                .font(.largeTitle)
                .padding(.bottom)
            Divider()
            HStack {
                Button(action: {
                    bluetoothDevice.setUtilities(input: "Arm")
                }) {
                    Text("Arm Rocket")
                        .font(.title2)
                }
                .padding(.horizontal, 25)
                Button(action: {
                    bluetoothDevice.setUtilities(input: "Reset")
                    rocket.reset()
                }) {
                    Text("Reset Rocket")
                        .font(.title2)
                }
                .padding()
            }
            Divider()
            Section {
                HStack {
                    NavigationLink("View Orientation:", destination: OrientationView())
                        .padding()
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .padding()
                }
                Divider()
                HStack {
                    NavigationLink("View Servos:", destination: ServoView())
                        .padding()
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .padding()
                }
                Divider()
                HStack {
                    NavigationLink("View PID:", destination: PIDView())
                        .padding()
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .padding()
                }
                Divider()
                HStack {
                    NavigationLink("View Altimeter:", destination: AltimeterView())
                        .padding()
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .padding()
                }
                Divider()
            }
            Section {
                HStack {
                    Button(action: {
                        bluetoothDevice.setUtilities(input: "Bypass Pad")
                    }) {
                        Text("On Pad")
                    }
                        .padding()
                        .buttonStyle(.borderless)
                    Image(systemName: rocket.onPad ? "checkmark" : "xmark")
                        .foregroundColor(rocket.onPad ? .green : .red)
                        .padding()
                }
                HStack {
                    Button(action: {
                        bluetoothDevice.setUtilities(input: "Bypass TVC")
                    }) {
                        Text("TVC Active")
                    }
                        .padding()
                        .buttonStyle(.borderless)
                    Image(systemName: rocket.tvcActive ? "checkmark" : "xmark")
                        .foregroundColor(rocket.tvcActive ? .green : .red)
                        .padding()
                }
                HStack {
                    Button(action: {
                        bluetoothDevice.setUtilities(input: "Bypass Coasting")
                    }) {
                        Text("Coasting")
                    }
                        .padding()
                        .buttonStyle(.borderless)
                    Image(systemName: rocket.coasting ? "checkmark" : "xmark")
                        .foregroundColor(rocket.coasting ? .green : .red)
                        .padding()
                }
                HStack {
                    Button(action: {
                        bluetoothDevice.setUtilities(input: "Bypass Parachute")
                    }) {
                        Text("Parachute Out")
                    }
                        .padding()
                        .buttonStyle(.borderless)
                    Image(systemName: rocket.parachuteOut ? "checkmark" : "xmark")
                        .foregroundColor(rocket.parachuteOut ? .green : .red)
                        .padding()
                }
                HStack {
                    Button(action: {
                    }) {
                        Text("Touchdown")
                    }
                        .padding()
                        .buttonStyle(.borderless)
                    Image(systemName: rocket.touchdown ? "checkmark" : "xmark")
                        .foregroundColor(rocket.touchdown ? .green : .red)
                        .padding()
                }
            }
            Divider()
            Section {
                HStack {
                    Text(rocket.logs)
                        .padding()
                        .font(.title3)
                    Spacer()
                    Button(action: {
                        rocket.clearLogs()
                    }) {
                        Text("Clear Logs")
                            .font(.title3)
                            .buttonStyle(.borderless)
                            .padding()
                    }
                }
            }
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}



struct ThrustVectoringRocketView_Previews: PreviewProvider {
    static var previews: some View {
        ThrustVectoringRocketView()
    }
}
