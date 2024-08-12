//
//  PageTitleComponent.swift
//  EcoInsights
//
//  Created by Jonathan Vercammen on 18/03/2023.
//

import SwiftUI

struct PageTitleComponent: View {
    let titleText: String
    
    var body: some View {
        Text(titleText)
            .accessibilityIdentifier("title")
            .accessibilityLabel("title")
            .font(.system(size: 32, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(.black)
            .padding(.bottom, 20)
    }
}
