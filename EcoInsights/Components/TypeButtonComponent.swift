//
//  TypeButtonComponent.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 31/03/2023.
//

import SwiftUI

struct TypeButtonComponent: View {
    let title: String
    let action: () -> Void
    @Binding var isSelected: Bool
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.callout)
                .foregroundColor(.black)
                .padding(8)
                .background(isSelected ? Color(red: 104 / 255, green: 227 / 255, blue: 81 / 255, opacity: 1) : Color.clear)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green, lineWidth: isSelected ? 0 : 2)
                )
        }
    }
}

