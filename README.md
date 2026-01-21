# Days Gone - React PWA (Firebase Edition)

A Progressive Web App (PWA) for tracking your work location, now with cross-device sync powered by Firebase!

## Features

- 🔄 **Cross-Device Sync** - Access your data on any device via Google Sign-In
- 📅 **Monthly Calendar View** - Visual calendar with Polish day names
- 📊 **Statistics** - Monthly and 3-month work statistics
- 🔔 **Daily Notifications** - Customizable reminders
- 💾 **Offline Support** - Works offline and syncs when back online
- 🇵🇱 **Polish Holidays** - Automatic detection of Polish public holidays
- 📱 **PWA Ready** - Installable on desktop and mobile

## Firebase Setup

This project requires a Firebase project.

1. Create a project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Authentication** (Google Sign-In provider)
3. Enable **Cloud Firestore**
4. Copy your web app configuration
5. Update `src/config/firebase.ts` with your config keys

### Security Rules

Deploy these rules to Firestore to secure user data:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/workDays/{workDayId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Quick Start

```bash
# Install dependencies
npm install

# Start development server
npm run dev
```

## Work Types

- 🏢 **Office** (Biuro)
- 🏠 **Remote** (Zdalnie)
- 🌴 **Day Off** (Urlop)

## Technology Stack

- **React 18** + **TypeScript**
- **Firebase** (Auth, Firestore)
- **Vite** + **PWA Plugin**
- **date-fns**
