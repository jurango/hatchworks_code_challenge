//
//  CharacterDetailView.swift
//  HatchWorks_challenge
//
//  Created by Juan Pablo Urango Vitola on 2/10/25.
//

import Foundation
import SwiftUI

struct CharacterDetailView: View {
    @ObservedObject var viewModel: CharacterDetailViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            CharacterImageView(imageUrl: viewModel.character.image,
                               name: viewModel.character.name)
            ScrollView {
                VStack(spacing: 20) {
                    BasicInfoView(character: viewModel.character)
                    EpisodesSection(episodes: viewModel.episodes, isLoading: viewModel.isLoadingEpisodes)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.fetchEpisodes()
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

struct CharacterImageView: View {
    let imageUrl: String
    let name: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(height: 300)
            .clipped()
            
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .padding()
        }
    }
}

struct BasicInfoView: View {
    let character: Character
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Species")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(character.species)
                    .font(.body)
                    .foregroundStyle(.primary)
            }
            
            Divider()
            
            HStack {
                Text("Gender")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(character.gender)
                    .font(.body)
                    .foregroundStyle(.primary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct EpisodesSection: View {
    let episodes: [Episode]
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured in \(episodes.count) Episodes")
                .font(.headline)
                .padding(.horizontal)
            
            if isLoading {
                ProgressView("Loading episodes...")
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if episodes.isEmpty {
                Text("No episodes available")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                ForEach(episodes) { episode in
                    EpisodeView(episode: episode)
                }
            }
        }
    }
}

struct EpisodeView: View {
    let episode: Episode
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(episode.episode)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .cornerRadius(6)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(episode.name)
                    .font(.body)
                    .foregroundStyle(.primary)
                
                Text(episode.airDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
