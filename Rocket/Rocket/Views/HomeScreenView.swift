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
                Section(header: Text("Thrust Vectoring Rocket")) {
                    NavigationLink("Control Panel", destination: TVCView())

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
