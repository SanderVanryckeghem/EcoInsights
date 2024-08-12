//
//  AccountsView.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 09/03/2023.
//

import SwiftUI

struct AccountsView: View {
    @ObservedObject var userController = UserController.shared
    @State private var showDeleteAlert = false
    
    var username: String {
        userController.user?.userName ?? ""
    }
    
    var userEmail: String {
        userController.user?.email ?? ""
    }
    
    init() {
        let appearance = UINavigationBarAppearance()
        
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.white] // fix text color
        appearance.backButtonAppearance = backItemAppearance
        
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal) // fix indicator color
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
        UINavigationBar.appearance().standardAppearance = appearance
        
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            if userController.user == nil {
                LoginView()
                    .frame(height: geometryProxy.size.height+100)
            } else {
                VStack {
                    VStack{
                        HStack {
                            Spacer()
                            Image(systemName: "trash")
                                .font(.title)
                                .foregroundColor(.black)
                                .onTapGesture {
                                    showDeleteAlert = true
                                }
                                .alert(isPresented: $showDeleteAlert) {
                                    Alert(
                                        title: Text("Delete Account"),
                                        message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                                        primaryButton: .destructive(Text("Delete")) {
                                            userController.deleteUser()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        Image("Tommy")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                        Text(username)
                            .font(.title)
                            .padding(.top, 20)
                        Text(userEmail)
                            .font(.subheadline)
                            .padding(.top, 20)
                    }
                    .background(Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .top, endPoint: .trailing))
                        .frame(width: 800, height:800)
                        .offset(x: 0, y: -250))
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        NavigationLink(destination: ChangePasswordView()) {
                            TextButtonComponent(text: "Change Password", backgroundColor: LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                        }
                        .tint(.white)
                        NavigationLink(destination: ChangeUsernameView()) {
                            TextButtonComponent(text: "Change Username", backgroundColor: LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                        }
                        
                    }
                    .padding(.top, 10)
                    Spacer()
                        .frame(height: 40)
                    NavigationLink(destination: Text("Logout")) {
                        Text("Log Out")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.vertical, 15)
                            .frame(maxWidth:  geometryProxy.size.width - 70)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                                
                            )
                            .onTapGesture {
                                userController.logout()
                            }
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                }
                .frame(width: geometryProxy.size.width-32, height: geometryProxy.size.height-32)
                .padding()
                .background(.white)
            }
        }
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}

