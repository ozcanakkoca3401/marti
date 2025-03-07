# Location Tracking iOS Application

## Case Study Description

### Purpose (Amaç)
To develop an iOS application that tracks user location.


### Requirements (Gereksinimler)

#### Location Tracking
- Track user location and add markers on the map for every 100-meter location change
- Location tracking should work in both foreground and background for extended periods
- Markers should be displayed on the map with address information when tapped
- Users can start/stop location tracking
- Route reset option available; current route should persist until reset


### Technical Requirements
- MVVM architecture implementation
- Any map provider can be used
- Proper Git usage and GitHub repository submission
- UIKit implementation required
- Design is left to the developer's discretion

## Architecture Components

### 1. MVVM Pattern
The application implements the MVVM (Model-View-ViewModel) architectural pattern:
- **View** (MVVMHomeViewController): Handles UI and user interactions
- **ViewModel** (HomeViewModel): Contains business logic and state management
- **Model** (HomeRepository): Manages data operations and API calls

### 2. Core Components
- **CoreNetwork**: Handles network operations
- **CoreExtension**: Contains common extensions and utilities
- **CoreResource**: Manages resources like localizations

### 3. Feature Modules
Each feature is encapsulated in its own module:

#### Home Feature Module
Components:
- **HomeRouter**: Handles navigation and module initialization
- **HomeViewModel**: Business logic and state management
- **HomeRepository**: Data operations
- **MVVMHomeViewController**: UI and user interactions
- **Custom Views**: e.g., AnnotationDetailView

## Features
- Real-time location tracking
- Background location updates
- Map markers with address information
- Start/Stop tracking functionality
- Route persistence and reset option
- User permission handling

## Dependencies
- UIKit
- MapKit
- CoreLocation
- SnapKit
- SVProgressHUD

## Getting Started
1. Clone the repository
2. Install dependencies
3. Open the workspace/project
4. Build and run

## Development Guidelines
1. Follow MVVM architecture
2. Implement proper error handling
3. Follow iOS best practices
4. Document code when necessary
5. Use Git version control effectively


<img width="697" alt="Screenshot 2025-03-07 at 20 00 34" src="https://github.com/user-attachments/assets/547a5b17-f22c-44cd-a8e8-b7921b430283" />
<img width="697" alt="Screenshot 2025-03-07 at 20 00 34" src="https://github.com/user-attachments/assets/83f82fee-5454-4b61-8b69-b07ab82091be" />
<img width="697" alt="Screenshot 2025-03-07 at 20 00 34" src="https://github.com/user-attachments/assets/4df4d8e5-3c1e-459a-b110-31d3ca063639" />

   
