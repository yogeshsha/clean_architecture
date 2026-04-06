# 🎨 Flutter Theme Switching with Riverpod

This project demonstrates how to implement **Light & Dark Theme switching** in Flutter using **Riverpod** for state management.

---

## 🚀 Features

* 🌗 Light & Dark Theme support
* 🔁 Toggle theme dynamically
* ⚡ Fast and reactive using Riverpod
* 🧩 Clean and scalable architecture

---

## 📁 Project Structure

```
lib/
│
├── core/
│   ├── routes/
│   └── theme/
│       ├── app_theme.dart
│       └── theme_provider.dart
│
├── shared/
│
├── feature/
│   └── articles/
│       ├── data/
│       │   ├── data_source/
│       │   │   └── remote_data_source.dart
│       │   ├── model/
│       │   │   └── article_model.dart
│       │   └── repositories/
│       │       └── article_repositories_impl.dart
│       │
│       ├── domain/
│       │   ├── entity/
│       │   │   └── article_entity.dart
│       │   ├── repositories/
│       │   │   └── article_repositories.dart
│       │   └── usecases/
│       │       └── article_usecases.dart
│       │
│       └── presentation/
│           ├── provider/
│           │   └── article_provider.dart
│           ├── screen/
│           │   └── articles_screen.dart
│           └── widgets/
│               ├── article_card.dart
│               └── theme_change_component.dart
│
└── main.dart
```


## 🧠 How It Works

### 1. Theme Provider

Manages the app’s theme state using `StateNotifier`.

```dart
final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);
```

---

### 2. Theme Configuration

Defines **light** and **dark** themes using `ThemeData` and `ColorScheme`.

```dart
static final lightTheme = ThemeData(...);
static final darkTheme = ThemeData(...);
```

---

### 3. App Setup

Connects Riverpod with `MaterialApp`.

```dart
final themeMode = ref.watch(themeModeProvider);

MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: themeMode,
);
```

---

### 4. Toggle Theme

Switch between light and dark mode:

```dart
ref.read(themeModeProvider.notifier).toggleTheme();
```

---

## 🎯 UI Example

### Icon Toggle with InkWell

```dart
InkWell(
  onTap: () {
    ref.read(themeModeProvider.notifier).toggleTheme();
  },
  child: Icon(Icons.brightness_6),
)
```

---

## 🛠️ Dependencies

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.0.0
```

---

## ✨ Future Improvements

* 💾 Persist theme using SharedPreferences
* 🎨 Material 3 dynamic colors
* 🌈 Custom design system (success, error, warning colors)
* 🔄 Animated theme transitions

---

## 👨‍💻 Author

Built with ❤️ using Flutter & Riverpod

---

If you want, I can also:

* Add **theme persistence**
* Convert this into **clean architecture (repo/usecase)**
* Create a **production-ready design system**

Just tell me 👍
