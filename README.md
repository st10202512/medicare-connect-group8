# MediCare Connect

Android mobile application for **HealthyLife Family Clinic**. The app allows patients to register, log in, book appointments with payment, submit medication requests, and provide feedback. Data is stored in Firebase Authentication and Cloud Firestore. The project is tracked and built using Azure DevOps.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Team Members](#team-members)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Environment Requirements](#environment-requirements)
- [Setup Instructions](#setup-instructions)
- [Build and Test](#build-and-test)
- [Azure DevOps](#azure-devops)
- [Project Structure](#project-structure)
- [Screenshots](#screenshots)
- [Known Limitations](#known-limitations)

---

## Project Overview

HealthyLife Family Clinic is a small private medical facility offering medical consultations, chronic-condition management, and prescription services. The clinic previously relied on physical appointment booking, which caused long queues and double bookings. MediCare Connect digitises the patient journey from registration through booking and payment, with a mobile-first design built in Flutter.

---

## Team Members

| Name | Student Number | Role |
|---|---|---|
| Zwivhuya Prudence Maphalaphatwa | ST1045343 | Project Manager & Team Leader |
| Kitso Zwane | ST10442335 | Lead & Backend Developer |
| Hulani Hope Mashaba | ST10202512 | Frontend Developer & Software Designer |
| Mankane Makinta | ST10435250 | QA Tester & Secretary |

---

## Features

- User registration and login with Firebase Authentication
- Password hashing handled automatically by Firebase
- Single Sign-On (SSO) with Google Sign-In
- Patient dashboard with next appointment preview
- Appointment booking with service selection, date picker, and time slots
- Simulated payment gateway with booking confirmation and reference number
- Medication request submission
- Feedback and complaints form
- Appointment list with status chips (confirmed, pending, cancelled)
- Cancel appointment functionality
- Help & Support card on the profile screen
- Input validation on every form to prevent crashes
- Firebase Firestore for all persistent data
- Settings menu with notification toggle and language selector

### Version 1.1.0 — Task 3 Update

**New Features:**
- Added Settings menu to Profile screen
- Notification reminders toggle
- Language selector (English SA)

**Documentation Improvements:**
- Complete user manual included in Task 3 report
- Relational database structure documented with primary and foreign keys
- Enlarged screenshots for clarity
- GitHub repository linked with complete README

**Bug Fixes (from Task 2 feedback):**
- Lecturer access to Azure DevOps re-verified
- Google Sign-In concurrency error resolved with busy-flag guard
- Logout now fully clears Firebase and Google sessions


## Website

A responsive website prototype for HealthyLife Family Clinic is included in the
`website/` folder. It covers the pages defined in the Task 1 sitemap: Home,
About, Services, Contact, and Login.

Open `website/index.html` in any modern browser to view it. The site uses plain
HTML, CSS, and JavaScript — no build step required.

### Website pages

| Page | File | Purpose |
|---|---|---|
| Home | `index.html` | Clinic intro and feature overview |
| About | `about.html` | Clinic description and values |
| Services | `services.html` | Service list with fees |
| Contact | `contact.html` | Contact details and message form |
| Login | `login.html` | Email/password and Google SSO placeholder |

Screenshots are stored in `evidence/website/`.

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile framework | Flutter 3.47.7 (Dart 3.13.5) |
| Authentication | Firebase Authentication |
| Database | Cloud Firestore |
| SSO | Google Sign-In |
| Build system | Gradle 8.x, AGP 8.11.1, Kotlin 2.2.20 |
| CI/CD | Azure Pipelines (self-hosted agent) |
| Version control | Azure Repos |
| Project tracking | Azure Boards |

---

## Environment Requirements

- Flutter SDK 3.47.7 or later
- Dart 3.13.5 or later
- Android SDK with API 33 or higher
- JDK 17 or later
- Firebase account with an active project
- Azure DevOps account with access to the project repository

---

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://dev.azure.com/ST10202512/MediCareConnect/_git/MediCareConnect
cd MediCareConnect
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Connect to Firebase

If this is your first time running the project, you need to connect it to your own Firebase project:

```bash
firebase login
flutterfire configure
```

When prompted, select your Firebase project and choose the Android platform. This generates `lib/firebase_options.dart`.

### 4. Enable Firebase services

In the Firebase Console, enable the following:

- **Authentication > Sign-in method**
  - Email/Password
  - Google
- **Firestore Database**
  - Create database in test mode

### 5. Add the SHA-1 fingerprint

Google Sign-In requires the SHA-1 fingerprint of your signing certificate.

```bash
cd android
./gradlew signingReport
```

Copy the **SHA1** value under **Variant: debug**, then in the Firebase Console:

1. **Project Settings** (gear icon)
2. Scroll to **Your apps** and select the Android app
3. Click **Add fingerprint** and paste the SHA-1
4. Download the updated `google-services.json`
5. Replace `android/app/google-services.json` with the new file

### 6. Run the app on a physical device

- On your phone, enable Developer Options and USB debugging
- Connect via USB and allow the debugging prompt
- Run:

```bash
flutter run
```

---

## Build and Test

### Build a debug APK

```bash
flutter build apk --debug
```

### Build a release APK

```bash
flutter build apk --release
```

### Run the automated tests

```bash
flutter test
```

Expected result: `All tests passed!`

---

## Azure DevOps

This project uses three Azure DevOps services throughout the development lifecycle.

### Azure Boards

- 10+ User Stories covering every feature
- Child Tasks for each User Story, all assigned to team members
- Board columns show real progress over time

### Azure Repos

- All source code managed in Git
- Regular commits with meaningful messages
- Main branch protected by the automated pipeline

### Azure Pipelines

- Pipeline triggers automatically on every push to `main`
- Uses a self-hosted Windows agent (avoids hosted parallelism limits)
- Runs the following steps:
  1. Set Flutter Environment
  2. Flutter Pub Get
  3. Flutter Test
  4. Build Debug APK
- All steps pass with green checkmarks

---

## Project Structure

```
medicare_connect/
├── android/                    Android platform configuration
├── assets/                     Images and static files
├── evidence/                   Screenshots for submission
│   ├── azure-boards/
│   ├── azure-pipelines/
│   ├── azure-repos/
│   ├── firebase/
│   └── app-screens/
├── lib/
│   ├── main.dart               App entry point, Firebase init
│   ├── firebase_options.dart   Auto-generated Firebase config
│   ├── models/
│   │   └── appointment.dart    Appointment data model
│   ├── services/
│   │   ├── auth_service.dart   Registration, login, SSO
│   │   └── firestore_service.dart Firestore CRUD operations
│   ├── widgets/
│   │   └── custom_button.dart  Reusable button component
│   └── screens/
│       ├── splash_screen.dart
│       ├── auth/
│       │   ├── login_screen.dart
│       │   └── register_screen.dart
│       ├── home/
│       │   └── home_screen.dart
│       ├── booking/
│       │   └── booking_screen.dart
│       ├── payment/
│       │   └── payment_screen.dart
│       ├── appointment/
│       │   └── appointment_detail_screen.dart
│       └── profile/
│           └── profile_screen.dart
├── test/
│   └── widget_test.dart        CustomButton widget tests
├── azure-pipelines.yml         CI pipeline definition
├── pubspec.yaml                Dependencies and project metadata
└── README.md                   This file
```

---

## Screenshots

Screenshots are stored in the `evidence/` folder:

| Folder | Contents |
|---|---|
| `evidence/app-screens/` | App UI: splash, login, dashboard, booking, payment, confirmation |
| `evidence/firebase/` | Firestore collections with 10+ records |
| `evidence/azure-boards/` | Board views showing task tracking |
| `evidence/azure-pipelines/` | Successful pipeline runs |
| `evidence/azure-repos/` | Commit history |

---

## Known Limitations

- Payment gateway is **simulated** for academic demonstration. No real money is transferred.
- Admin dashboard is planned but not implemented in this iteration.
- Google Sign-In requires Google Play Services; it does not work on emulators without Play Store installed.
- Confirmation emails are displayed as a notice, not actually sent.

---

## License

This project is submitted for academic purposes for the module XISD6329 at Rosebank College. Not for commercial use.