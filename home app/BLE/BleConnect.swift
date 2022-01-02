//
//  BleConnect.swift
//  home app
//
//  Created by McGrogan, Neil on 10/25/21.
//

import Foundation
import CoreBluetooth

struct Peripheral: Identifiable {
    let id: Int
    let name: String
    let rssi: Int
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    let scanInterval: TimeInterval = 160.0
    
    var myCentral: CBCentralManager!
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    @Published var connected = false
    @Published var savedID = -1
    
    var initConnect = false
    var PERIPHERAL_ID = "Adafruit Bluefruit LE"
    var connectDevice: CBPeripheral?
    
    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
         if central.state == .poweredOn {
             isSwitchedOn = true
         }
         else {
             isSwitchedOn = false
         }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var peripheralName: String!
       
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
        }
        else {
            peripheralName = "Unknown"
        }
       
        let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue)
        print("Peripheral: \(newPeripheral)")
        peripherals.append(newPeripheral)
        
        if(peripheralName == PERIPHERAL_ID){
            savedID = newPeripheral.id
        }
        
        print(initConnect)
        
        if(peripheralName == PERIPHERAL_ID && initConnect) {
            self.connected.toggle()
            myCentral.stopScan()
            connectDevice = peripheral
            connectDevice?.delegate = self
            
            myCentral.connect(connectDevice!, options: nil)
        }
    }
    
    func startScanning() {
         myCentral.scanForPeripherals(withServices: nil, options: nil)
     }
    
    func stopScanning() {
        myCentral.stopScan()
    }
    
    func disconnect() {
        self.initConnect = false
        connectDevice = nil
        self.connected.toggle()
    }
    
    func connect() {
        initConnect = true
    }
}
