//
//  NetworkService.swift
//  HatchWorks_challenge
//
//  Created by Juan Pablo Urango Vitola on 2/10/25.
//
import Foundation

protocol NetworkServiceProtocol {
    func fetchCharacters() async throws -> CharacterResponse
    func fetchEpisodes(ids: [Int]) async throws -> [Episode]
}

class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://rickandmortyapi.com/api"
    private let urlSession = URLSession.shared
    
    func fetchCharacters() async throws -> CharacterResponse {
        guard let url = URL(string: "\(baseURL)/character") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            let characterResponse = try JSONDecoder().decode(CharacterResponse.self, from: data)
            return characterResponse
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func fetchEpisodes(ids: [Int]) async throws -> [Episode] {
        let idsString = ids.map { String($0) }.joined(separator: ",")
        
        guard let url = URL(string: "\(baseURL)/episode/\(idsString)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            if ids.count == 1 {
                let episode: Episode = try JSONDecoder().decode(Episode.self, from: data)
                return [episode]
            } else {
                let episodes: [Episode] = try JSONDecoder().decode([Episode].self, from: data)
                return episodes
            }
        } catch {
            throw NetworkError.decodingError
        }
    }
}
