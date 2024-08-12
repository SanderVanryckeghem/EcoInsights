//
//  ProductCardComponent.swift
//  EcoInsights
//
//  Created by Jonathan Vercammen on 31/03/2023.
//

import SwiftUI
import Combine

struct ProductCardComponent: View {
    @ObservedObject var userController = UserController.shared
    let product: Product
    @State private var isFavorite: Bool = false
    
    init(product: Product) {
        self.product = product
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            VStack(alignment: .center) {
                ZStack(alignment: .center) {
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        Image("\(product.brand) \(product.name)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometryProxy.size.width * 0.5)
                    }
                    
                    HStack() {
                        Spacer().frame(width: 125)
                        VStack() {
                            LikeButtonComponent(checked: $isFavorite, product: product)
                            Spacer()
                        }
                    }
                    .padding(.top)

                }
                .padding(.horizontal)
                
                Spacer()
                VStack(alignment: .center) {
                    Text(product.name)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 10)
                    
                    HStack {
                        ScoreComponent(score: product.totalScore)
                            .scaleEffect(0.8)
                        Spacer()
                        StarRatingComponent(rating: product.totalScore, spacing: 0).scaleEffect(0.9)
                    }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                }
                
            }
            .frame(width: geometryProxy.size.width, height: 230)
            .background(Color(red: 241 / 255, green: 1, blue: 234 / 255))
            .cornerRadius(10)
        }
        .onAppear {
            isFavorite = userController.user?.favorites?.contains(product.id) ?? false
        }
        .onReceive(userController.$user) { _ in
            isFavorite = userController.user?.favorites?.contains(product.id) ?? false
        }
    }
}
