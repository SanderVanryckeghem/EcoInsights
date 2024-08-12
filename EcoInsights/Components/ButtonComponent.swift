//
//  ButtonComponent.swift
//  EcoInsights
//
//  Created by Jonathan Vercammen on 18/03/2023.
//

import SwiftUI

struct ButtonComponent: View {
    let buttonText: String
    let backgroundColor: LinearGradient
    let action: () -> Void
    let showArrow: Bool
    let accessibilityIdentifier: String
    
    var body: some View {
        Button(action: action) {
            if !showArrow { Spacer() }
            Text(buttonText)
            Spacer()
            if showArrow { Image(systemName: "chevron.right") }
        }
        .accessibilityIdentifier(accessibilityIdentifier)
        .font(.headline)
        .foregroundColor(.white)
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
    }
}
