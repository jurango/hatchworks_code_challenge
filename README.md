# Rick and Morty Character Explorer

A native iOS application built with SwiftUI that displays characters from the Rick and Morty universe using the [Rick and Morty API](https://rickandmortyapi.com/).

## Features

- **Character List**: Browse all Rick and Morty characters with circular avatars, status indicators, and species information
- **Character Details**: View detailed information including species, gender, origin, location, and episode appearances
- **Pull-to-Refresh**: Refresh character data with a simple pull gesture
- **Dark Mode Support**: Fully supports iOS light and dark modes
- **Modern UI**: Clean, iOS-native design

## Architecture

This project follows the **MVVM (Model-View-ViewModel)** architecture pattern with clean separation of concerns.

### Technology Stack

- **UI Framework**: SwiftUI
- **Networking**: URLSession with async/await
- **Image Loading**: AsyncImage (native SwiftUI)
- **Architecture Pattern**: MVVM
- **Concurrency**: Swift Concurrency (async/await)
- **Deployment Target**: iOS 18.2+

### Project Structure

```
HatchWorks_challenge/
	Models/
		Character.swift          # Character model with episodesIds computed property
		Episode.swift            # Episode model with CodingKeys for airDate mapping
		Location.swift           # Location model for origin/current location
		PageInfo.swift           # Pagination metadata from API
	Services/
		NetworkService.swift     # Network layer with protocol-oriented design
		NetworkError.swift       # Custom error types with localizedDescription
	ViewModels/
		CharacterListViewModel.swift    # Manages character list state
		CharacterDetailViewModel.swift  # Manages character detail and episodes state
	Views/
		CharacterListView.swift  # Main character list screen
		CharacterDetailView.swift # Character detail screen
	HatchWorks_challengeApp.swift # App entry point
```

## API Integration

The app consumes the free [Rick and Morty API](https://rickandmortyapi.com/) (no authentication required).

### Endpoints Used

**1. Get Characters**
```
GET https://rickandmortyapi.com/api/character
```
Returns paginated list of characters with info and results array.

**Response Structure:**
```json
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
      "origin": { "name": "Earth (C-137)", "url": "..." },
      "location": { "name": "Citadel of Ricks", "url": "..." },
      "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
      "episode": ["https://rickandmortyapi.com/api/episode/1", ...],
      "url": "...",
      "created": "..."
    }
  ]
}
```

**2. Get Episodes (Batch)**
```
GET https://rickandmortyapi.com/api/episode/{ids}
```
Fetches multiple episodes using comma-separated IDs (e.g., `/api/episode/1,2,3`).

**Note**: API returns a single object when fetching one ID, and an array when fetching multiple IDs. The NetworkService handles both cases.

**Response Structure:**
```json
[
  {
    "id": 1,
    "name": "Pilot",
    "air_date": "December 2, 2013",
    "episode": "S01E01",
    "characters": [...],
    "url": "...",
    "created": "..."
  }
]
```

## Models

### Character Model
```swift
struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String  // "Alive", "Dead", "unknown"
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]  // URLs to episodes
    let url: String
    let created: String

    // Computed property to extract episode IDs from URLs
    var episodesIds: [Int]
}
```

### Episode Model
```swift
struct Episode: Codable, Identifiable {
    let id: Int
    let name: String
    let airDate: String  // Mapped from "air_date" using CodingKeys
    let episode: String  // e.g., "S01E01"
    let characters: [String]
    let url: String
    let created: String
}
```

### Supporting Models
- **Location**: Contains `name` and `url` for origin/current location
- **PageInfo**: Contains `count`, `pages`, `next`, `prev` for pagination
- **CharacterResponse**: Wrapper containing `info` (PageInfo) and `results` ([Character])

## Design Decisions

### MVVM Architecture
- **Models**: Pure data structures conforming to `Codable` and `Identifiable`
- **ViewModels**: `@MainActor` classes with `@Published` properties for reactive UI
- **Views**: SwiftUI views observing ViewModels with `@StateObject`/`@ObservedObject`

### Dependency Injection
- `NetworkServiceProtocol` enables testability and mocking
- ViewModels receive services via initializers with default values

### Error Handling
- Custom `NetworkError` enum with `localizedDescription` property
- Centralized error messages in the error type itself
- ViewModels display user-friendly error messages via alerts

### UI Components
- **Character List**: `List` with `NavigationLink` for navigation
- **Character Detail**: `ScrollView` with `VStack` for custom layout sections
- **Image Loading**: `AsyncImage` with placeholder for smooth loading
- **Status Indicators**: Color-coded circles

### Modern Swift Features
- **async/await**: Clean asynchronous networking code
- **@MainActor**: Ensures UI updates happen on main thread
- **Computed Properties**: `episodesIds` extracts IDs from episode URLs
- **CodingKeys**: Maps `air_date` to `airDate` for Swift naming conventions

## Getting Started

### Prerequisites

- macOS 13.0 or later
- Xcode 16.2 or later
- iOS 18.2+ Simulator or device

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/jurango/hatchworks_code_challenge.git
   ```
2. Navigate to the project folder and double-click `HatchWorks_challenge.xcodeproj` to open it in Xcode
3. Select a simulator from the scheme selector at the top (e.g., iPhone 15 Pro)
4. Press `Cmd + R` or click the Play button to build and run the app

## License

This project was created as a coding challenge and uses the free [Rick and Morty API](https://rickandmortyapi.com/).

## Author

Created by Juan Pablo Urango Vitola

## Repository

[https://github.com/jurango/hatchworks_code_challenge](https://github.com/jurango/hatchworks_code_challenge)
