//
//  EthicsComponent.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 13/04/2023.
//

import SwiftUI


struct EthicsComponent: View {
    let ethicsData: [Ethics]
    
    var body: some View {
        HStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("Ethics").font(.title)
                    ForEach(ethicsData, id: \.model.identifier) { model in
                        VStack(alignment: .leading) {
                            Text("• \(model.model.name)").font(.title2)
                            ForEach(model.factors, id: \.identifier) { factor in
                                HStack {
                                    Text("•").font(.body).opacity(0)
                                    Text("\(factor.name): \n \(factor.reason)")
                                }
                                HStack {
                                    Text("•").font(.body).opacity(0)
                                    ProgessBarComponent(score: factor.score).frame(width: 200)
                                    Text("Score: \(factor.score)/5").bold()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct EthicsComponent_Previews: PreviewProvider {
    static var previews: some View {
        EthicsComponent(ethicsData: SharedData().demoProduct.ethics)
    }
}
