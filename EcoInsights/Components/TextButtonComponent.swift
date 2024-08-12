//
//  TextButtonComponent.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 23/03/2023.
//

import SwiftUI

struct TextButtonComponent: View {
    let text: String
    let backgroundColor:  LinearGradient
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundColor(.black)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(backgroundColor)
            .cornerRadius(10)
    }
}
