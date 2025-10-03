//
//  ContentView.swift
//  HatchWorks_challenge
//
//  Created by Juan Pablo Urango Vitola on 2/10/25.
//
import Foundation
import SwiftUI

struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.characters.isEmpty && viewModel.isLoading {
                    ProgressView("Loading characters...")
                } else {
                    List(viewModel.characters) { character in
                        NavigationLink(destination: CharacterDetailView(viewModel: CharacterDetailViewModel(character: character))) {
                            CharacterRowView(character: character)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .refreshable {
                        Task {
                            await viewModel.refresh()
                        }
                    }
                }
            }
            .navigationTitle("Characters")
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchCharacters()
            }
        }
    }
}

struct CharacterRowView: View {
    let character: Character
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: character.image)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder : {
                Color.gray.opacity(0.3)
            }
            .frame(width: 60, height: 60)
            .clipShape(.circle)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(statusColor(status: character.status))
                        .frame(width: 8, height: 8)
                    
                    Text("\(character.status) - \(character.species)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private func statusColor(status: String) -> Color {
        switch status {
        case "Alive":
            return Color(red: 0.33, green: 0.8, blue: 0.27)
        case "Dead":
            return Color(red: 0.84, green: 0.24, blue: 0.18)
        case "unknown":
            return Color(red: 0.62, green: 0.62, blue: 0.62)
        default:
            return Color(red: 0.33, green: 0.8, blue: 0.27)
        }
    }
}

#Preview {
    CharacterListView()
}
