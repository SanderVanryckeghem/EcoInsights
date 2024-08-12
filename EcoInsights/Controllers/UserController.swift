//
//  UserController.swift
//  EcoInsights
//
//  Created by Jonathan Vercammen on 27/04/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

/// UserController handles the user authentication and user data management.
class UserController : ObservableObject {
    static let shared = UserController()
    
    private var handle: AuthStateDidChangeListenerHandle?
    private var firebaseToken: String?
    
    private let db = Firestore.firestore()
    private let auth = FirebaseAuth.Auth.auth()
    private let baseURL = "https://ecoinsights.xyz"
    
    @Published var user: UsersModel?
    @Published var isLoggedIn = false
    @Published var isFetching: Bool = false
    
    func logout() {
        try? Auth.auth().signOut()
        DispatchQueue.main.async {
            self.user = nil
            self.isLoggedIn = false
        }
    }
    
    func deleteUser() {
        print("Deleting user...")
        guard let firebaseUser = Auth.auth().currentUser else {
            print("No user to delete")
            return
        }
        
        let uid = firebaseUser.uid

        db.collection("users").document(uid).delete { error in
            if let error = error {
                print("Error deleting user document: \(error)")
            } else {
                print("User document deleted successfully")
            }
            
            firebaseUser.delete { error in
                if let error = error {
                    print("Error deleting user: \(error)")
                } else {
                    print("User deleted successfully")
                }
                self.logout()
            }
        }
    }
    
    func registerUser(email: String, username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        // Create user in Firebase
        self.auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating Firebase user: \(error)")
                completion(false, error)
                self.logout()
                return
            }
            
            guard let firebaseUser = authResult?.user else {
                print("Failed to get user from auth result")
                completion(false, nil)
                self.logout()
                return
            }
            
            // Create user in api
            self.createApiUser(username: username, uid: firebaseUser.uid) { result in
                switch result {
                case .failure(let error):
                    print("Error creating API user: \(error)")
                    completion(false, error)
                    return
                case .success(var apiUser):
                    apiUser.email = email
                    print("User created successfully: \(apiUser)")
                    
                    // Link api user and firebase user
                    self.linkApiUserToFirebase(apiGuid: apiUser.identifier!, firebaseGuid: firebaseUser.uid) { success, error in
                        if let error = error {
                            print("Error linking API user to Firebase: \(error)")
                            completion(false, error)
                        } else if let success = success, success {
                            DispatchQueue.main.async {
                                self.user = apiUser
                                self.isLoggedIn = true
                            }
                            completion(true, nil)
                        } else {
                            completion(false, nil)
                        }
                    }
                }
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        // Login with firebase
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            print("Logging in user")
            
            if let error = error {
                print("Error during sign in: \(error)")
                completion(false, error)
                self.logout()
                return
            }
            
            guard let user = authResult?.user else {
                print("No user in authResult")
                completion(false, nil)
                self.logout()
                return
            }
            
            // Fetch user data from API
            self.fetchUser(completion: completion)
        }
    }
    
    func fetchUser(completion: @escaping (Bool, Error?) -> Void) {
        print("Fetching user...")
        guard let firebaseUser = Auth.auth().currentUser else {
            print("No user to fetch")
            return
        }
        getApiUser(userID: firebaseUser.uid) { (apiUser, error) in
            if let error = error {
                print("Error getting API user: \(error)")
                completion(false, error)
                self.logout()
                return
            }
            
            guard let apiUser = apiUser else {
                print("No API user returned")
                completion(false, nil)
                self.logout()
                return
            }
            
            let currentUser = UsersModel(identifier: apiUser.identifier,
                                         firebaseIdentifier: firebaseUser.uid,
                                         email: firebaseUser.email,
                                         userName: apiUser.userName,
                                         profilePictureUrl: apiUser.profilePictureUrl,
                                         rol: apiUser.rol,
                                         userSettings: apiUser.userSettings,
                                         favorites: apiUser.favorites)
            DispatchQueue.main.async {
                self.user = currentUser
                self.isLoggedIn = true
            }
            
            print("Fetched user: \(self.user)")
            completion(true, nil)
        }
    }
    
    
    func likeProduct(productId: String) {
        guard let userId = self.user?.identifier else {
            print("User not logged in")
            return
        }
        
        // Update the local user model
        self.user?.favorites?.append(productId)
        
        // Sync the user model with the API
        self.updateUserModel()
    }
    
    
    func dislikeProduct(productId: String) {
        guard let userId = self.user?.identifier else {
            print("User not logged in")
            return
        }
        
        // Update the local user model
        if let index = self.user?.favorites?.firstIndex(of: productId) {
            self.user?.favorites?.remove(at: index)
        }
        
        // Sync the user model with the API
        self.updateUserModel()
    }
    
    func updateUsername(username: String) {
        self.user?.userName = username
        updateUserModel()
    }
    
    /// Updates the user model on the API
    func updateUserModel() {
        guard let userId = self.user?.identifier,
              let jsonData = encodeUser(self.user!) else {
            print("User not logged in or failed to encode user model")
            return
        }
        
        getFirebaseToken { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.firebaseToken = token
                self.updateUser(userId: userId, jsonData: jsonData)
            case .failure(let error):
                print("Error retrieving Firebase token: \(error)")
            }
        }
    }
    
    /// Performs the actual update request to the server
    private func updateUser(userId: String, jsonData: Data) {
        let url = URL(string: "\(self.baseURL)/users/\(userId)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.firebaseToken!)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to update user model: \(error)")
                return
            }
            
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("Response JSON: \(json)")
            } else {
                print("No data received or couldn't convert data to JSON.")
            }
        }.resume()
    }
    
    
    private func createApiUser(username: String, uid: String, completion: @escaping (Result<UsersModel, Error>) -> Void) {
        // prepare request
        let url = URL(string: "\(baseURL)/users")!
        let userData: [String: Any] = ["userName": username, "firebaseIdentifier": uid]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: userData) else {
            completion(.failure(NSError(domain: "Invalid JSON", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // send request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                return
            }
            
            guard let data = data, httpResponse.statusCode == 200 else {
                let error = NSError(domain: "Server error", code: httpResponse.statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(UsersModel.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getApiUser(userID: String, completion: @escaping (UsersModel?, Error?) -> Void) {
        print("Getting API user...")
        getApiGuidFromUser(userID: userID) { apiGuid, error in
            guard let apiGuid = apiGuid else {
                completion(nil, error)
                return
            }
            
            self.getFirebaseToken { result in
                switch result {
                case .success(let token):
                    let url = URL(string: "\(self.baseURL)/users/\(apiGuid)")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        guard error == nil else {
                            completion(nil, error)
                            return
                        }
                        
                        guard let data = data else {
                            let dataError = NSError(domain: "No data received", code: 0, userInfo: nil)
                            completion(nil, dataError)
                            return
                        }
                        
                        if let user = self.decodeUser(from: data) {
                            completion(user, nil)
                        } else {
                            let decodeError = NSError(domain: "Failed to decode user", code: -1, userInfo: nil)
                            completion(nil, decodeError)
                        }
                    }
                    task.resume()
                    
                case .failure(let tokenError):
                    print("Failed to retrieve Firebase token: \(tokenError.localizedDescription)")
                    completion(nil, tokenError)
                    return
                }
            }
        }
    }
    
    private func getApiGuidFromUser(userID: String, completion: @escaping (String?, Error?) -> Void) {
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let document = document, document.exists else {
                completion(nil, NSError(domain: "User document not found", code: -1, userInfo: nil))
                return
            }
            
            let data = document.data()
            let apiGuid = data?["apiGuid"] as? String
            completion(apiGuid, nil)
        }
    }
    
    private func getFirebaseToken(completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "Not logged in", code: -1, userInfo: nil)))
            return
        }
        
        currentUser.getIDTokenForcingRefresh(true) { (token, error) in
            if let error = error {
                print("Failed to retrieve Firebase token: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let token = token else {
                print("Firebase token is nil")
                completion(.failure(NSError(domain: "Token is nil", code: -1, userInfo: nil)))
                return
            }
            
            print("Fetched firebase token")
            self.firebaseToken = token
            completion(.success(token))
        }
    }
    
    private func linkApiUserToFirebase(apiGuid: String, firebaseGuid: String, completion: @escaping (Bool?, Error?) -> Void?) {
        let userRef = self.db.collection("users").document(firebaseGuid)
        let data: [String: Any] = ["apiGuid": apiGuid]
        
        userRef.setData(data) { error in
            guard error == nil else {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }
    
    private func decodeUser(from data: Data) -> UsersModel? {
        let decoder = JSONDecoder()
        
        if let userString = String(data: data, encoding: .utf8) {
            print("USER data: \(userString)")
        } else {
            print("Unable to convert User data to string")
        }
        
        do {
            let user = try decoder.decode(UsersModel.self, from: data)
            return user
        } catch {
            print("Error decoding User data: \(error)")
            return nil
        }
    }
    
    private func encodeUser(_ user: UsersModel) -> Data? {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(user)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Encoded user: \(jsonString)")
            }
            return data
        } catch {
            print("Error encoding User: \(error)")
            return nil
        }
    }
}
