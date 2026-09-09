# Parklink Mobile

Parklink Mobile is a Flutter application that serves as the mobile version of the existing Parklink application. This project aims to provide a seamless user experience while maintaining the same backend and frontend functionalities as the original application.

## Features

- User authentication
- Home screen with an overview of features
- User profile management
- Reusable components for consistent UI

## Project Structure

```
parklink-mobile
├── lib
│   ├── main.dart               # Entry point of the application
│   ├── views                   # Contains all the views/screens
│   │   ├── home_view.dart      # Home screen view
│   │   ├── login_view.dart     # Login screen view
│   │   └── profile_view.dart    # User profile screen view
│   ├── widgets                 # Contains reusable widgets
│   │   └── custom_button.dart   # Custom button widget
│   ├── models                  # Data models
│   │   └── user_model.dart      # User data model
│   ├── services                # API services
│   │   └── api_service.dart     # Handles API calls
│   └── utils                   # Utility functions and constants
│       └── constants.dart       # Application constants
├── pubspec.yaml                # Flutter project configuration
└── README.md                   # Project documentation
```

## Getting Started

To get started with the Parklink Mobile application, follow these steps:

1. **Clone the repository**:
   ```
   git clone <repository-url>
   ```

2. **Navigate to the project directory**:
   ```
   cd parklink-mobile
   ```

3. **Install dependencies**:
   ```
   flutter pub get
   ```

4. **Run the application**:
   ```
   flutter run
   ```

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any enhancements or bug fixes.

## License

This project is licensed under the MIT License. See the LICENSE file for details.