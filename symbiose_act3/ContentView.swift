//
//  ContentView.swift
//  symbiose_act3
//
//  Created by Jonathan Pegaz on 28/12/2022.
//

import SwiftUI
import AVFoundation

struct ContentView: View {

    @StateObject var bleController : BLEController = BLEController()
    @StateObject var tflite:ViewController = ViewController()
    
    var body: some View {
        VStack {
            Text(tflite.resultsLabel)
            Text("\(tflite.resultsConfidence, specifier: "%.2f")")
        }
        .padding()
        .onAppear(){
            bleController.load()
            tflite.load()
        }
        .onChange(of: bleController.bleStatus) { newValue in
            bleController.addServices()
        }
        .onChange(of: bleController.messageLabel) { newValue in
            if (newValue == "start") {
                tflite.load()
            }
        }
        .onChange(of: tflite.resultsLabel) { newValue in
            if(tflite.resultsLabel == "0 ok" && tflite.resultsConfidence > 0.8){
                print("Contactble")
                bleController.sendEndValue()
            }
        }
    }
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
