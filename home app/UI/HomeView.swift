//
//  HomeView.swift
//  home app
//
//  Created by McGrogan, Neil on 10/25/21.
//

import SwiftUI

struct HomeView: View {
    @Binding var loadView: LoadView
    @ObservedObject var bleManager: BLEManager
    
    @State private var scanMode = false
    @State private var idSaved = -1
    
    var body: some View {
        VStack (spacing: 10) {
            
            HStack {
                Text("Bluetooth Devices")
                    .font(.largeTitle)
                
                Spacer()
            }.padding()
              
            if scanMode {
                Button("Enter provisioned mode") {
                    
                    loadView = .provisioned
                }
                
                Form() {
                    List(bleManager.peripherals) { peripheral in
                        Button(action: {
                            self.bleManager.connect()
                            self.bleManager.stopScanning()
                            self.bleManager.startScanning()
                        }) {
                            HStack {
                                Text(peripheral.name)
                                    .bold()
                                Spacer()
                                Text(String(peripheral.rssi)).bold()
                            }.foregroundColor(Color.blue)
                        }
                    }
                }.onAppear() {
                    UITableView.appearance().showsVerticalScrollIndicator = false
                }
            }
            
            Spacer()
            
            HStack {
                Text("STATUS")
                    .font(.headline)
                
                Spacer()
                           
                // Status goes here
                if bleManager.isSwitchedOn {
                    Text("Bluetooth is switched on")
                        .foregroundColor(.green)
                } else {
                    Text("Bluetooth is NOT switched on")
                        .foregroundColor(.red)
                }
            }.padding()
 
            HStack {
                if scanMode {
                    Button(action: {
                        self.bleManager.stopScanning()
                        self.scanMode.toggle()
                    }) {
                        Text("Stop Scanning")
                    }
                } else {
                    Button(action: {
                        self.bleManager.startScanning()
                        self.scanMode.toggle()
                    }) {
                        Text("Start Scanning")
                    }
                }
                
                Spacer()
                
                if bleManager.connected {
                    Spacer()
                    
                    Button(action: {
                        bleManager.disconnect()
                    }) {
                        Text("Disconnect")
                    }
                }
            }.padding()
        }
    }
}
