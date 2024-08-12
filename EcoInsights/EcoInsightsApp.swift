//
//  EcoInsightsApp.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 04/03/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        setupNavigationBar()
        setupFirebase()
        
        return true
    }
    
    func setupFirebase() {
        FirebaseApp.configure()
        
        if let firebaseUser = FirebaseAuth.Auth.auth().currentUser {
            UserController.shared.fetchUser() { success, error in
                if success {
                    print("Successfully fetched user.")
                } else {
                    print("Failed to fetch user: \(error?.localizedDescription ?? "")")
                    UserController.shared.logout()
                }
            }
        }
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.white] // fix text color
        appearance.backButtonAppearance = backItemAppearance
        
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal) // fix indicator color
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
}

@main
struct EcoInsightsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var productViewModel = ProductViewModel()
    
    var body: some Scene {
        WindowGroup {
            if Auth.auth().currentUser != nil {
                ContentView()
                    .preferredColorScheme(.light)
                    .environmentObject(productViewModel)
                    .environmentObject(UserController.shared)
            }
            else{
                NavigationView {
                    WelcomeView()
                        .preferredColorScheme(.light)
                        .environmentObject(productViewModel)
                        .environmentObject(UserController.shared)
                }
            }
        }
    }
}
