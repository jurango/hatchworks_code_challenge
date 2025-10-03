//
//  EpisodeTests.swift
//  HatchWorks_challengeTests
//
//  Created by Juan Pablo Urango Vitola on 3/10/25.
//

import XCTest
@testable import HatchWorks_challenge

final class EpisodeTests: XCTestCase {

    // MARK: - Decoding Tests

    func testEpisodeDecoding_Success() throws {
        let jsonString = """
        {
            "id": 1,
            "name": "Pilot",
            "air_date": "December 2, 2013",
            "episode": "S01E01",
            "characters": [
                "https://rickandmortyapi.com/api/character/1",
                "https://rickandmortyapi.com/api/character/2"
            ],
            "url": "https://rickandmortyapi.com/api/episode/1",
            "created": "2017-11-10T12:56:33.798Z"
        }
        """

        let data = jsonString.data(using: .utf8)!
        let episode = try JSONDecoder().decode(Episode.self, from: data)

        XCTAssertEqual(episode.id, 1)
        XCTAssertEqual(episode.name, "Pilot")
        XCTAssertEqual(episode.airDate, "December 2, 2013")
        XCTAssertEqual(episode.episode, "S01E01")
        XCTAssertEqual(episode.characters.count, 2)
        XCTAssertEqual(episode.url, "https://rickandmortyapi.com/api/episode/1")
        XCTAssertEqual(episode.created, "2017-11-10T12:56:33.798Z")
    }

    func testEpisodeDecoding_CodingKeys_MapsAirDate() throws {
        let jsonString = """
        {
            "id": 1,
            "name": "Pilot",
            "air_date": "December 2, 2013",
            "episode": "S01E01",
            "characters": [],
            "url": "https://rickandmortyapi.com/api/episode/1",
            "created": "2017-11-10T12:56:33.798Z"
        }
        """

        let data = jsonString.data(using: .utf8)!
        let episode = try JSONDecoder().decode(Episode.self, from: data)

        XCTAssertEqual(episode.airDate, "December 2, 2013")
    }

    func testEpisodeDecoding_InvalidJSON_ThrowsError() {
        let invalidJSON = """
        {
            "id": "not a number",
            "name": "Pilot"
        }
        """

        let data = invalidJSON.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Episode.self, from: data))
    }

    func testEpisodeArrayDecoding_Success() throws {
        let jsonString = """
        [
            {
                "id": 1,
                "name": "Pilot",
                "air_date": "December 2, 2013",
                "episode": "S01E01",
                "characters": [],
                "url": "https://rickandmortyapi.com/api/episode/1",
                "created": "2017-11-10T12:56:33.798Z"
            },
            {
                "id": 2,
                "name": "Lawnmower Dog",
                "air_date": "December 9, 2013",
                "episode": "S01E02",
                "characters": [],
                "url": "https://rickandmortyapi.com/api/episode/2",
                "created": "2017-11-10T12:56:33.916Z"
            }
        ]
        """

        let data = jsonString.data(using: .utf8)!
        let episodes = try JSONDecoder().decode([Episode].self, from: data)

        XCTAssertEqual(episodes.count, 2)
        XCTAssertEqual(episodes[0].name, "Pilot")
        XCTAssertEqual(episodes[1].name, "Lawnmower Dog")
    }
}
