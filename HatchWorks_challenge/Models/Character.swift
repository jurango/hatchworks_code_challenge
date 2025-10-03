//
//  Character.swift
//  HatchWorks_challenge
//
//  Created by Juan Pablo Urango Vitola on 2/10/25.
//
struct CharacterResponse: Codable {
    let info: PageInfo
    let results: [Character]
}

struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    //Variable used to extract the ids of the episodes url
    var episodesIds: [Int] {
        episode.compactMap { url in
            // Extract ID from "https://rickandmortyapi.com/api/episode/28"
            // Returnning 28
            guard let id = url.split(separator: "/").last,
                  let episodeNumber = Int(id) else {
                return nil
            }
            
            return episodeNumber
        }
    }
}
