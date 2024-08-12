//
//  Product.swift
//  EcoInsights
//
//  Created by Jonathan Vercammen on 31/03/2023.
//

import Foundation

struct Product: Codable, Identifiable {
    let identifier: String
    let barcode: String
    let arLabel: String
    let name: String
    let brand: String
    let imageUrl: String
    let type: String
    let totalScore: Double
    let production: [Production]
    let ethics: [Ethics]
    let packaging: [Packaging]
    let transport: [Transport]
    let sourcing: [Sourcing]
    let labels: [EcoLabel]
    
    var id: String { identifier }
}

struct EcoLabel: Codable, Hashable {
    let identifier: String
    let name: String
    let imageUrl: String
}	

struct Production: Codable {
    let model: Model
    let factors: [Factor]
}

struct Ethics: Codable {
    let model: Model
    let factors: [Factor]
}

struct Packaging: Codable {
    let model: Model
    let factors: [Factor]
}

struct Transport: Codable {
    let model: Model
    let factors: [Factor]
}

struct Sourcing: Codable {
    let model: Model
    let factors: [Factor]
}

struct Model: Codable {
    let identifier: String
    let name: String
    let type: String
    let percentage: Int
}

struct Factor: Codable {
    let identifier: String
    let name: String
    let percentage: Int
    let score: Int
    let reason: String
    let classEntityIdentifier: String
}
