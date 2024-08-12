//
//  NavigationButtonComponent.swift
//  EcoInsights
//
//  Created by Jonathan Vercammen on 24/03/2023.
//

import SwiftUI

struct NavigationButtonComponent<TargetView: View>: View {
    let buttonText: String
    let backgroundColor: LinearGradient
    let destination: TargetView
    let showArrow: Bool
    let accessibilityIdentifier: String
    
    var body: some View {
        NavigationLink(destination: destination) {
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

struct NavigationButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButtonComponent(buttonText: "Demo", backgroundColor:  LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .top, endPoint: .trailing), destination: WelcomeView(), showArrow: true, accessibilityIdentifier: "demoButton")
    }
}
