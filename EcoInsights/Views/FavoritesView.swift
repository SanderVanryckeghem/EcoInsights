//
//  FavoritesView.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 09/03/2023.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var userController = UserController.shared
    @ObservedObject var viewModel: ProductViewModel
    private var titleText = "Favorites"
    
    init() {
        viewModel = ProductViewModel()
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            if userController.user == nil {
                VStack {
                    Spacer()
                    PageTitleComponent(titleText: "Please log in to view your favorite products.").multilineTextAlignment(.center).padding(.bottom, 20)
                    NavigationButtonComponent(
                        buttonText: "Login",
                        backgroundColor: LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .top, endPoint: .trailing),
                        destination: LoginView(),
                        showArrow: false,
                        accessibilityIdentifier: "loginButton"
                    )
                    Spacer()
                }.frame(width: geometryProxy.size.width-32, height: geometryProxy.size.height-32)
                    .padding()
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]),
                                    startPoint: .top,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 1200, height: 1200)
                            .offset(x: -200, y: -850)
                    )
            } else {
                ZStack {
                    // Title and spacing
                    HStack {
                        VStack {
                            PageTitleComponent(titleText: titleText)
                                
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    // Product cards
                    ScrollView {
                        LazyVGrid(columns: [GridItem(), GridItem()], alignment: .center, spacing: 20) {
                            ForEach(viewModel.favoriteProducts) { product in
                                ProductCardComponent(product: product)
                                    .frame(height: 230)
                            }
                        }
                        .padding(5)
                    }
                    .padding(.top, 100)
                }
                .frame(width: geometryProxy.size.width-32, height: geometryProxy.size.height-32)
                .padding()
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]),
                                startPoint: .top,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 1200, height: 1200)
                        .offset(x: -200, y: -850)
                )
                .onChange(of: userController.user?.favorites) { _ in
                    viewModel.updateFavoriteProducts()
                }
            }
        }
    }
}


struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
