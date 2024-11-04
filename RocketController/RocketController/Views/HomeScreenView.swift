import SwiftUI
import SwiftUICharts

struct HomeScreenView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Bluetooth")) {
                    NavigationLink("Connect to Bluetooth", destination: BluetoothConnectView())
                }
                Section(header: Text("Rocketry")) {
                    NavigationLink("TVC Control Panel", destination: TVCView())
                    NavigationLink("Altimeter Ejection Assistant", destination: AltimeterEjectionView())
                    NavigationLink("Parachute Ejection Assistant", destination: ParachuteEjectionView())
                }
                Section(header: Text("Miscellaneous")) {
                    NavigationLink("Thrust Vectoring EDF", destination: EDFView())
                }
            }
            .navigationBarTitle("Rocketry Assistant")
        }
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
