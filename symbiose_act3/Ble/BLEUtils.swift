//
//  BLEUtils.swift
//  Symbiose
//
//  Created by Jonathan Pegaz on 27/12/2022.
//

import Foundation
import CoreBluetooth

struct Periph:Identifiable,Equatable{
    var id = UUID().uuidString
    var blePeriph:CBPeripheral
    var name:String
    
}

struct DataReceived:Identifiable,Equatable{
    var id = UUID().uuidString
    var content:String
}
