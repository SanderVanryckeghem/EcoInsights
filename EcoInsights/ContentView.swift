//
//  ContentView.swift
//  test
//
//  Created by Sander Vanryckeghem on 04/03/2023.
//

import SwiftUI

struct ContentView: View {   
    var body: some View {
        NavigationStack{
            TabView {
                ScansView()
                    .tabItem {
                        Image(systemName: "arkit")
                    }
                    .tag(0)
                ProductsView()
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(1)
                FavoritesView()
                    .tabItem {
                        Image(systemName: "heart")
                    }
                    .tag(2)
                AccountsView()
                    .tabItem {
                        Image(systemName: "person")
                    }
                    .tag(3)
            }
            .onAppear(){
                UITabBar.appearance().backgroundColor = .white
                UITabBar.appearance().unselectedItemTintColor = .darkGray

                
            }
            .navigationBarTitle("", displayMode: .inline)
            .accentColor(.green)
            .edgesIgnoringSafeArea(.bottom)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
