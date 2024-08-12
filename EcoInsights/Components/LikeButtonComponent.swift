//
//  LikeButtonComponent.swift
//  EcoInsights
//
//  Created by Jonathan Vercammen on 31/03/2023.
//

import SwiftUI

struct LikeButtonComponent: View {
    @Binding var checked: Bool
    let product: Product
    @State private var showingAlert = false
    @State private var navigateToLogin = false
    
    var body: some View {
        Image(systemName: checked ? "heart.fill" : "heart")
            .resizable()
            .foregroundColor(checked ? .red : .secondary)
            .frame(width: 25, height: 25)
            .onTapGesture {
                if !UserController.shared.isLoggedIn {
                    showingAlert = true
                    return
                }
                checked.toggle()
                if checked {
                    UserController.shared.likeProduct(productId: product.id)
                } else {
                    UserController.shared.dislikeProduct(productId: product.id)
                }
                print(checked)
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Not Logged In"),
                    message: Text("You need to be logged in to like a product."),
                    dismissButton: .default(Text("OK")) {
                        navigateToLogin = true
                    }
                )
            }
            .background(
                NavigationLink(
                    destination: LoginView(),
                    isActive: $navigateToLogin,
                    label: {
                        EmptyView()
                    }
                )
            )
    }
}

