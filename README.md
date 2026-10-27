# CareSync 🏥

A comprehensive healthcare management application built with **Flutter** and **Firebase**, following **Clean Architecture** principles with **Riverpod** state management.

---

## ✨ Features

### 👤 Patient Side
- Secure sign-in / sign-up with Firebase Auth & Google Sign-In
- Personalized patient home dashboard
- Book and manage appointments with doctors
- Browse doctors by speciality
- Medical records upload and management
- Blood donation request form and tracker
- Ambulance booking and tracking
- Pharmacy — browse categories, products, cart, wishlist, and orders
- Explore Ayurveda health tips and remedies
- In-app chat with doctors

### 🩺 Doctor Side
- Doctor sign-in / sign-up
- View upcoming patients and appointments
- Doctor profile management

### 🛡️ Admin Side
- Admin dashboard
- Manage ambulances, Ayurveda content, pharmacy categories, stores, and products

---

## 🏗️ Architecture

The project follows **Feature-First Clean Architecture**:

```
lib/
├── app/                        # App-level config
│   ├── router/                 # Route names & AppRouter
│   └── theme/                  # AppColors & AppTheme
├── core/                       # Shared utilities & services
└── features/                   # Feature modules
    ├── authentication/
    ├── patients/
    ├── doctors/
    ├── admin/
    ├── appointments/
    ├── ambulance/
    ├── ayurveda/
    ├── blood_donation/
    ├── chat/
    ├── doctor_speciality/
    ├── medical_records/
    ├── onboarding/
    └── pharmacy/
```

Each feature is self-contained with its own presentation/, domain/, and data/ layers.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| State Management | Riverpod 2.x |
| Backend | Firebase (Auth, Firestore, Storage, Realtime DB) |
| Routing | Custom Navigator 2.0 (AppRouter) |
| UI | Material 3, Google Fonts, Lottie, Flutter SVG |
| Local Storage | SharedPreferences, SQLite (sqflite) |
| Dependency Injection | get_it |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.x
- Android Studio / VS Code
- Firebase project configured (google-services.json placed in ndroid/app/)

### Run the app

```bash
# Install dependencies
flutter pub get

# Run on connected device / emulator
flutter run
```

---

## 📁 Project Structure

```
CareSync/
├── android/           # Android native config
├── assets/            # Images, animations, fonts
├── lib/               # Dart source code
│   ├── app/
│   ├── core/
│   └── features/
├── pubspec.yaml       # Dependencies
└── README.md
```

---

## 🔑 Environment Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add an Android app with package name com.example.caresync
3. Download google-services.json and place it in ndroid/app/
4. Enable **Authentication** (Email/Password + Google), **Firestore**, **Realtime Database**, and **Storage**

---


