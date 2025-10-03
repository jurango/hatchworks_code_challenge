//
//  MockNetworkService.swift
//  HatchWorks_challengeTests
//
//  Created by Juan Pablo Urango Vitola on 3/10/25.
//

import Foundation
@testable import HatchWorks_challenge

class MockNetworkService: NetworkServiceProtocol {

    // MARK: - Mock Properties

    var mockCharacterResponse: CharacterResponse?
    var mockEpisodes: [Episode]?
    var mockError: Error?
    var fetchCharactersCallCount = 0
    var lastPageRequested: Int?
    var fetchEpisodesCallCount = 0
    var lastEpisodeIdsRequested: [Int]?

    // MARK: - NetworkServiceProtocol Implementation

    func fetchCharacters(page: Int?) async throws -> CharacterResponse {
        fetchCharactersCallCount += 1
        lastPageRequested = page

        if let error = mockError {
            throw error
        }

        guard let response = mockCharacterResponse else {
            fatalError("MockNetworkService: mockCharacterResponse not set")
        }

        return response
    }

    func fetchEpisodes(ids: [Int]) async throws -> [Episode] {
        fetchEpisodesCallCount += 1
        lastEpisodeIdsRequested = ids

        if let error = mockError {
            throw error
        }

        guard let episodes = mockEpisodes else {
            fatalError("MockNetworkService: mockEpisodes not set")
        }

        return episodes
    }

    // MARK: - Helper Methods

    func reset() {
        mockCharacterResponse = nil
        mockEpisodes = nil
        mockError = nil
        fetchCharactersCallCount = 0
        lastPageRequested = nil
        fetchEpisodesCallCount = 0
        lastEpisodeIdsRequested = nil
    }
}
