//
//  SwiftUIView.swift
//  ESP 32 Interface
//
//  Created by Eugene on 7/24/24.
//

import SwiftUI
import CoreBluetooth


struct BluetoothConnectView: View {
    @EnvironmentObject var bluetoothDevice : BluetoothDeviceHelper
    @State private var showBluetoothAlert: Bool = false
    @State var bluetoothManagerHelper = BluetoothManagerHelper()
    @State var LED_On = false
    @EnvironmentObject var rocket : Rocket
    @EnvironmentObject var edf : EDF
    
    var body: some View {
        Text("Bluetooth")
            .font(.title)
            .fontWeight(.bold)
        Divider()
        HStack {
            Spacer()
            Button(action: {
                bluetoothDevice.refresh()
            }) {
                Text("Refresh")
                    .font(.title2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(Color("Light Gray"))
            .cornerRadius(10)
            Spacer()
            Button(action: {
                if(bluetoothDevice.isConnected) {
                    bluetoothDevice.disconnect()
                }
                else {
                    showBluetoothAlert = true
                    
                }
            }) {
                Text("Disconnect")
                    .font(.title2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(Color("Light Gray"))
            .cornerRadius(10)
            Spacer()
        }
        .alert(isPresented: $showBluetoothAlert) {
            Alert(
                title: Text("No Bluetooth Device Connected"),
                message: Text("Please select a device to connect to")
            )
        }
        Divider()
        VStack {
            HStack{
                Text("Device Name:")
                    .font(.title2)
                Spacer()
                Text(String(bluetoothDevice.deviceName))
                    .font(.title2)
            }
            .padding()
            
            HStack{
                Text("Device State:")
                    .font(.title2)
                
                Spacer()
                Text(bluetoothDevice.isConnected ? "Connected" : "Not connected")
                    .font(.title2)
                
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        Divider()
        List {
            ForEach(bluetoothManagerHelper.devices, id: \.self) { device in
                HStack {
                    Button(action: {
                        if(bluetoothDevice.isConnected == false) {
                            bluetoothManagerHelper.connectDevice(BTDevice: device)
                            bluetoothDevice.device = device
                            bluetoothDevice.connect()
                            bluetoothDevice.rocket = rocket
                            bluetoothDevice.edf = edf
                        }
                    }) {
                        Text("\(device.name)")
                            .font(.title3)
                    }
                    Spacer()
                }
                .contentShape(Rectangle())
                
            }
        }
        
    }
}


struct BluetoothConnectView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothConnectView()
    }
}
