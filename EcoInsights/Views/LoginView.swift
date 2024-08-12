//
//  RegisterView.swift
//  EcoInsights
//
//  Created by Jonathan Vercammen on 18/03/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var navigateToContentView = false
    @State private var showError = false
    @State private var shouldRemember = false
    
    @State private var titleText = "Welcome back"
    @State private var subtitleText = "Login to your account"
    @State private var loginButtonText = "Login"
    @State private var noAccountText = "Don't have an account?"
    @State private var registerButtonText = "Create new account"
    @State private var rememberMeText = "Remember me"
    @State private var forgotPasswordText = "Forgot password?"
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            VStack{
                PageTitleComponent(titleText: titleText)
                PageSubtitleComponent(subtitleText: subtitleText)
            }
            .offset(y: -38)
            Spacer(minLength: 100)
            VStack {
                TextField("Email", text: $email)
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 10)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.systemGray4)))
                    .padding(.vertical, 10)
                SecureField("Password", text: $password)
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 10)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.systemGray4)))
                    .padding(.vertical, 10)
                
                HStack {
                    CheckboxCircleComponent(checked: $shouldRemember)
                    Text(rememberMeText)
                        .font(.callout)
                    Spacer()
                    
                    NavigationTextComponent(destination: RegisterView(), navigationText: forgotPasswordText, accessibilityIdentifier: "forgotPasswordButton"
                    )
                }
                .padding(.vertical, 20)
                .multilineTextAlignment(.center)
            
                ButtonComponent(
                    buttonText: loginButtonText,
                    backgroundColor: LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .top, endPoint: .trailing),
                    action: login,
                    showArrow: false,
                    accessibilityIdentifier: "loginButton"
                )
            }
            
            HStack {
                Text(noAccountText)
                    .font(.callout)
                NavigationTextComponent(destination: RegisterView(), navigationText: registerButtonText, accessibilityIdentifier: "registerButton")
            }
            .onTapGesture {
                dismissKeyboard()
            }
            .padding(.vertical, 20)
            .multilineTextAlignment(.center)
            
            NavigationLink(destination:
                            ContentView().navigationBarBackButtonHidden(true),
                           isActive: self.$navigateToContentView) {
                EmptyView()
            }.hidden()
            
            Spacer()
        }
        .padding(30)
        .background(Circle()
            .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .top, endPoint: .trailing))
            .frame(width: 1200, height: 1200)
            .offset(x: -200, y: -780))
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .onTapGesture {
            dismissKeyboard()
        }
        
        
        
    }
    
    
    
    func login() {
        errorMessage = ""
        
        if email.isEmpty {
            errorMessage = "Please enter your email address"
            return
        }
        
        if password.isEmpty {
            errorMessage = "Password cannot be empty!"
            return
        }
        
        UserController.shared.loginUser(email: email, password: password) { success, error in
            if success {
                self.navigateToContentView = true
            } else {
                showError = true
                self.navigateToContentView = false
                errorMessage = error?.localizedDescription ?? "Unknown error"
            }
        }
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
