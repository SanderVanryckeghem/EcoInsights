//
//  ScansView.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 09/03/2023.
//

import SwiftUI
import CarBode
import AVFoundation

struct ScansView: View {
    @State private var toggleState: Bool = true
    @StateObject private var sharedData = SharedData()
    @State private var showingAlert = false
    var body: some View {
        ZStack {
            if toggleState {
                HostedViewController(sharedData: sharedData)
            } else {
                CBScanner(
                    supportBarcode: .constant([.ean13, .code128]), //Set type of barcode you want to scan
                    scanInterval: .constant(3.0) //Event will trigger every 5 seconds
                ){
                    //When the scanner found a barcode
                    let value = $0.value
                    if let productDetected = ProductController.shared.products.first(where: {$0.barcode == value}){
                        sharedData.pressedItem = productDetected
                        sharedData.openPopUpScan = true
                        print(productDetected)
                    }
                    else{
                        self.showingAlert = true
                    }
                }
            onDraw: {
                
                //line width
                let lineWidth = 2
                
                //line color
                let lineColor = UIColor.red
                
                //Fill color with opacity
                //You also can use UIColor.clear if you don't want to draw fill color
                let fillColor = UIColor.green
                
                //Draw box
                $0.draw(lineWidth: CGFloat(lineWidth), lineColor: lineColor, fillColor: fillColor)
            }
                
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CustomToggleSwitchComponent(isOn: $toggleState)
                }
            }
            .padding()

            if sharedData.openPopUpScan {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        sharedData.openPopUpScan = false
                    }

                VStack {
                    Spacer()
                    ProductPopUpComponent(Name: "", Brand: "", Image: "", AvgScore: 3.7, sharedData: sharedData)
                    
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Not Found"),
                message: Text("The barcode isn't know."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct ScansView_Previews: PreviewProvider {
    static var previews: some View {
        ScansView()
    }
}
