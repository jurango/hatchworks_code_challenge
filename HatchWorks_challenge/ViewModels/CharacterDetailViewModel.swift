//
//  CharacterDetailViewModel.swift
//  HatchWorks_challenge
//
//  Created by Juan Pablo Urango Vitola on 2/10/25.
//

import Foundation

@MainActor
class CharacterDetailViewModel: ObservableObject {
    @Published var episodes: [Episode] = []
    @Published var isLoadingEpisodes: Bool = false
    @Published var errorMessage: String?
    
    let character: Character
    private let networkService: NetworkServiceProtocol
    
    init(character: Character, networkService: NetworkServiceProtocol = NetworkService()) {
        self.character = character
        self.networkService = networkService
    }
    
    func fetchEpisodes() async {
        guard !isLoadingEpisodes else { return }
        
        isLoadingEpisodes = true
        errorMessage = nil
        
        let episodesIds: [Int] = character.episodesIds
        guard !episodesIds.isEmpty else {
            isLoadingEpisodes = false
            errorMessage = "No episodes available"
            return
        }
        
        do {
            episodes = try await networkService.fetchEpisodes(ids: episodesIds)
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Failed to load episodes"
        }
        
        isLoadingEpisodes = false
    }
}
