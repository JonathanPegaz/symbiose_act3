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
    
    @State var resultTime:Int = 0
    @State var maxTime:Int = 10
    @State var isFinished:Bool = false
    
    var body: some View {
        VStack {
            Text(tflite.resultsLabel)
            Text("\(tflite.resultsConfidence, specifier: "%.2f")")
            Text("\(resultTime) / \(maxTime)")
            Button("send end value"){
                bleController.sendEndValue()
            }
        }
        .padding()
        .onAppear(){
            bleController.load()
        }
        .onChange(of: bleController.bleStatus) { newValue in
            bleController.addServices()
            tflite.load()
        }
        .onChange(of: bleController.messageLabel) { newValue in
            if (newValue == "start") {
                print("go")
                bleController.sendGoValue()
                
            }
            if (newValue == "reset") {
                bleController.sendReset()
                isFinished = false
                resultTime = 0
                tflite.resultsLabel = ""
                tflite.resultsConfidence = 0.0
            }
            bleController.messageLabel = ""
        }
        .onChange(of: tflite.resultsLabel) { newValue in
            if(tflite.resultsLabel == "1 371_vague" && tflite.resultsConfidence > 0.8 && isFinished == false){
                if (resultTime < maxTime) {
                    resultTime = resultTime + 1
                } else {
                    bleController.sendEndValue()
                    isFinished = true
                }
            }
        }
    }
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
