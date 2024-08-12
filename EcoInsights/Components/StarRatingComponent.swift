//
//  StarRatingComponent.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 31/03/2023.
//

import SwiftUI

struct StarRatingComponent: View {
    var rating: Double
    var spacing: CGFloat = 10

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(1..<6) { index in
                starImage(at: index)
                    .foregroundColor(.yellow)
            }
        }
    }

    private func starImage(at index: Int) -> some View {
        let starType: String
        let currentIndexRating = Double(index)
        
        if rating >= currentIndexRating {
            starType = "star.fill"
        } else if rating >= currentIndexRating - 0.5 {
            starType = "star.leadinghalf.fill"
        } else {
            starType = "star"
        }

        return Image(systemName: starType)
    }
}

struct StarRatingComponent_Previews: PreviewProvider {
    static var previews: some View {
        StarRatingComponent(rating: 4.5)
    }
}






