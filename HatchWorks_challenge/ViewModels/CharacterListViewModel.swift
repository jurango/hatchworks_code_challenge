//
//  CharacterListViewModel.swift
//  HatchWorks_challenge
//
//  Created by Juan Pablo Urango Vitola on 2/10/25.
//

import Foundation

@MainActor
class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var canLoadMore: Bool = true
    @Published var isLoadingMore: Bool = false
    
    private var currentPage: Int = 1
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchCharacters() async {
        guard !isLoading else { return }
        await loadCharacters(page: 1, isInitialLoad: true)
    }
    
    func loadMoreCharacters() async {
        guard !isLoadingMore && canLoadMore else { return }
        await loadCharacters(page: currentPage + 1, isInitialLoad: false)
        
    }
    
    private func loadCharacters(page: Int, isInitialLoad: Bool) async {
        if isInitialLoad {
            isLoading = true
        } else {
            isLoadingMore = true
        }
        
        errorMessage = nil
        
        do {
            let response: CharacterResponse = try await networkService.fetchCharacters(page: page)
            characters.append(contentsOf: response.results)
            currentPage = page
            canLoadMore = response.info.next != nil
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "An unexpected error occurred"
        }
        
        if isInitialLoad {
            isLoading = false
        } else {
            isLoadingMore = false
        }
    }
    
    func refresh() async {
        characters = []
        currentPage = 1
        canLoadMore = true
        await fetchCharacters()
    }
}
