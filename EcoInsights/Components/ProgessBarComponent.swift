//
//  ProgessBarComponent.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 31/03/2023.
//

import SwiftUI

struct ProgessBarComponent: View {
    let score: Int
    let total: Int = 5
    
    var body: some View {
        ProgressView(value: Double(score), total: 5)
            .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
            .scaleEffect(x: 1, y: 2, anchor: .center)
        
    }
    private var progressColor: Color {
            switch score {
            case 1..<2:
                return Color.red
            case 2..<3:
                return Color(red: 237 / 255, green: 115 / 255, blue: 62 / 255, opacity: 1)
            case 3..<4:
                return Color.orange
            case 4..<5:
                return Color.yellow
            case 5...total:
                return Color.green
            default:
                return Color.gray
            }
        }
}

struct ProgessBarComponent_Previews: PreviewProvider {
    static var previews: some View {
        ProgessBarComponent(score: 1)
    }
}
