//
//  Provisioned.swift
//  home app
//
//  Created by McGrogan, Neil on 10/26/21.
//

import SwiftUI

struct Provisioned: View {
    @Binding var loadView: LoadView
    @ObservedObject var bleManager: BLEManager
    
    var body: some View {
        VStack {
            HStack {
                Text("Bluefuit device")
                    .font(.title)
                
                Spacer()
                
                Button(action: {
                    self.loadView = .home
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                }
            }
            
            Text("Meant for use with an Adafruit Bluefruit LE device.")
            
            List(bleManager.peripherals) { peripheral in
                if peripheral.name == "Adafruit Bluefruit LE" {
                    HStack {
                        Text(peripheral.name)
                            .bold()
                        Spacer()
                        Text(String(peripheral.rssi)).bold()
                    }.foregroundColor(Color.blue)
                }
            }
        }
    }
}
