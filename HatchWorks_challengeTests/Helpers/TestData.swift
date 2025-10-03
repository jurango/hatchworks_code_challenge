//
//  TestData.swift
//  HatchWorks_challengeTests
//
//  Created by Juan Pablo Urango Vitola on 3/10/25.
//

import Foundation
@testable import HatchWorks_challenge

enum TestData {

    // MARK: - Character

    static func createCharacter(
        id: Int = 1,
        name: String = "Rick Sanchez",
        status: String = "Alive",
        species: String = "Human",
        type: String = "",
        gender: String = "Male",
        origin: Location = createLocation(name: "Earth (C-137)"),
        location: Location = createLocation(name: "Citadel of Ricks"),
        image: String = "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episode: [String] = ["https://rickandmortyapi.com/api/episode/1", "https://rickandmortyapi.com/api/episode/2"],
        url: String = "https://rickandmortyapi.com/api/character/1",
        created: String = "2017-11-04T18:48:46.250Z"
    ) -> Character {
        return Character(
            id: id,
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            origin: origin,
            location: location,
            image: image,
            episode: episode,
            url: url,
            created: created
        )
    }

    // MARK: - Location

    static func createLocation(
        name: String = "Earth (C-137)",
        url: String = "https://rickandmortyapi.com/api/location/1"
    ) -> Location {
        return Location(name: name, url: url)
    }

    // MARK: - Episode

    static func createEpisode(
        id: Int = 1,
        name: String = "Pilot",
        airDate: String = "December 2, 2013",
        episode: String = "S01E01",
        characters: [String] = ["https://rickandmortyapi.com/api/character/1"],
        url: String = "https://rickandmortyapi.com/api/episode/1",
        created: String = "2017-11-10T12:56:33.798Z"
    ) -> Episode {
        return Episode(
            id: id,
            name: name,
            airDate: airDate,
            episode: episode,
            characters: characters,
            url: url,
            created: created
        )
    }

    // MARK: - PageInfo

    static func createPageInfo(
        count: Int = 826,
        pages: Int = 42,
        next: String? = "https://rickandmortyapi.com/api/character?page=2",
        prev: String? = nil
    ) -> PageInfo {
        return PageInfo(count: count, pages: pages, next: next, prev: prev)
    }

    // MARK: - CharacterResponse

    static func createCharacterResponse(
        info: PageInfo = createPageInfo(),
        results: [Character] = [createCharacter()]
    ) -> CharacterResponse {
        return CharacterResponse(info: info, results: results)
    }

    // MARK: - Multiple Characters

    static func createMultipleCharacters(count: Int) -> [Character] {
        return (1...count).map { index in
            createCharacter(
                id: index,
                name: "Character \(index)",
                episode: ["https://rickandmortyapi.com/api/episode/\(index)"]
            )
        }
    }

    // MARK: - Multiple Episodes

    static func createMultipleEpisodes(count: Int) -> [Episode] {
        return (1...count).map { index in
            createEpisode(
                id: index,
                name: "Episode \(index)",
                episode: "S01E\(String(format: "%02d", index))"
            )
        }
    }
}
