//
//  PackagingComponent.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 31/03/2023.
//

import SwiftUI

struct PackagingComponent: View {
    let packagingData: [Packaging]
    
    var body: some View {
        HStack{
            ScrollView(.vertical){
                VStack(alignment: .leading){
                    Text("Packaging").font(.title)
                    ForEach(packagingData, id: \.model.identifier) { model in
                        Text("• \(model.model.name)").font(.title2)
                        ForEach(model.factors, id: \.identifier) { factor in
                            VStack(alignment: .leading) {
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
}


struct PackagingComponent_Previews: PreviewProvider {
    static var previews: some View {
        PackagingComponent(packagingData: SharedData().demoProduct.packaging)
    }
}
