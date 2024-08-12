//
//  NavigationTextComponent.swift
//  EcoInsights
//
//  Created by Robbe Van hoorebeke on 31/03/2023.
//

import SwiftUI

struct NavigationTextComponent<TargetView: View>: View {
    let destination: TargetView
    let navigationText: String
    let accessibilityIdentifier: String
    
    var body: some View {
        NavigationLink(destination: destination) {
            Text(navigationText)
                .font(.caption)
                .foregroundColor(.green)
        }.accessibilityIdentifier(accessibilityIdentifier)
    }
}

struct NavigationTextComponent_Previews: PreviewProvider {
    static var previews: some View {
        NavigationTextComponent(
            destination: WelcomeView(),
            navigationText: "demo",
            accessibilityIdentifier: "demo"
        )
    }
}
