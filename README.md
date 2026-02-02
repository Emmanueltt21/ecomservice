# EcomService - Modern E-Commerce Flutter App

A feature-rich, modern e-commerce mobile application built with Flutter, following Clean Architecture principles and implementing industry best practices.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## 🌟 Features

### Core Functionality
- **Guest Browsing** - Browse products without login requirement
- **Product Catalog** - Browse products by categories with filters
- **Product Details** - Detailed product view with images, ratings, and reviews
- **Shopping Cart** - Add, remove, and manage cart items
- **Favorites** - Save favorite products for later
- **User Authentication** - Login and signup functionality
- **Multi-language Support** - English, French, and Arabic
- **Theme Support** - Light and Dark mode

### UI/UX Highlights
- **Premium Design** - Modern, clean interface matching design specs
- **Shimmer Loading** - Elegant skeleton loaders for better UX
- **Smooth Navigation** - Go Router for seamless page transitions
- **Responsive Layout** - Adapts to different screen sizes
- **Image Slider** - Swipeable product image galleries
- **Bottom Navigation** - Easy access to Home, Cart, Favorites, and Profile

### Technical Features
- **Clean Architecture** - Separation of concerns with layered architecture
- **BLoC Pattern** - State management using flutter_bloc
- **Dependency Injection** - GetIt for dependency management
- **Image Caching** - Cached network images for performance
- **Localization** - i18n support for multiple languages
- **Theme Management** - Dynamic theme switching

## 📱 Screenshots

<!--
Add screenshots here:
- Home Screen
- Product Detail
- Cart
- Profile
-->

## 🏗️ Architecture

The app follows **Clean Architecture** with three main layers:

```
lib/
├── core/                 # Core utilities and constants
│   ├── theme/           # App theme configuration
│   ├── localization/    # i18n setup
│   └── constants/       # App constants
├── data/                # Data layer
│   ├── datasources/     # Data sources (remote, local, static)
│   ├── models/          # Data models
│   └── repositories/    # Repository implementations
├── domain/              # Business logic layer
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Use cases
└── presentation/        # Presentation layer
    ├── blocs/           # BLoC state management
    ├── screens/         # UI screens
    ├── widgets/         # Reusable widgets
    └── routes/          # Navigation configuration
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.x or higher)
- Dart SDK (3.x or higher)
- Android Studio / Xcode (for mobile development)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ecomservics.git
   cd ecomservics
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build

**Android APK**
```bash
flutter build apk --release
```

**iOS**
```bash
flutter build ios --release
```

## 🔧 Configuration

### Localization
- ARB files located in `assets/translations/`
- Configured in `l10n.yaml`
- Supported languages: English (en), French (fr), Arabic (ar)

### Theme
- Primary Color: `#1337EC`
- Light Background: `#F6F6F8`
- Dark Background: `#101322`
- Configuration in `lib/core/theme/app_theme.dart`

## 📦 Dependencies

### Core
- `flutter_bloc` - State management
- `get_it` - Dependency injection
- `go_router` - Navigation
- `equatable` - Value equality

### UI
- `cached_network_image` - Image caching
- `shimmer` - Loading effects
- `google_fonts` - Custom fonts
- `flutter_svg` - SVG support

### Storage
- `hive` & `hive_flutter` - Local database
- `shared_preferences` - Key-value storage

### Localization
- `intl` - Internationalization
- `flutter_localizations` - Flutter i18n

See `pubspec.yaml` for complete list.

## 🗂️ Project Structure

```
ecomservics/
├── android/              # Android native code
├── ios/                  # iOS native code
├── lib/                  # Flutter application code
├── assets/               # Images, translations, fonts
│   ├── images/
│   └── translations/
├── appdesigns/           # Design reference files
├── test/                 # Unit and widget tests
└── pubspec.yaml          # Project dependencies
```

## 🧪 Testing

Run tests:
```bash
flutter test
```

## 📝 Code Style

This project follows the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

Run analyzer:
```bash
flutter analyze
```

Format code:
```bash
dart format .
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- Taah Emmanuel T - Initial work

## 🙏 Acknowledgments

- Design inspiration from modern e-commerce apps
- Flutter community for excellent packages
- Contributors and testers

## 📞 Support

For support, email support@ecomservice.com or open an issue in the repository.

## 🔮 Roadmap

- [ ] Payment integration (Stripe, PayPal)
- [ ] Order tracking
- [ ] Push notifications
- [ ] Social authentication (Google, Facebook)
- [ ] Product reviews and ratings
- [ ] Search functionality
- [ ] Wishlist sharing
- [ ] Backend API integration
- [ ] Real-time inventory updates
- [ ] Analytics integration

---

**Made with ❤️ using Flutter**
