//
//  ESP_32_InterfaceApp.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/23/24.
//

import SwiftUI

@main
struct RocketApp: App {
    @StateObject var bluetoothDevice = BluetoothDeviceHelper()
    @StateObject var rocket = Rocket()
    
    var body: some Scene {
        WindowGroup {
            HomeScreenView()
                .environmentObject(bluetoothDevice)
                .environmentObject(rocket)
        }
    }
}
