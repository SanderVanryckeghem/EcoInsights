//
//  SourcingComponent.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 31/03/2023.
//

import SwiftUI

struct SourcingComponent: View {
    let sourcingData: [Sourcing]
    
    var body: some View {
        HStack{
            ScrollView(.vertical){
                VStack(alignment: .leading){
                    Text("Sourcing").font(.title)
                    ForEach(sourcingData, id: \.model.identifier) { model in
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

struct SourcingComponent_Previews: PreviewProvider {
    static var previews: some View {
        SourcingComponent(sourcingData: SharedData().demoProduct.sourcing)
    }
}
