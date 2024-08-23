//
//  ContentView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State private var showingServoView = false
    @State private var showingAltimeterView = false
    @State var saveTemp = 0
    @State var getTemp = 0
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("ESP32 Options")) {
                    NavigationLink("Connect to Bluetooth", destination: BluetoothConnectView())
                }
                Section(header: Text("Thrust Vectoring")) {
                    NavigationLink("Rocket", destination: ThrustVectoringRocketView())

                }
            }
            .navigationBarTitle("Thrust Vectoring Rocket")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
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
