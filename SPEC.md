# EcomService - Technical Specification

**Version:** 1.0.0  
**Last Updated:** February 2, 2026  
**Status:** MVP Complete

---

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Features](#features)
4. [Screens & Navigation](#screens--navigation)
5. [State Management](#state-management)
6. [Data Layer](#data-layer)
7. [UI/UX Guidelines](#uiux-guidelines)
8. [Localization](#localization)
9. [Theme System](#theme-system)
10. [Dependencies](#dependencies)
11. [Future Enhancements](#future-enhancements)

---

## Overview

### Project Summary
EcomService is a modern, feature-rich e-commerce mobile application built with Flutter. It demonstrates best practices in mobile development, including Clean Architecture, BLoC pattern for state management, and a premium user interface.

### Goals
- Provide seamless shopping experience with guest browsing
- Implement modern UI/UX patterns with smooth animations
- Support multiple languages and themes
- Build scalable architecture for future enhancements
- Demonstrate professional Flutter development practices

### Target Platforms
- Android (API 21+)
- iOS (12.0+)

---

## Architecture

### Clean Architecture Layers

#### 1. **Presentation Layer** (`lib/presentation/`)
Handles UI and user interactions.

**Components:**
- **BLoCs** - Business Logic Components for state management
  - `AuthBloc` - Authentication state
  - `CartBloc` - Shopping cart management
  - `FavoriteBloc` - Favorite products
  - `HomeBloc` - Home screen data
  - `ProductBloc` - Product details
  - `ProfileBloc` - User profile
  - `ThemeBloc` - Theme management
  - `LanguageBloc` - Language switching

- **Screens** - UI pages
  - `SplashScreen` - App entry point
  - `LoginScreen` - User authentication
  - `HomeScreen` - Product browsing
  - `ProductDetailScreen` - Product information
  - `CartScreen` - Shopping cart
  - `FavoritesScreen` - Saved products
  - `ProfileScreen` - User settings
  - `MainScreen` - Bottom navigation shell

- **Widgets** - Reusable components
  - `ProductCard` - Product list item
  - `ShimmerLoading` - Loading skeletons
  - `ProductDetailShimmer` - Detail page loader

#### 2. **Domain Layer** (`lib/domain/`)
Contains business logic and entities.

**Components:**
- **Entities** - Pure business objects
  - `Product` - Product details
  - `Category` - Product categories
  - `CartItem` - Cart entry
  - `User` - User data

- **Repositories (Interfaces)** - Contracts for data access
  - `ProductRepository`
  - `CategoryRepository`
  - `CartRepository`
  - `AuthRepository`

- **Use Cases** - Business operations
  - `GetProductsUseCase`
  - `GetCategoriesUseCase`
  - `AddToCartUseCase`
  - `ToggleFavoriteUseCase`

#### 3. **Data Layer** (`lib/data/`)
Handles data sources and persistence.

**Components:**
- **Models** - Data transfer objects
  - `ProductModel` - Product JSON mapping
  - `CategoryModel` - Category JSON mapping

- **Repositories (Implementations)** - Data access logic
  - `ProductRepositoryImpl`
  - `CategoryRepositoryImpl`
  - `CartRepositoryImpl`

- **Data Sources**
  - `StaticDataSource` - Mock data (current)
  - `RemoteDataSource` - API calls (future)
  - `LocalDataSource` - Hive/SharedPreferences

#### 4. **Core Layer** (`lib/core/`)
Shared utilities and configurations.

**Components:**
- `AppTheme` - Theme definitions
- `AppColors` - Color palette
- `AppConstants` - App-wide constants
- `AppLocalizations` - i18n setup

---

## Features

### 1. Guest Browsing
- **Description:** Users can browse products without authentication
- **Flow:** Splash → Home Screen
- **Auth Requirement:** Only at checkout

### 2. Product Catalog
- **Categories:** Electronics, Fashion, Home, Sports, Books (mock data)
- **Display:** Grid and list layouts
- **Features:**
  - Product images from Unsplash
  - Price and rating display
  - "New" and "Best Seller" badges
  - Quick add-to-cart

### 3. Product Details
- **Layout:** Based on `appdesigns/product_details/code.html`
- **Features:**
  - Image slider with page indicators
  - Price badge with teal accent
  - Rating summary (stars, reviews, recommendation %)
  - Color selector (3 options)
  - Collapsible description with "Read More"
  - Detailed ratings breakdown (5-star bars)
  - Sticky footer with favorite & add-to-cart
  - Share functionality placeholder

### 4. Shopping Cart
- **Features:**
  - Add/remove products
  - Quantity adjustment
  - Total price calculation
  - Clear cart option
  - Auth check at checkout
  - Redirect to login if not authenticated

### 5. Favorites
- **Features:**
  - Toggle favorite on products
  - Persistent storage (Hive)
  - View all favorites
  - Quick access from product cards

### 6. User Profile
- **Features:**
  - Language selection (EN, FR, AR)
  - Theme toggle (Light/Dark)
  - Currency display (USD)
  - Settings placeholders
  - Logout functionality

### 7. Localization
- **Supported Languages:**
  - English (en)
  - French (fr)
  - Arabic (ar)
- **Implementation:** Flutter i18n with ARB files
- **Switching:** Real-time language change via Profile

### 8. Theming
- **Modes:** Light and Dark
- **Colors:**
  - Primary: `#1337EC` (Blue)
  - Accent: `#008080` (Teal)
  - Background Light: `#F6F6F8`
  - Background Dark: `#101322`
- **Switching:** Toggle in Profile screen

### 9. Shimmer Loading
- **Screens with Shimmer:**
  - Home Screen (carousel, categories, products)
  - Product Detail Screen
- **Effect:** Animated gradient shimmer on skeleton components

---

## Screens & Navigation

### Navigation Structure

```
Splash Screen (2s delay)
    ↓
Home Screen (with Bottom Navigation)
    ├── Home Tab
    │   └── Product Detail
    ├── Cart Tab
    │   └── Login (if checkout clicked & not authenticated)
    ├── Favorites Tab
    └── Profile Tab
        └── Login
```

### Navigation Implementation
- **Package:** `go_router` (v17.0.0)
- **Type:** Declarative routing with StatefulShellRoute
- **Deep Linking:** Supported for product details

### Route Definitions

| Path | Screen | Description |
|------|--------|-------------|
| `/` | SplashScreen | App entry point |
| `/login` | LoginScreen | Authentication |
| `/home` | HomeScreen | Main product catalog |
| `/home/product/:id` | ProductDetailScreen | Product details |
| `/cart` | CartScreen | Shopping cart (via bottom nav) |
| `/favorites` | FavoritesScreen | Saved products (via bottom nav) |
| `/profile` | ProfileScreen | User settings (via bottom nav) |

---

## State Management

### BLoC Pattern
All state is managed using the BLoC (Business Logic Component) pattern via `flutter_bloc`.

### State Flow Example (Product Detail)

```
User Action
    ↓
UI dispatches Event → ProductBloc
    ↓
BLoC calls UseCase → ProductRepository
    ↓
Repository fetches data → DataSource
    ↓
Data returns ← Models converted to Entities
    ↓
BLoC emits State ← UI updates
```

### BLoC Events & States

#### HomeBloc
**Events:**
- `GetHomeData` - Initial load
- `RefreshHomeData` - Pull-to-refresh

**States:**
- `HomeInitial`
- `HomeLoading`
- `HomeLoaded(categories, trendingProducts, newProducts)`
- `HomeError(message)`

#### CartBloc
**Events:**
- `GetCart` - Load cart
- `AddToCart(product)` - Add item
- `RemoveFromCart(product)` - Remove item
- `UpdateCartQuantity(product, quantity)` - Update quantity
- `ClearCart` - Empty cart

**States:**
- `CartInitial`
- `CartLoading`
- `CartUpdated(items, totalAmount)`
- `CartError(message)`

#### ProductBloc
**Events:**
- `GetProductDetail(productId)` - Load product

**States:**
- `ProductInitial`
- `ProductLoading`
- `ProductLoaded(product)`
- `ProductError(message)`

---

## Data Layer

### Current Implementation (MVP)
Uses `StaticDataSource` with hardcoded mock data:
- 50 products with real Unsplash images
- 5 categories
- Simulated network delay (500ms)

### Product Model

```dart
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? oldPrice;
  final String image;
  final double rating;
  final String categoryId;
  final bool isTrending;
  final bool isNew;
  final bool isFavorite;
}
```

### Product Image URLs
10 curated Unsplash image URLs cycling through products:
- Headphones, watches, sunglasses, sneakers
- Cameras, backpacks, laptops, fitness trackers
- Bags, hoodies

### Persistent Storage
- **Cart:** Hive database (`cart_box`)
- **Favorites:** Hive database (`favorites_box`)
- **Preferences:** SharedPreferences (theme, language)

---

## UI/UX Guidelines

### Design System

#### Typography
- **Font:** Inter (imported via Google Fonts)
- **Sizes:**
  - Headline: 28px, bold
  - Title: 18px, bold
  - Body: 15px, regular
  - Caption: 12px, medium

#### Spacing
- Standard padding: 16px
- Card margins: 16px horizontal, 8px vertical
- Section spacing: 24px

#### Border Radius
- Cards: 16px
- Buttons: 12px
- Inputs: 12px
- Small elements: 8px

#### Colors (Light Mode)
- Background: `#F6F6F8`
- Card: `#FFFFFF`
- Text: `#0D101B`
- Text Secondary: `#6B7280`

#### Colors (Dark Mode)
- Background: `#101322`
- Card: `#161A2E`
- Text: `#FFFFFF`
- Text Secondary: `#9CA3AF`

### Loading States
- **Use Shimmer:** For skeleton content (preferred)
- **Use Spinner:** Only for small actions (e.g., button loading)
- **Never:** Show blank screens while loading

### Error Handling
- Display user-friendly error messages
- Provide retry options where applicable
- Log errors for debugging

---

## Localization

### Supported Languages

| Language | Code | Coverage |
|----------|------|----------|
| English | en | 100% |
| French | fr | 100% |
| Arabic | ar | 100% (RTL support) |

### Key Translations

```yaml
app_title: "ecomservice"
home: "Home"
cart: "Cart"
favorites: "Favorites"
profile: "Profile"
trending: "Trending"
new_arrivals: "New Arrivals"
view_all: "View All"
categories: "Categories"
add_to_cart: "Add to Cart"
buy_now: "Buy Now"
```

### Implementation
- **ARB Files:** `assets/translations/app_en.arb`, etc.
- **Configuration:** `l10n.yaml`
- **Generation:** Manual `AppLocalizations` class (workaround for flutter gen-l10n issue)

---

## Theme System

### Theme Configuration

**Primary Color:** `#1337EC` (Blue)
- Used for: buttons, links, accents, active states

**Secondary Color:** `#008080` (Teal)
- Used for: badges, highlights, success states

**Background Colors:**
- Light: `#F6F6F8`
- Dark: `#101322`

### Dynamic Theme Switching
- User toggles theme in Profile screen
- ThemeBloc manages state
- SharedPreferences persists choice
- MaterialApp rebuilds with new theme

### Dark Mode Support
All screens support dark mode with:
- Automatic text color adjustment
- Appropriate background colors
- Adjusted card elevations and shadows

---

## Dependencies

### Production Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_bloc | ^9.1.1 | State management |
| get_it | ^9.2.0 | Dependency injection |
| go_router | ^17.0.0 | Navigation |
| hive | ^2.2.3 | Local database |
| hive_flutter | ^1.1.0 | Hive Flutter integration |
| cached_network_image | ^3.4.1 | Image caching |
| shimmer | ^3.0.0 | Loading effects |
| google_fonts | ^6.3.2 | Custom fonts |
| flutter_svg | ^2.2.3 | SVG support |
| equatable | ^2.0.8 | Value equality |
| intl | ^0.20.2 | Internationalization |
| shared_preferences | ^2.5.3 | Key-value storage |

### Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_test | sdk | Testing framework |
| flutter_lints | ^5.0.0 | Linting rules |
| hive_generator | ^2.0.1 | Hive code generation |
| build_runner | ^2.4.13 | Code generation |

---

## Future Enhancements

### Phase 2 - Backend Integration
- [ ] REST API integration
- [ ] User authentication (JWT)
- [ ] Real product database
- [ ] Order management
- [ ] Payment gateway (Stripe/PayPal)

### Phase 3 - Advanced Features
- [ ] Product search with filters
- [ ] Product reviews and ratings
- [ ] Order history and tracking
- [ ] Push notifications
- [ ] Social login (Google, Facebook, Apple)
- [ ] Wishlist sharing
- [ ] Product recommendations (AI)

### Phase 4 - Optimization
- [ ] Analytics integration (Firebase)
- [ ] Crash reporting (Sentry)
- [ ] Performance monitoring
- [ ] A/B testing
- [ ] SEO for deep links

### Phase 5 - Extended Platform Support
- [ ] Web version
- [ ] Desktop (Windows, macOS, Linux)
- [ ] Tablet-optimized layouts
- [ ] Accessibility improvements (screen readers)

---

## Known Issues & Workarounds

### 1. Localization Generation
**Issue:** `flutter gen-l10n` not generating files  
**Workaround:** Manual `AppLocalizations` class created in `lib/generated/`  
**Status:** Functional, investigate root cause later

### 2. Deprecation Warnings
**Issue:** Flutter API deprecations (`withOpacity`, `onBackground`)  
**Impact:** Informational only, no functional issues  
**Action:** Address in future Flutter update

### 3. NDK Version
**Issue:** Plugin compatibility required NDK 27.0.12077973  
**Fix:** Updated `android/app/build.gradle.kts`  
**Status:** Resolved

---

## Development Guidelines

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` before committing
- Run `flutter analyze` to check for issues

### Naming Conventions
- **Files:** snake_case (e.g., `product_card.dart`)
- **Classes:** PascalCase (e.g., `ProductCard`)
- **Variables:** camelCase (e.g., `productList`)
- **Constants:** SCREAMING_SNAKE_CASE (e.g., `API_BASE_URL`)

### Git Workflow
1. Create feature branch from `main`
2. Make atomic commits with clear messages
3. Test thoroughly before PR
4. Request code review
5. Merge after approval

### Testing
- Write unit tests for BLoCs
- Write widget tests for key screens
- Integration tests for critical flows
- Target minimum 70% code coverage

---

## Contact & Support

**Project Lead:** Taah Emmanuel T  
**Email:** ttemmanuel2020@gmail.com  
**Repository:** https://github.com/Emmanueltt21/ecomservics

---

**Document Version:** 1.0.0  
**Last Updated:** February 2, 2026
