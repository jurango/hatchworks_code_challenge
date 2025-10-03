//
//  CharacterListViewModelTests.swift
//  HatchWorks_challengeTests
//
//  Created by Juan Pablo Urango Vitola on 3/10/25.
//

import XCTest
@testable import HatchWorks_challenge

@MainActor
final class CharacterListViewModelTests: XCTestCase {

    var viewModel: CharacterListViewModel!
    var mockNetworkService: MockNetworkService!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = CharacterListViewModel(networkService: mockNetworkService)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }

    // MARK: - Initial State Tests

    func testInitialState() {
        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isLoadingMore)
        XCTAssertTrue(viewModel.canLoadMore)
        XCTAssertNil(viewModel.errorMessage)
    }

    // MARK: - fetchCharacters Tests

    func testFetchCharacters_Success() async {
        let mockResponse = TestData.createCharacterResponse(
            info: TestData.createPageInfo(next: "https://rickandmortyapi.com/api/character?page=2"),
            results: TestData.createMultipleCharacters(count: 20)
        )
        mockNetworkService.mockCharacterResponse = mockResponse

        await viewModel.fetchCharacters()

        XCTAssertEqual(viewModel.characters.count, 20)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.canLoadMore)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(mockNetworkService.fetchCharactersCallCount, 1)
        XCTAssertEqual(mockNetworkService.lastPageRequested, 1)
    }

    func testFetchCharacters_LastPage_CanLoadMoreFalse() async {
        let mockResponse = TestData.createCharacterResponse(
            info: TestData.createPageInfo(next: nil),
            results: TestData.createMultipleCharacters(count: 10)
        )
        mockNetworkService.mockCharacterResponse = mockResponse

        await viewModel.fetchCharacters()

        XCTAssertEqual(viewModel.characters.count, 10)
        XCTAssertFalse(viewModel.canLoadMore)
    }

    func testFetchCharacters_Error() async {
        mockNetworkService.mockError = NetworkError.serverError(500)

        await viewModel.fetchCharacters()

        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Server error: 500")
    }

    // MARK: - loadMoreCharacters Tests

    func testLoadMoreCharacters_Success() async {
        let firstPageResponse = TestData.createCharacterResponse(
            info: TestData.createPageInfo(next: "https://rickandmortyapi.com/api/character?page=2"),
            results: TestData.createMultipleCharacters(count: 20)
        )
        mockNetworkService.mockCharacterResponse = firstPageResponse
        await viewModel.fetchCharacters()

        let secondPageResponse = TestData.createCharacterResponse(
            info: TestData.createPageInfo(next: "https://rickandmortyapi.com/api/character?page=3", prev: "https://rickandmortyapi.com/api/character?page=1"),
            results: TestData.createMultipleCharacters(count: 20)
        )
        mockNetworkService.mockCharacterResponse = secondPageResponse

        await viewModel.loadMoreCharacters()

        XCTAssertEqual(viewModel.characters.count, 40)
        XCTAssertFalse(viewModel.isLoadingMore)
        XCTAssertTrue(viewModel.canLoadMore)
        XCTAssertEqual(mockNetworkService.fetchCharactersCallCount, 2)
        XCTAssertEqual(mockNetworkService.lastPageRequested, 2)
    }

    func testLoadMoreCharacters_Error() async {
        let mockResponse = TestData.createCharacterResponse(
            info: TestData.createPageInfo(next: "https://rickandmortyapi.com/api/character?page=2"),
            results: TestData.createMultipleCharacters(count: 20)
        )
        mockNetworkService.mockCharacterResponse = mockResponse
        await viewModel.fetchCharacters()

        mockNetworkService.mockError = NetworkError.decodingError

        await viewModel.loadMoreCharacters()

        XCTAssertEqual(viewModel.characters.count, 20)
        XCTAssertEqual(viewModel.errorMessage, "Failed to decode data")
    }

    // MARK: - refresh Tests

    func testRefresh_ClearsCharacters() async {
        let mockResponse = TestData.createCharacterResponse(
            results: TestData.createMultipleCharacters(count: 20)
        )
        mockNetworkService.mockCharacterResponse = mockResponse
        await viewModel.fetchCharacters()

        XCTAssertEqual(viewModel.characters.count, 20)

        await viewModel.refresh()

        XCTAssertEqual(mockNetworkService.fetchCharactersCallCount, 2)
        XCTAssertEqual(mockNetworkService.lastPageRequested, 1)
    }

    func testRefresh_ResetsState() async {
        let firstResponse = TestData.createCharacterResponse(
            info: TestData.createPageInfo(next: nil),
            results: TestData.createMultipleCharacters(count: 10)
        )
        mockNetworkService.mockCharacterResponse = firstResponse
        await viewModel.fetchCharacters()

        XCTAssertFalse(viewModel.canLoadMore)

        let secondResponse = TestData.createCharacterResponse(
            info: TestData.createPageInfo(next: "https://rickandmortyapi.com/api/character?page=2"),
            results: TestData.createMultipleCharacters(count: 20)
        )
        mockNetworkService.mockCharacterResponse = secondResponse

        await viewModel.refresh()

        XCTAssertTrue(viewModel.canLoadMore)
        XCTAssertEqual(viewModel.characters.count, 20)
    }
}
