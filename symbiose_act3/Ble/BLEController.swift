//
//  BLEController.swift
//  BLEPeripheralApp
//

import UIKit
import CoreBluetooth

class BLEController: UIViewController,CBPeripheralManagerDelegate, ObservableObject {
    
    @Published var messageLabel: String = ""
    @Published var readValueLabel: String = ""
    @Published var writeValueLabel: String = ""
    
    @Published var bleStatus: Bool = false
    
    let authCBUUID = CBUUID(string: "B210763B-B12E-40F3-9AB5-2C75385CDD09")
    let writeCBUUID = CBUUID(string: "998AEEFC-5721-4CD6-89FF-277B9FD38D1D")
    let readCBUUID = CBUUID(string: "2E4B84ED-A3BD-40A3-8382-ACBBAFA8BC7B")
    
    private var service: CBUUID!
    private let value = "AD34E"
    private var peripheralManager : CBPeripheralManager!
    
    var myCharacteristic1:CBMutableCharacteristic?
    var myCharacteristic2:CBMutableCharacteristic?
    
    func load() {
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .unknown:
            print("Bluetooth Device is UNKNOWN")
        case .unsupported:
            print("Bluetooth Device is UNSUPPORTED")
        case .unauthorized:
            print("Bluetooth Device is UNAUTHORIZED")
        case .resetting:
            print("Bluetooth Device is RESETTING")
        case .poweredOff:
            print("Bluetooth Device is POWERED OFF")
        case .poweredOn:
            print("Bluetooth Device is POWERED ON")
            self.bleStatus = true
        @unknown default:
            fatalError()
        }
    }

    func addServices() {
        let valueData = value.data(using: .utf8)
        
        // 1. Create instance of CBMutableCharcateristic
        myCharacteristic1 = CBMutableCharacteristic(type: writeCBUUID, properties: [.notify, .write, .read], value: nil, permissions: [.readable, .writeable])
        myCharacteristic2 = CBMutableCharacteristic(type: readCBUUID, properties: [.notify, .write, .read], value: nil, permissions: [.readable, .writeable])
        // 2. Create instance of CBMutableService
        service = authCBUUID
        let myService = CBMutableService(type: service, primary: true)
        
        // 3. Add characteristics to the service
        myService.characteristics = [myCharacteristic1!, myCharacteristic2!]
        
        // 4. Add service to peripheralManager
        peripheralManager.add(myService)
        
        // 5. Start advertising
        startAdvertising()
       
    }
    
    
    func startAdvertising() {
        messageLabel = "Advertising Data"
        peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey : "symbioseact3", CBAdvertisementDataServiceUUIDsKey : [service]])
        print("Started Advertising")
        
    }
    
    func stopAdvertising() {
        peripheralManager.stopAdvertising()
        
    }
    
    func sendGoValue(){
        peripheralManager.updateValue("go".data(using: .utf8)!, for: myCharacteristic1!, onSubscribedCentrals: nil)
    }
    
    func sendEndValue(){
        peripheralManager.updateValue("endact3".data(using: .utf8)!, for: myCharacteristic1!, onSubscribedCentrals: nil)
    }
    
    func sendReset() {
        peripheralManager.updateValue("reset".data(using: .utf8)!, for: myCharacteristic1!, onSubscribedCentrals: nil)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        readValueLabel = value
      
        // Perform your additional operations here
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        if let value = requests.first?.value {
           writeValueLabel = value.hexEncodedString2()
            //Perform here your additional operations on the data you get
            if let string = String(bytes: value, encoding: .utf8) {                self.messageLabel = string
            }
        }
    }
}


extension Data {
    struct HexEncodingOptions2: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions2(rawValue: 1 << 0)
    }
    
    func hexEncodedString2(options: HexEncodingOptions2 = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
