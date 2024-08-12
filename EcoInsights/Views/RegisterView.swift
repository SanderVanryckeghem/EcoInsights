//
//  RegisterView.swift
//  EcoInsights
//
//  Created by Jonathan Vercammen on 18/03/2023.
//

import SwiftUI

struct RegisterView: View {
    @State private var navigateToContentView = false
    
    @State private var titleText = "Register"
    @State private var subtitleText = "Create your new account"
    @State private var registerButtonText = "Register"
    @State private var haveAccountText = "Already have an account?"
    @State private var loginButtonText = "Log in"
    
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var showError = false
    
    var body: some View {
        VStack {
            PageTitleComponent(titleText: titleText)
            PageSubtitleComponent(subtitleText: subtitleText)
            Spacer(minLength: 100)
            Group {
                TextField("Email", text: $email)
                    .accessibilityIdentifier("registerEmailTextField")
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 10)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.systemGray4)))
                    .padding(.vertical, 10)
                TextField("Username", text: $username)
                    .accessibilityIdentifier("registerUsernameTextField")
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 10)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.systemGray4)))
                    .padding(.vertical, 10)
                SecureField("Password", text: $password)
                    .accessibilityIdentifier("registerPasswordTextField")
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 10)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.systemGray4)))
                    .padding(.vertical, 10)
                SecureField("Confirm Password", text: $confirmPassword)
                    .accessibilityIdentifier("registerConfirmPasswordTextField")
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 10)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.systemGray4)))
                    .padding(.vertical, 10)
            }
            
            LegalTextSection()
            
            ButtonComponent(
                buttonText: registerButtonText,
                backgroundColor: LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .top, endPoint: .trailing),
                action: register,
                showArrow: false,
                accessibilityIdentifier: "registerButton"
            ).padding(.vertical, 10)
            
            HStack {
                Text(haveAccountText)
                    .font(.callout)
                NavigationTextComponent(destination: LoginView(), navigationText: loginButtonText, accessibilityIdentifier: "loginButton")
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
    }
    
    func register() {
        errorMessage = ""
        
        if email.isEmpty {
            errorMessage = "Please enter your email address"
            return
        }
        
        if username.isEmpty {
            errorMessage = "Please enter a username"
            return
        }
        
        if password.isEmpty {
            errorMessage = "Password cannot be empty!"
            return
        }
        
        if password != confirmPassword {
            errorMessage = "Password do not match!"
            return
        }
        
        UserController.shared.registerUser(email: email, username: username, password: password) { success, error in
            if success {
                self.navigateToContentView = true
            } else {
                showError = true
                self.navigateToContentView = false
                errorMessage = error?.localizedDescription ?? "Unknown error"
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
