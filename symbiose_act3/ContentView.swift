//
//  ContentView.swift
//  symbiose_act3
//
//  Created by Jonathan Pegaz on 28/12/2022.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @StateObject var BLEact3:BLEObservable = BLEObservable()
    @StateObject var bleController : BLEController = BLEController()
    @StateObject var tflite:ViewController = ViewController()
    
    @State var connectionStringble3 = "No device connected"
    
    var body: some View {
        VStack {
            Text(connectionStringble3)
            Text(tflite.resultsLabel)
            Text("\(tflite.resultsConfidence, specifier: "%.2f")")
        }
        .padding()
        .onAppear(){
            bleController.load()
            tflite.load()
        }
        .onChange(of: bleController.bleStatus) { newValue in
            BLEact3.startScann()
        }.onChange(of: BLEact3.connectedPeripheral) { newValue in
            if let p = newValue{
                connectionStringble3 = p.name
                BLEact3.sendString(str: "act3")
                tflite.load()
            }
        }
        .onChange(of: tflite.resultsLabel) { newValue in
            if(tflite.resultsLabel == "0 Pattern_1" && tflite.resultsConfidence > 0.8){
                print("Contactble")
                BLEact3.sendString(str: "ok")
            }
        }
    }
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
