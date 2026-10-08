# MediCare Connect

## Project Overview
Android mobile application and responsive website for a private family clinic. The system allows patients to register, log in, book appointments, make payments, request medication, and submit feedback. Clinic staff can manage appointments and view reports through an admin dashboard.

## Team Members
- Hulani Hope Mashaba — ST10202512
- Zwivhuya Prudence Maphalaphatwa — ST1045343
- Kitso Zwane — ST10442335
- Mankane Makinta — ST10435250

## Environment Requirements
- Flutter SDK (version 3.x)
- Android SDK (API 33+)
- Firebase account (for authentication and database)
- Azure DevOps account

## Setup and Run
1. Clone the repository:
   git clone <your-repo-url>
2. Install dependencies:
   flutter pub get
3. Connect a physical Android device via USB with USB debugging enabled.
4. Run the app:
   flutter run --release

## Build and Test
- Build APK: flutter build apk
- Run tests: flutter test

## Azure DevOps
- **Boards**: Used for task allocation and progress tracking.
- **Repos**: Source code management with regular meaningful commits.
- **Pipelines**: Automated build and test on every commit.

## Project Structure
- lib/ — Flutter application source code
- test/ — Automated tests
- assets/ — Images and static files
- azure-pipelines.yml — CI configuration