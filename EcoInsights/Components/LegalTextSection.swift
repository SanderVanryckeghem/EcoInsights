//
//  LegalTextSection.swift
//  EcoInsights
//
//  Created by Robbe Van hoorebeke on 31/03/2023.
//

import SwiftUI

struct LegalTextSection: View {
    @State private var isShowingTerms = false
    @State private var isShowingPrivacyPolicy = false
    
    var body: some View {
        VStack {
            Text("By continuing, you agree to our ")
                .foregroundColor(.secondary)
            
            HStack(spacing: 0) {
                Text("Terms & Conditions")
                    .foregroundColor(.green)
                    .onTapGesture {
                        self.isShowingTerms = true
                    }
                
                Text(" and ")
                    .foregroundColor(.secondary)
                
                Text("Privacy Policy")
                    .foregroundColor(.green)
                    .onTapGesture {
                        self.isShowingPrivacyPolicy = true
                    }
            }
            
            if isShowingTerms {
                NavigationLink(destination: RegisterView()) {
                    EmptyView()
                }
                .frame(width: 0, height: 0)
                .hidden()
            }
            
            if isShowingPrivacyPolicy {
                NavigationLink(destination: RegisterView()) {
                    EmptyView()
                }
                .frame(width: 0, height: 0)
                .hidden()
            }
        }
    }
}


struct LegalTextSection_Previews: PreviewProvider {
    static var previews: some View {
        LegalTextSection()
    }
}
