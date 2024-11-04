//
//  RocketControllerApp.swift
//  RocketController
//
//  Created by Eugene on 11/3/24.
//

import SwiftUI

@main
struct RocketControllerApp: App {
    @StateObject var bluetoothDevice = BluetoothDeviceHelper()
    @StateObject var rocket = Rocket()
    @StateObject var edf = EDF()

    var body: some Scene {
        WindowGroup {
            HomeScreenView()
                .environmentObject(bluetoothDevice)
                .environmentObject(rocket)
                .environmentObject(edf)
        }
    }
}
