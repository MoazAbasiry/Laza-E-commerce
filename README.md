# 🛍️ Laza - E-commerce Mobile App (MVP)

## 1. Project Overview 📋
This is a functional e-commerce Minimum Viable Product (MVP) developed as a final project for the **Mobile App Development** course at **Alexandria National University**. The app, named **Laza**, is built using **Flutter** and provides a seamless shopping experience integrated with **Firebase** and external APIs.

### Core Goals:
* **Authentication**: Sign up and log in using Firebase Authentication.
* **Product Management**: Browse products and view details via Platzi Fake Store API.
* **Persistence**: User cart and favorites are persisted in Cloud Firestore.
* **Checkout**: A complete mock checkout flow with a success screen.

---

## 2. Setup and Installation 🛠️

### Prerequisites:
* **Flutter SDK**: Latest stable version.
* **Java Development Kit (JDK)**: Version 11 or higher.
* **Android Studio / Xcode**: For emulators and platform-specific build tools.

### Steps to Run:
1. **Clone the Repository**:
   git clone [Your-Repository-URL]
   
2. **Install Dependencies**:
   flutter pub get
   
3. **Firebase Configuration**: Ensure google-services.json (Android) or GoogleService-Info.plist (iOS) is placed in the correct directories.

4. **Launch the App**:
   flutter run

---

## 3. Repository Structure 📂
The project follows a clean, modular folder structure as required:
* `/lib`: Contains all Flutter source code.
* `/appium_tests`: Automation scripts and test documentation.
* `/docs/results`: Appium execution logs and summaries.
* `/screenshots`: UI captures during app testing.
* `/video`: Full app flow screen recording.
* `firestore.rules`: Security rules for Firestore collections.

---

## 4. Testing & QA (Appium) 🧪
We have implemented two mandatory end-to-end (E2E) tests using **Appium**:

1. **Auth Test**: Validates the flow from opening the app, signing up, and logging in to reaching the Home screen.
2. **Cart Test**: Validates opening a product, adding it to the cart, and verifying its existence in the cart screen.

### How to Run Tests:
* Start the **Appium Server** on port 4723.
* Ensure the emulator/device is connected.
* Scripts are located in `/appium_tests`.

---

## 5. Video Demonstration 🎥
A screen recording is available in the `/video` folder demonstrating the following 7 steps:
1. Login/Signup process.
2. Browsing products from the API.
3. Viewing specific product details.
4. Adding/removing items from favorites.
5. Adding items to the shopping cart.
6. Viewing the cart and performing a mock checkout.
7. Logging out of the application.

---

## 6. Firebase & Firestore Rules 🛡️
The app uses Firebase for user data management. Security rules are defined in `firestore.rules` to allow authenticated users to manage their own `users`, `carts`, and `favorites` data only.

---
**Course**: Mobile App Development (Fall 2025)
**Program**: Cybersecurity - Faculty of Computers and Data Science
**Institution**: Alexandria National University