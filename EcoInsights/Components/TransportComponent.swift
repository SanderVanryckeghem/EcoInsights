//
//  TransportComponent.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 31/03/2023.
//

import SwiftUI

struct TransportComponent: View {
    let transportData: [Transport]
    
    var body: some View {
        HStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("Transport").font(.title)
                    ForEach(transportData, id: \.model.identifier) { model in
                        VStack(alignment: .leading) {
                            Text("• \(model.model.name)").font(.title2)
                            ForEach(model.factors, id: \.identifier) { factor in
                                HStack {
                                    Text("•").font(.body).opacity(0)
                                    Text("\(factor.name): \(factor.reason)")
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

struct TransportComponent_Previews: PreviewProvider {
    static var previews: some View {
        TransportComponent(transportData: SharedData().demoProduct.transport)
    }
}
