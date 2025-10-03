//
//  NetworkServiceTests.swift
//  HatchWorks_challengeTests
//
//  Created by Juan Pablo Urango Vitola on 3/10/25.
//

import XCTest
@testable import HatchWorks_challenge

final class NetworkServiceTests: XCTestCase {

    var networkService: NetworkService!
    var mockSession: URLSession!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
        networkService = NetworkService(urlSession: mockSession)
        MockURLProtocol.reset()
    }

    override func tearDown() {
        networkService = nil
        mockSession = nil
        MockURLProtocol.reset()
        super.tearDown()
    }

    // MARK: - fetchCharacters Tests

    func testFetchCharacters_Success() async throws {
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
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        MockURLProtocol.mockSuccess(data: data, statusCode: 200, url: url)

        let response = try await networkService.fetchCharacters(page: nil)

        XCTAssertEqual(response.results.count, 1)
        XCTAssertEqual(response.results.first?.name, "Rick Sanchez")
        XCTAssertEqual(response.info.pages, 42)
    }

    func testFetchCharacters_WithPage() async throws {
        let jsonString = """
        {
            "info": {
                "count": 826,
                "pages": 42,
                "next": "https://rickandmortyapi.com/api/character?page=3",
                "prev": "https://rickandmortyapi.com/api/character?page=1"
            },
            "results": []
        }
        """

        let data = jsonString.data(using: .utf8)!
        let url = URL(string: "https://rickandmortyapi.com/api/character?page=2")!
        MockURLProtocol.mockSuccess(data: data, statusCode: 200, url: url)

        let response = try await networkService.fetchCharacters(page: 2)

        XCTAssertEqual(response.info.next, "https://rickandmortyapi.com/api/character?page=3")
        XCTAssertEqual(response.info.prev, "https://rickandmortyapi.com/api/character?page=1")
    }

    func testFetchCharacters_ServerError() async {
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        MockURLProtocol.mockSuccess(data: Data(), statusCode: 500, url: url)

        do {
            _ = try await networkService.fetchCharacters(page: nil)
            XCTFail("Expected serverError to be thrown")
        } catch let error as NetworkError {
            if case .serverError(let statusCode) = error {
                XCTAssertEqual(statusCode, 500)
            } else {
                XCTFail("Expected serverError, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchCharacters_DecodingError() async {
        let invalidJSON = """
        {
            "invalid": "data"
        }
        """

        let data = invalidJSON.data(using: .utf8)!
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        MockURLProtocol.mockSuccess(data: data, statusCode: 200, url: url)

        do {
            _ = try await networkService.fetchCharacters(page: nil)
            XCTFail("Expected decodingError to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.decodingError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - fetchEpisodes Tests

    func testFetchEpisodes_SingleEpisode() async throws {
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
        let url = URL(string: "https://rickandmortyapi.com/api/episode/1")!
        MockURLProtocol.mockSuccess(data: data, statusCode: 200, url: url)

        let episodes = try await networkService.fetchEpisodes(ids: [1])

        XCTAssertEqual(episodes.count, 1)
        XCTAssertEqual(episodes.first?.name, "Pilot")
        XCTAssertEqual(episodes.first?.episode, "S01E01")
    }

    func testFetchEpisodes_MultipleEpisodes() async throws {
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
        let url = URL(string: "https://rickandmortyapi.com/api/episode/1,2")!
        MockURLProtocol.mockSuccess(data: data, statusCode: 200, url: url)

        let episodes = try await networkService.fetchEpisodes(ids: [1, 2])

        XCTAssertEqual(episodes.count, 2)
        XCTAssertEqual(episodes[0].name, "Pilot")
        XCTAssertEqual(episodes[1].name, "Lawnmower Dog")
    }

    func testFetchEpisodes_ServerError() async {
        let url = URL(string: "https://rickandmortyapi.com/api/episode/1")!
        MockURLProtocol.mockSuccess(data: Data(), statusCode: 404, url: url)

        do {
            _ = try await networkService.fetchEpisodes(ids: [1])
            XCTFail("Expected serverError to be thrown")
        } catch let error as NetworkError {
            if case .serverError(let statusCode) = error {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Expected serverError, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
