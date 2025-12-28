# appointment_manager

## Project Environment
This project uses the following environment and tools:
=======================================================
JDK: 17                                               

Flutter: 3.35.5

Android Gradle Plugin: 8.9.1

Kotlin Android Plugin: 2.1.0

Gradle Distribution: gradle-8.12-all.zip

## Project Description

**Appointment Manager** is a Flutter app for managing appointments.  
It supports:
- Offline-first local storage using Hive
- Remote sync with REST API (JSON Server)
- Search and filter appointments by date
- Open appointment locations in Google Maps

## Architecture

The app follows a **MVVM / Repository pattern**:

UI Layer (Screens / Widgets)
        │
        ▼
ViewModel (AppointmentViewModel)  ← Provider State Management
        │
        ▼
Repository (AppointmentRepository)
  ├─ LocalDbService (Hive)
  ├─ AppointmentApiService (Dio / REST API)
  └─ ConnectivityUtility

## Features

- Add, edit, delete appointments
- Offline-first local storage with Hive
- Remote sync when online
- Search by title, customer, company
- Filter by date (All, Today, Upcoming, Past, From-To)
- Tap location to open in Google Maps

## Getting Started

```bash
git clone https://github.com/Mr-NEY/appointment_manager.git

flutter pub get

add  android\local.properties ->MAPS_API_KEY= your_google_map_key

flutter run

---

## Dependencies

- Hive → Local storage
- Provider → State management
- Dio → REST API client
- Connectivity_plus → Network status
- URL Launcher / Google Maps → Open location
- Permission Handler → Request runtime permissions
- UUID → Generate unique IDs
- HTTP → HTTP requests (optional, if needed)
- Geocoding / Geolocator → Convert coordinates & get device location
- Intl → Date/time formatting


## Offline & Remote Sync

1. Load appointments from local Hive database (fast UI)
2. Check internet connectivity
3. Upload pending local changes to API
4. Fetch latest remote appointments and update local storage

## Filter & Search

- Quick filters: All, Today, Upcoming, Past
- Custom date range: From – To dates
- Search by title, customer, or company
- Works offline
