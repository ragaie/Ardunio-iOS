//
//  ViewController.swift
//  TestPeripheral
//
//  Created by Ragaie on 4/1/19.
//  Copyright © 2019 Ragaie. All rights reserved.
//

import UIKit
import CoreBluetooth
class CarView: UIViewController , CBCentralManagerDelegate, CBPeripheralDelegate{
   
    var manager:CBCentralManager? = nil
    var  mainPeripheral :CBPeripheral? = nil
    var mainCharacteristic:CBCharacteristic? = nil
    
    
    let BLEService = "DFB0"
    let BLECharacteristic = "DFB1"
    
    
    
    
    
    
//    (Service UUID: 0000ffe0-0000-1000-8000-00805f9b34fb)
//    that enables bidirectional communication between the module and any other central device that connects to it.
//    The service defines a single characteristic
//    (Characteristic UUID: 0000ffe1-0000-1000-8000-00805f9b34fb)
//
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager    = CBCentralManager(delegate: self, queue: nil)

        

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        scanBLEDevices()
    }
    
    
    
    
    
    
    // MARK: BLE Scanning
    func scanBLEDevices() {
       // manager?.scanForPeripherals(withServices: [CBUUID.init(string: BLEService)], options: nil)

        //stop scanning after 3 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
//            // Code you want to be delayed
//            self.stopScanForBLEDevices()
//
//        }
      
    }
    
    func stopScanForBLEDevices() {
        manager?.stopScan()
    }
    
    
    
    
    
    // MARK: - CBCentralManagerDelegate Methods
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
   
      
        print("new device discover")
       //set device
        
        mainPeripheral = peripheral
        manager?.connect(mainPeripheral!, options: nil)

        manager?.stopScan()

        mainPeripheral?.delegate = self
        
       
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

        if central.state == .poweredOn{
            print("Searching for BLE Devices")
            manager?.scanForPeripherals(withServices: nil, options: nil)

            
        }
            
        else{
            print("Bluetooth switched off or not initialized")
            
            
        }
        

    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        //pass reference to connected peripheral to parent view
        mainPeripheral?.discoverServices(nil)
        
      print("connect device  ")
    }
    
    //reconnect
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        manager?.scanForPeripherals(withServices: [CBUUID.init(string: BLEService)], options: nil)
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error)
    }
    
    
    // MARK: CBPeripheralDelegate Methods
    ///discover services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            print("Service found with UUID: " + service.uuid.uuidString)
//            //device information service
            peripheral.discoverCharacteristics(nil, for: service)

            if (service.uuid.uuidString == "180A") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            if (service.uuid.uuidString == BLEService) {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            
            
        }
    }
    
    
  ///discover Characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        
        if (service.uuid.uuidString == "180A") {

            for characteristic in service.characteristics! {
                if (characteristic.uuid.uuidString == "2A29") {
                    peripheral.readValue(for: characteristic)
                    print("Found a Device Manufacturer Name Characteristic")
                } else if (characteristic.uuid.uuidString == "2A23") {
                    peripheral.readValue(for: characteristic)
                    print("Found System ID")
                }

            }

        }
        
        
        
    //    D0611E78-BBB4-4591-A5F8-487910AE4366
      //  Service found with UUID: 9FA480E0-4967-4542-9390-D343DC5D04AE
        if (service.uuid.uuidString == BLEService) {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == BLECharacteristic) {
                    //we'll save the reference, we need it to write data
                    mainCharacteristic = characteristic
                    
                    //Set Notify is useful to read incoming data async
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("Found Bluno Data Characteristic")
                }
                
            }
            
        }
        
    }
    
    
        
        
    
    
    
    func writeValue(action: String){
        
        
        
        let dataToSend = action.data(using: String.Encoding.utf8)
        
        if (mainPeripheral != nil) {
            mainPeripheral?.writeValue(dataToSend!, for: mainCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
        } else {
            print("haven't discovered device yet")
        }

    }
    
    
    @IBAction func writevalue(_ sender: Any) {
        
        writeValue(action: "ff")
    }
    
}

