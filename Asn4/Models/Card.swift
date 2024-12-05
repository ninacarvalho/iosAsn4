//
//  Card.swift
//  Asn4
//
//  Created by Marina Carvalho on 2024-12-04.
//

import Foundation

struct CardResponse: Codable {
    let data: [Card]
}

struct Card: Codable {
    let id: String
    let name: String
    let images: Images
}

struct Images: Codable {
    let small: String
    let large: String
}
