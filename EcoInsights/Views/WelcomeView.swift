//
//  WelcomeView.swift
//  EcoInsights
//
//  Created by Jonathan Vercammen on 09/03/2023.
//

import SwiftUI

struct WelcomeView: View {
    @State private var titleText = "Eco Insight"
    @State private var subtitleText = "Scan your favourite products to see their impact on the environment"
    @State private var exploreNowButtonText = "Explore Now"
    @State private var loginButtonText = "Login"
    @State private var noAccountText = "Don't have an account?"
    @State private var registerButtonText = "Create new account"
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            
            Spacer()

            PageTitleComponent(titleText: titleText)
            PageSubtitleComponent(subtitleText: subtitleText)
            
            Spacer()
            
            Image("welcome_page_dashes")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
            
            Spacer()
            
            VStack {
                NavigationButtonComponent(
                    buttonText: exploreNowButtonText,
                    backgroundColor:  LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .top, endPoint: .trailing),
                    destination: ContentView().navigationBarBackButtonHidden(true),
                    showArrow: true,
                    accessibilityIdentifier: "exploreNowButton"
                )

                NavigationButtonComponent(
                    buttonText: loginButtonText,
                    backgroundColor:  LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .top, endPoint: .trailing),
                    destination: LoginView(),
                    showArrow: true,
                    accessibilityIdentifier: "loginButton"
                )
            }.padding()
            
            HStack {
                Text(noAccountText)
                    .font(.callout)
                NavigationLink(destination: RegisterView()) {
                    Text(registerButtonText)
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .accessibilityIdentifier("registerButton")
            }
            .padding(.bottom, 20)
            .multilineTextAlignment(.center)
            
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
