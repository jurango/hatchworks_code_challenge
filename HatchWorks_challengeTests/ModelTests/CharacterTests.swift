//
//  CharacterTests.swift
//  HatchWorks_challengeTests
//
//  Created by Juan Pablo Urango Vitola on 3/10/25.
//

import XCTest
@testable import HatchWorks_challenge

final class CharacterTests: XCTestCase {

    // MARK: - Decoding Tests

    func testCharacterDecoding_Success() throws {
        let jsonString = """
        {
            "id": 1,
            "name": "Rick Sanchez",
            "status": "Alive",
            "species": "Human",
            "type": "",
            "gender": "Male",
            "origin": {
                "name": "Earth (C-137)",
                "url": "https://rickandmortyapi.com/api/location/1"
            },
            "location": {
                "name": "Citadel of Ricks",
                "url": "https://rickandmortyapi.com/api/location/3"
            },
            "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            "episode": [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
            ],
            "url": "https://rickandmortyapi.com/api/character/1",
            "created": "2017-11-04T18:48:46.250Z"
        }
        """

        let data = jsonString.data(using: .utf8)!
        let character = try JSONDecoder().decode(Character.self, from: data)

        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Rick Sanchez")
        XCTAssertEqual(character.status, "Alive")
        XCTAssertEqual(character.species, "Human")
        XCTAssertEqual(character.type, "")
        XCTAssertEqual(character.gender, "Male")
        XCTAssertEqual(character.origin.name, "Earth (C-137)")
        XCTAssertEqual(character.location.name, "Citadel of Ricks")
        XCTAssertEqual(character.image, "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        XCTAssertEqual(character.episode.count, 2)
    }

    func testCharacterDecoding_InvalidJSON_ThrowsError() {
        let invalidJSON = """
        {
            "id": "not a number",
            "name": "Rick"
        }
        """

        let data = invalidJSON.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Character.self, from: data))
    }

    // MARK: - CharacterResponse Decoding Tests

    func testCharacterResponseDecoding_Success() throws {
        let jsonString = """
        {
            "info": {
                "count": 826,
                "pages": 42,
                "next": "https://rickandmortyapi.com/api/character?page=2",
                "prev": null
            },
            "results": [
                {
                    "id": 1,
                    "name": "Rick Sanchez",
                    "status": "Alive",
                    "species": "Human",
                    "type": "",
                    "gender": "Male",
                    "origin": {
                        "name": "Earth (C-137)",
                        "url": "https://rickandmortyapi.com/api/location/1"
                    },
                    "location": {
                        "name": "Citadel of Ricks",
                        "url": "https://rickandmortyapi.com/api/location/3"
                    },
                    "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                    "episode": [
                        "https://rickandmortyapi.com/api/episode/1"
                    ],
                    "url": "https://rickandmortyapi.com/api/character/1",
                    "created": "2017-11-04T18:48:46.250Z"
                }
            ]
        }
        """

        let data = jsonString.data(using: .utf8)!
        let response = try JSONDecoder().decode(CharacterResponse.self, from: data)

        XCTAssertEqual(response.info.count, 826)
        XCTAssertEqual(response.info.pages, 42)
        XCTAssertEqual(response.info.next, "https://rickandmortyapi.com/api/character?page=2")
        XCTAssertNil(response.info.prev)
        XCTAssertEqual(response.results.count, 1)
        XCTAssertEqual(response.results.first?.name, "Rick Sanchez")
    }

    // MARK: - Computed Properties Tests

    func testEpisodesIds_ExtractsCorrectIDs() {
        let character = TestData.createCharacter(
            episode: [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2",
                "https://rickandmortyapi.com/api/episode/28"
            ]
        )

        XCTAssertEqual(character.episodesIds, [1, 2, 28])
    }

    func testEpisodesIds_HandlesEmptyArray() {
        let character = TestData.createCharacter(episode: [])

        XCTAssertEqual(character.episodesIds, [])
    }

    func testEpisodesIds_IgnoresInvalidURLs() {
        let character = TestData.createCharacter(
            episode: [
                "https://rickandmortyapi.com/api/episode/1",
                "invalid-url",
                "https://rickandmortyapi.com/api/episode/5"
            ]
        )

        XCTAssertEqual(character.episodesIds, [1, 5])
    }

    func testEpisodesIds_HandlesNonNumericIDs() {
        let character = TestData.createCharacter(
            episode: [
                "https://rickandmortyapi.com/api/episode/abc",
                "https://rickandmortyapi.com/api/episode/10"
            ]
        )

        XCTAssertEqual(character.episodesIds, [10])
    }
}
