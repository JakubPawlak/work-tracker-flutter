# Days Gone - Work Tracker App

A Flutter work tracking application that helps you monitor where you work (office, remote, or day off). This is a Flutter port of the iOS "Be selfish" app.

## Features

- 📅 **Monthly Calendar View** - Visual calendar showing your work locations
- 📊 **Statistics** - Monthly and 3-month work statistics
- 🔔 **Daily Notifications** - Customizable reminders to log your work location
- 🇵🇱 **Polish Holidays** - Automatic detection of Polish public holidays
- 💾 **Data Persistence** - All data is saved locally using SharedPreferences
- 📱 **Cross-Platform** - Works on iOS and Android

## Work Types

- 🏢 **Office** (Biuro) - Working from the office
- 🏠 **Remote** (Zdalnie) - Working remotely
- 🌴 **Day Off** (Urlop) - Vacation/day off

## Getting Started


### Running on iOS Simulator

To run this Flutter project on an iOS simulator, follow these steps:

#### 1. Install Xcode
- Download and install Xcode from the [App Store](https://apps.apple.com/us/app/xcode/id497799835?mt=12) or [Apple Developer website](https://developer.apple.com/xcode/)
- Once installed, run the following commands:
  ```bash
  sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
  sudo xcodebuild -runFirstLaunch
  ```

#### 2. Install CocoaPods
CocoaPods is required for managing iOS dependencies:
```bash
sudo gem install cocoapods
```

#### 3. Accept Xcode License
```bash
sudo xcodebuild -license accept
```

#### 4. Install Flutter Dependencies
```bash
flutter pub get
```

#### 5. Launch iOS Simulator and Run
Option A - Let Flutter open the simulator automatically:
```bash
flutter run
```

Option B - Open a specific simulator first:
```bash
# List available simulators
flutter emulators

# Launch a specific simulator (e.g., iPhone 15)
flutter emulators --launch apple_ios_simulator

# Then run the app
flutter run
```

Option C - Run on a specific device:
```bash
# List all connected devices
flutter devices

# Run on a specific device
flutter run -d <device-id>
```

### Current Setup Status
Run `flutter doctor` to check your development environment setup:
```bash
flutter doctor
```

This will show you what's configured and what still needs to be set up.

### Additional Resources

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter iOS Setup](https://docs.flutter.dev/get-started/install/macos/mobile-ios)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
