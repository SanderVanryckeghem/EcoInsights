//
//  ScoreComponent.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 11/04/2023.
//

import SwiftUI

struct ScoreComponent: View {
    let score: Double
    
    var body: some View {
        let color: Color
        switch score {
        case 1..<2:
            color = Color.red
        case 2..<3:
            color = Color(red: 237 / 255, green: 115 / 255, blue: 62 / 255, opacity: 1)
        case 3..<4:
            color = Color.orange
        case 4..<5:
            color = Color.yellow
        case 5...:
            color = Color.green
        default:
            color = Color.gray
        }
        
        return Text(String(format: "%.1f", score))
            .foregroundColor(.white)
            .background(Circle().fill(color).frame(width: 50, height: 50))
            .frame(width: 50, height: 50)
    }
}


struct ScoreComponent_Previews: PreviewProvider {
    static var previews: some View {
        ScoreComponent(score: 5)
    }
}
