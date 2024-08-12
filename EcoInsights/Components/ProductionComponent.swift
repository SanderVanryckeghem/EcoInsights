//
//  ProductionComponent.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 31/03/2023.
//

import SwiftUI

struct ProductionComponent: View {
    let productionData: [Production]
    
    var body: some View {
        HStack{
            ScrollView(.vertical){
                VStack(alignment: .leading){
                    ForEach(productionData, id: \.model.identifier) { model in
                        Text("Production").font(.title)
                        Text("• \(model.model.name)").font(.title2)
                        ForEach(model.factors, id: \.identifier) { factor in
                            HStack{
                                Text("•").font(.body).opacity(0)
                                Text("\(factor.name): \(factor.reason)")
                            }
                            HStack{
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


struct ProductionComponent_Previews: PreviewProvider {
    static var previews: some View {
        ProductionComponent(productionData: SharedData().demoProduct.production)
    }
}
