//
//  CustomToggleSwitchComponent.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 13/04/2023.
//

import SwiftUI

struct CustomToggleSwitchComponent: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                isOn.toggle()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.green, lineWidth: 2)
                    )
                    .frame(width: 50, height: 110)
                
                Circle()
                    .fill(Color.green)
                    .frame(width: 40, height: 40)
                    .offset(y: isOn ? -30 : 30)
                    .animation(.easeInOut(duration: 0.2))
                
                VStack {
                    Image(systemName: "arkit")
                        .resizable()
                        .foregroundColor(isOn ? .white : .black)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    Image(systemName: "barcode")
                        .resizable()
                        .foregroundColor(isOn ? .black : .white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(.bottom, 10)
                }
                .frame(width: 50, height: 100)
                .padding(.vertical, 5)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }}

//struct CustomToggleSwitchComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomToggleSwitchComponent()
//    }
//}
