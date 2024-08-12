//
//  ProductPopUpComponent.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 19/04/2023.
//


import SwiftUI

struct ProductPopUpComponent: View {
    @State var Name: String
    @State var Brand: String
    @State var Image: String
    @State var AvgScore: Double
    @ObservedObject var sharedData: SharedData
    
    var body: some View {
        VStack (alignment: .center){
            HStack{
                VStack(alignment: .leading){
                    Text(sharedData.pressedItem!.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    Text(sharedData.pressedItem!.brand)
                }
                Spacer()
                SwiftUI.Image(systemName: "x.circle")
                    .font(.system(size: 35, weight: .medium))
                    .onTapGesture {
                        sharedData.openPopUpScan = false
                    }
            }
            
            HStack {
                StarRatingComponent(rating: Double(sharedData.pressedItem!.totalScore))
                Text(String(Double(sharedData.pressedItem!.totalScore)))
                    .fontWeight(.bold)
                    .padding(.trailing, 15)
                Spacer()
                NavigationLink(destination: ProductDetailView(product: sharedData.pressedItem!)) {
                    Text("View details")
                        .padding(10)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .background(Color(red: 104 / 255, green: 227 / 255, blue: 81 / 255, opacity: 1))
                        .cornerRadius(20)
                }
                
            }
            ZStack(alignment: .topTrailing) {
                SwiftUI.Image("\(sharedData.pressedItem!.brand) \(sharedData.pressedItem!.name)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
            }
        }
        .padding(.init(top: 10, leading: 20, bottom: 20, trailing: 10))
        .background(Color(red: 222 / 255, green: 231 / 255, blue: 230 / 255, opacity: 1))
    }
}

