# iTunes Music App 🎵

A Flutter application that fetches and displays top songs from iTunes with cart management functionality, built with Riverpod and Clean Architecture.

![App Screenshot](https://via.placeholder.com/300x600?text=iTunes+Music+App) *(Replace with actual screenshot)*

## Features ✨

- **Music Catalog**
  - Fetch top 20 songs from iTunes API
  - Persistent local storage using SQLite
  - Beautiful list view with album artwork
  - Song details screen

- **Audio Playback** (Optional)
  - Play song previews
  - Audio controls

- **Shopping Cart** 🛒
  - Add/remove songs to cart
  - Real-time cart counter
  - Quantity adjustment
  - Checkout summary dialog


## Technical Architecture �

### Clean Architecture Structure
  ```bash
  lib/
  ├── app/ # App configuration
  ├── core/ # Shared components
  │ ├── constants/ # App constants
  │ ├── database/ # Database operations
  │ ├── error/ # Error handling
  │ ├── network/ # API clients
  │ ├── providers/ # Global providers
  │ ├── services/ # Business services
  │ └── utils/ # Utilities
  └── features/ # Feature modules
  ├── cart/ # Cart feature
  │ ├── data/ # Data layer
  │ ├── domain/ # Domain layer
  │ └── presentation/ # UI layer
  └── songs/ # Songs feature
  ├── data/
  ├── domain/
  └── presentation/
  ```

### Tech Stack
- **State Management**: Riverpod (v2.6.1)
- **Local Database**: SQFlite (v2.4.2)
- **API Client**: HTTP (v1.3.0)
- **Image Caching**: CachedNetworkImage (v3.4.1)
- **Audio Playback**: Audioplayers (v6.4.0)
- **Permissions**: PermissionHandler (v11.4.0)


## Requirements 📋

### Development Environment
- Flutter SDK (3.0+ recommended)
- Dart SDK (2.17+)
- Android Studio/VSCode

### Android Specifications
- **Compile SDK**: 35
- **Minimum SDK**: 23
- **Java Version**: 17
- **Kotlin JVM Target**: 17


## Installation ⚙️

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/itunes-music-app.git
   cd itunes-music-app

2. Install dependencies:
   ```bash
   flutter pub get

3. Run the app:
   ```bash
   flutter run

4. Running Tests 🧪
   ```bash
   flutter test


### Dependencies 📦
- **Main Dependencies**:
- Package	Version	Purpose
- flutter_riverpod	^2.6.1	State management
- http	^1.3.0	API calls
- sqflite	^2.4.2	Local database
- audioplayers	^6.4.0	Audio playback
- cached_network_image	^3.4.1	Image caching

- **Dev Dependencies**:
- Package	Version	Purpose
- mockito	^5.4.5	Mocking for tests
- mocktail	^1.0.4	Alternative mocking
- build_runner	^2.4.15	Code generation
