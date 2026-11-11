# MediCare Connect

Android mobile application and fully functional web portal for **HealthyLife Family Clinic**. The app allows patients to register, log in, book appointments with payment, submit medication requests, and provide feedback. It also features dedicated dashboards for Doctors and Admins to manage the clinic's workflow. Data is stored in Firebase Authentication and Cloud Firestore. The project is tracked and built using Azure DevOps.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Team Members](#team-members)
- [Project Links](#project-links)
- [Features](#features)
- [Website](#website)
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

HealthyLife Family Clinic is a small private medical facility offering medical consultations, chronic-condition management, and prescription services. The clinic previously relied on physical appointment booking, which caused long queues and double bookings. MediCare Connect digitises the patient journey from registration through booking and payment, and provides staff with the tools to manage the clinic digitally.

---

## Team Members

| Name | Student Number | Role |
|---|---|---|
| Zwivhuya Prudence Maphalaphatwa | ST1045343 | Project Manager & Team Leader |
| Kitso Zwane | ST10442335 | Lead & Backend Developer |
| Hulani Hope Mashaba | ST10202512 | Frontend Developer & Software Designer |
| Mankane Makinta | ST10435250 | QA Tester & Secretary |

---

## Project Links

| Link | URL |
|---|---|
| **Live Website (Flutter Web)** | [https://medicare-connect-4edec.web.app](https://medicare-connect-4edec.web.app) |
| **GitHub Repository** | [https://github.com/st10202512/medicare-connect-group8.git](https://github.com/st10202512/medicare-connect-group8.git) |
| **Azure DevOps Project** | [https://dev.azure.com/ST10202512/MediCareConnect](https://dev.azure.com/ST10202512/MediCareConnect) |
| **Azure Pipelines** | [https://dev.azure.com/ST10202512/MediCareConnect/_build](https://dev.azure.com/ST10202512/MediCareConnect/_build) |
| **Demo Video** | [https://youtu.be/2xnTWz5_4v0?si=27aENbghoB81s1b2] |

---

## Features

### Core Features
- User registration and login with Firebase Authentication
- Password hashing handled automatically by Firebase
- Single Sign-On (SSO) with Google Sign-In
- Patient dashboard with next appointment preview
- Appointment booking with service selection, date picker, and time slots
- Simulated payment gateway with booking confirmation and reference number
- Medication request submission
- Feedback and complaints form
- Appointment list with status chips (pending, approved, completed, cancelled)
- Cancel appointment functionality
- Help & Support card on the profile screen
- Input validation on every form to prevent crashes
- Firebase Firestore for all persistent data
- Settings menu with notification toggle and language selector

### Multi-Role Features
- **Multi-role authentication:** Dedicated logins for Patients, Doctors, and Admins.
- **3-Stage Appointment Workflow:** Patients book → Admins approve → Doctors consult and prescribe.
- **Digital Prescription Writing:** Doctors can write and save prescriptions to the patient's appointment record.
- **Admin Broadcast Reminders:** Admins can send clinic announcements that appear instantly on all patient dashboards.
- **Manage Requests:** Admin and Doctor dashboards have tabs to view and manage medication requests and patient feedback.

### Web Portal Features
- Fully functional Flutter Web portal sharing the same Firebase database as the mobile app.
- Modern, animated UI (using `animate_do`).
- High-quality clinic images.
- Embedded Google Map on the Contact page.
- Role-based routing on the website (login detects if you are a patient, doctor, or admin).

---

## Website

The website has been upgraded from a static HTML prototype to a fully functional **Flutter Web** application. It shares the exact same backend (Firebase) as the mobile app, meaning data is synced in real-time.

**Live URL:** [https://medicare-connect-4edec.web.app](https://medicare-connect-4edec.web.app)

### Running the website locally
To run the web version of the app:
```bash
flutter run -d chrome -t lib/main_web.dart
Building for hosting
To compile the production build for hosting (e.g., on Firebase Hosting):

bash
flutter build web -t lib/main_web.dart
Tech Stack
Layer	Technology
Mobile framework	Flutter 3.47.7 (Dart 3.13.5)
Web framework	Flutter Web + animate_do
Authentication	Firebase Authentication
Database	Cloud Firestore
SSO	Google Sign-In
Hosting	Firebase Hosting
Build system	Gradle 8.x, AGP 8.11.1, Kotlin 2.2.20
CI/CD	Azure Pipelines (self-hosted agent)
Version control	Azure Repos & GitHub
Project tracking	Azure Boards
Environment Requirements
Flutter SDK 3.47.7 or later

Dart 3.13.5 or later

Android SDK with API 33 or higher

JDK 17 or later

Firebase account with an active project

Azure DevOps account with access to the project repository

Setup Instructions
1. Clone the repository
bash
git clone https://dev.azure.com/ST10202512/MediCareConnect/_git/MediCareConnect
cd MediCareConnect
2. Install dependencies
bash
flutter pub get
3. Connect to Firebase
If this is your first time running the project, you need to connect it to your own Firebase project:

bash
firebase login
flutterfire configure
When prompted, select your Firebase project and choose the Android platform. This generates lib/firebase_options.dart.

4. Enable Firebase services
In the Firebase Console, enable the following:

Authentication > Sign-in method

Email/Password

Google

Firestore Database

Create database in test mode

5. Add the SHA-1 fingerprint
Google Sign-In requires the SHA-1 fingerprint of your signing certificate.

bash
cd android
./gradlew signingReport
Copy the SHA1 value under Variant: debug, then in the Firebase Console:

Project Settings (gear icon)

Scroll to Your apps and select the Android app

Click Add fingerprint and paste the SHA-1

Download the updated google-services.json

Replace android/app/google-services.json with the new file

6. Run the app on a physical device
On your phone, enable Developer Options and USB debugging

Connect via USB and allow the debugging prompt

Run:

bash
flutter run
Build and Test
Build a debug APK
bash
flutter build apk --debug
Build a release APK
bash
flutter build apk --release
Run the automated tests
bash
flutter test
Expected result: All tests passed!

Azure DevOps
This project uses three Azure DevOps services throughout the development lifecycle.

Azure Boards
10+ User Stories covering every feature

Child Tasks for each User Story, all assigned to team members

Board columns show real progress over time

Azure Repos
All source code managed in Git

Regular commits with meaningful messages

Main branch protected by the automated pipeline

Azure Pipelines
Pipeline triggers automatically on every push to main

Uses a self-hosted Windows agent (avoids hosted parallelism limits)

Runs the following steps:

Set Flutter Environment
Flutter Pub Get
Flutter Test
Build Debug APK
All steps pass with green checkmarks

Project Structure
text
medicare_connect/
├── android/                    Android platform configuration
├── assets/                     Images and static files
├── evidence/                   Screenshots for submission
│   ├── azure-boards/
│   ├── azure-pipelines/
│   ├── azure-repos/
│   ├── firebase/
│   ├── app-screens/
│   └── website/
├── lib/
│   ├── main.dart               Mobile app entry point
│   ├── main_web.dart           Web app entry point
│   ├── firebase_options.dart   Auto-generated Firebase config
│   ├── models/
│   ├── services/
│   │   ├── auth_service.dart   Auth & role detection
│   │   └── firestore_service.dart DB CRUD operations
│   ├── widgets/
│   └── screens/
│       ├── splash_screen.dart
│       ├── auth/
│       ├── home/               Patient dashboard & reminders
│       ├── booking/
│       ├── payment/
│       ├── appointment/
│       ├── profile/
│       ├── admin/              Admin dashboard (approvals, reminders)
│       ├── doctor/             Doctor dashboard (prescriptions)
│       └── web/                Flutter Web pages (home, about, services, contact, login)
├── test/
├── azure-pipelines.yml         CI pipeline definition
├── pubspec.yaml                Dependencies and project metadata
└── README.md                   This file
Screenshots
Screenshots are stored in the evidence/ folder:

Folder	Contents
evidence/app-screens/	App UI: splash, login, dashboards, booking, payment, settings
evidence/firebase/	Firestore collections with 10+ records
evidence/azure-boards/	Board views showing task tracking
evidence/azure-pipelines/	Successful pipeline runs
evidence/azure-repos/	Commit history
evidence/website/	Flutter Web pages and live site screenshots
Known Limitations
Payment gateway is simulated for academic demonstration. No real money is transferred.

Google Sign-In requires Google Play Services; it may not work on some Huawei devices or emulators without the Play Store.

Confirmation emails are displayed as a notice, not actually sent.

License
This project is submitted for academic purposes for the module XISD6329 at Rosebank College. Not for commercial use.