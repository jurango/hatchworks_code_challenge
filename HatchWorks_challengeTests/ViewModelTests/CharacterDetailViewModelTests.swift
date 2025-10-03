//
//  CharacterDetailViewModelTests.swift
//  HatchWorks_challengeTests
//
//  Created by Juan Pablo Urango Vitola on 3/10/25.
//

import XCTest
@testable import HatchWorks_challenge

@MainActor
final class CharacterDetailViewModelTests: XCTestCase {

    var viewModel: CharacterDetailViewModel!
    var mockNetworkService: MockNetworkService!
    var testCharacter: Character!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        testCharacter = TestData.createCharacter(
            episode: [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
            ]
        )
        viewModel = CharacterDetailViewModel(character: testCharacter, networkService: mockNetworkService)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        testCharacter = nil
        super.tearDown()
    }

    // MARK: - Initial State Tests

    func testInitialState() {
        XCTAssertTrue(viewModel.episodes.isEmpty)
        XCTAssertFalse(viewModel.isLoadingEpisodes)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.character.id, testCharacter.id)
    }

    // MARK: - fetchEpisodes Tests

    func testFetchEpisodes_Success() async {
        let mockEpisodes = TestData.createMultipleEpisodes(count: 2)
        mockNetworkService.mockEpisodes = mockEpisodes

        await viewModel.fetchEpisodes()

        XCTAssertEqual(viewModel.episodes.count, 2)
        XCTAssertFalse(viewModel.isLoadingEpisodes)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(mockNetworkService.fetchEpisodesCallCount, 1)
        XCTAssertEqual(mockNetworkService.lastEpisodeIdsRequested, [1, 2])
    }

    func testFetchEpisodes_EmptyEpisodeList() async {
        let characterWithNoEpisodes = TestData.createCharacter(episode: [])
        viewModel = CharacterDetailViewModel(character: characterWithNoEpisodes, networkService: mockNetworkService)

        await viewModel.fetchEpisodes()

        XCTAssertTrue(viewModel.episodes.isEmpty)
        XCTAssertFalse(viewModel.isLoadingEpisodes)
        XCTAssertEqual(viewModel.errorMessage, "No episodes available")
        XCTAssertEqual(mockNetworkService.fetchEpisodesCallCount, 0)
    }

    func testFetchEpisodes_Error() async {
        mockNetworkService.mockError = NetworkError.serverError(404)

        await viewModel.fetchEpisodes()

        XCTAssertTrue(viewModel.episodes.isEmpty)
        XCTAssertFalse(viewModel.isLoadingEpisodes)
        XCTAssertEqual(viewModel.errorMessage, "Server error: 404")
    }
}
