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
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchCharacters() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response: CharacterResponse = try await networkService.fetchCharacters()
            characters.append(contentsOf: response.results)
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "An unexpected error occurred"
        }
        
        isLoading = false
    }
    
    func refresh() async {
        characters = []
        await fetchCharacters()
    }
}
