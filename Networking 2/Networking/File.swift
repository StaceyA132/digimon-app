//
//  File.swift
//  Networking
//
//

import Foundation

struct Digimon: Codable {
    var id: Int
    var name: String
    var xAntibody: Bool
    var releaseDate: String
    var images: [DigiImage]
    var levels: [DigiLevel]
    var types: [DigiType]
    var attributes: [DigiAttribute]
    var fields: [DigiField]
    var descriptions: [DigiDesc]
    var skills: [DigiSkill]
    var priorEvolutions: [MiniDigi]
    var nextEvolutions: [MiniDigi]
}

struct DigiImage:Codable {
    var href: String
    var transparent: Bool
}

struct DigiLevel:Codable  {
    var id: Int
    var level: String
}
struct DigiType:Codable  {
    var id: Int
    var type: String
}

struct DigiAttribute:Codable  {
    var id: Int
    var attribute: String
}

struct DigiField:Codable  {
    var id: Int
    var field: String
    var image: String
}

struct DigiDesc:Codable  {
    var origin: String
    var language: String
    var description: String
}

struct DigiSkill:Codable  {
    var id: Int
    var skill: String
    var translation: String
    var description: String
}

struct MiniDigi:Codable  {
    var id: Int?
    var digimon: String
    var condition: String
    var image: String
    var url: String
}

struct AllDigimonResponse: Codable {
    var pageable: DigiListPageable
    var content: [DigimonInListResponse]
}

struct DigimonInListResponse:Codable {
    var id: Int
    var name: String
    var href: String
    var image: String
}

struct DigiListPageable:Codable {
    var currentPage: Int
    var elementsOnPage: Int
    var totalElements: Int
    var totalPages: Int
    var previousPage: String
    var nextPage: String
}
