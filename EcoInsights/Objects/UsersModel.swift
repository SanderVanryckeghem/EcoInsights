//
//  User.swift
//  EcoInsights
//
//  Created by Jonathan Vercammen on 29/04/2023.
//

import Foundation

struct UsersModel: Codable {
    var identifier: String?
    let firebaseIdentifier: String
    var email: String?
    var userName: String
    var profilePictureUrl: String?
    let rol: String?
    let userSettings: UserSettings?
    var favorites: [String]?
    
    init(identifier: String?, firebaseIdentifier: String, email: String?, userName: String, profilePictureUrl: String?, rol: String?, userSettings: UserSettings?, favorites: [String]?) {
        self.identifier = identifier
        self.firebaseIdentifier = firebaseIdentifier
        self.email = email
        self.userName = userName
        self.profilePictureUrl = profilePictureUrl
        self.rol = rol
        self.userSettings = userSettings
        self.favorites = favorites
    }
}

struct UserSettings: Codable {
    var sourcingPercentage: Int?
    var productionPercentage: Int?
    var packagingPercentage: Int?
    var transportPercentage: Int?
    var ethicsPercentage: Int?
    
    init(sourcingPercentage: Int? = 30, productionPercentage: Int? = 20, packagingPercentage: Int? = 10, transportPercentage: Int? = 40, ethicsPercentage: Int? = 0) {
        self.sourcingPercentage = sourcingPercentage
        self.productionPercentage = productionPercentage
        self.packagingPercentage = packagingPercentage
        self.transportPercentage = transportPercentage
        self.ethicsPercentage = ethicsPercentage
    }
}
