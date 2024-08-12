//
//  PageSubtitleComponent.swift
//  EcoInsights
//
//  Created by Jonathan Vercammen on 18/03/2023.
//

import SwiftUI

struct PageSubtitleComponent: View {
    let subtitleText: String
    
    var body: some View {
        Text(subtitleText)
            .accessibilityIdentifier("subtitle")
            .accessibilityLabel("subtitle")
            .font(.system(size: 20, design: .rounded))
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 30)
    }
}
