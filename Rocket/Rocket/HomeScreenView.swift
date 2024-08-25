import SwiftUI
import SwiftUICharts

struct HomeScreenView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @EnvironmentObject var rocket : Rocket
    @State var getLoopTime = false
    
    var body: some View {
        NavigationView {
            Text("TVC Control Panel")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(alignment: .leading)
                .offset(y: 30)
                .padding()
            List {
                Section(header: Text("Rocket Options")) {
                    NavigationLink("Connect to Bluetooth:", destination: BluetoothConnectView())
                    NavigationLink("View Orientation: ", destination: OrientationView())
                    NavigationLink("View BMI088:", destination: BMI088View())
                    NavigationLink("View Altimeter:", destination: AltimeterView())
                    NavigationLink("View Servos:", destination: ServoView())
                    NavigationLink("View PID:", destination: PIDView())
                    Section(header: Text("Options")) {
                        HStack {
                            Button(action: {
                                if(!getLoopTime) {
                                    bluetoothDevice.setUtilities(input: "Time Get")
                                }
                                else {
                                    bluetoothDevice.setUtilities(input: "Time Stop")
                                }
                                getLoopTime.toggle()
                            }) {
                                Text("Refresh Rate: ")
                                    .foregroundColor(.black)
                            }.padding(.leading)
                            Text(rocket.deltaTime + " ms")
                            Spacer()
                            Text(bluetoothDevice.isConnected ? "Connected" : "Not Connected")
                                .foregroundColor(bluetoothDevice.isConnected ? .green : .red)
                                .padding()
                        }
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
                        
                    }
                }
                }.navigationBarTitle("TVC Control Panel")
            
        }
        .onDisappear(perform: {
            bluetoothDevice.setUtilities(input: "Time Stop")
        })
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
            .environmentObject(BluetoothDeviceHelper())
            .environmentObject(Rocket())
    }
}

extension View {
    func hideKeyboardWhenTappedAround() -> some View  {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
}
