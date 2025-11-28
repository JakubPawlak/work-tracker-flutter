# Days Gone - Flutter Implementation Guide

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── managers/
│   ├── work_data_manager.dart        # Manages work day data
│   └── notification_manager.dart     # Handles local notifications
├── models/
│   ├── work_day.dart                 # Work day model
│   └── monthly_stats.dart            # Statistics model
├── screens/
│   ├── content_view.dart             # Main screen
│   └── settings_view.dart            # Settings screen
├── widgets/
│   ├── calendar_view.dart            # Calendar widget
│   ├── day_control_view.dart         # Day selection controls
│   ├── today_prompt_view.dart        # Today's work prompt
│   └── monthly_stats_view.dart       # Statistics display
└── utils/
    └── polish_holidays.dart          # Polish holiday detection
```

## Key Differences from iOS App

1. **State Management**: Uses `ChangeNotifier` instead of SwiftUI's `@ObservedObject`
2. **Data Persistence**: Uses `SharedPreferences` instead of `UserDefaults` and iCloud
3. **Notifications**: Uses `flutter_local_notifications` instead of `UNUserNotificationCenter`
4. **Localization**: Uses `intl` package for Polish date formatting

## Features Implemented

✅ Monthly calendar view with work type indicators
✅ Daily work type selection (Office, Remote, Day Off)
✅ Monthly statistics (office days, remote days, vacations)
✅ 3-month rolling statistics
✅ Average office days per week calculation
✅ Polish holiday detection
✅ Weekend detection
✅ Daily notification reminders
✅ Customizable notification time
✅ Settings screen
✅ Data persistence across app restarts

## How to Use

1. **Select a Date**: Tap on any date in the calendar
2. **Set Work Type**: Choose Office (🏢), Remote (🏠), or Day Off (🌴)
3. **View Statistics**: Scroll down to see monthly and 3-month statistics
4. **Enable Notifications**: Go to Settings and enable daily reminders
5. **Navigate Months**: Use left/right arrows to change months
6. **Go to Today**: Tap "Dzisiaj" button in the top right

## Statistics Explained

### Monthly Stats
- **Biuro (Office)**: Number of office days and percentage
- **Zdalnie (Remote)**: Number of remote days and percentage
- **Dni robocze (Work Days)**: Total work days (office + remote)
- **Urlopy (Vacations)**: Number of vacation days
- **Śr. % biuro/tydzień**: Average office percentage per week

### 3-Month Stats
Shows the same metrics but calculated over the current month and 2 previous months.

### Warning Indicators
- Red background appears when:
  - Office percentage is below 60%
  - Remote percentage is above 40%

## Dependencies

- `shared_preferences: ^2.3.3` - Local data storage
- `flutter_local_notifications: ^18.0.1` - Push notifications
- `intl: ^0.19.0` - Date formatting and localization
- `timezone: ^0.9.4` - Timezone support for notifications

## Testing on iOS Simulator

1. Ensure Xcode is installed
2. Open iOS Simulator
3. Run: `flutter run`
4. Grant notification permissions when prompted

## Testing on Android Emulator

1. Ensure Android Studio is installed
2. Start an Android emulator
3. Run: `flutter run`
4. Grant notification permissions when prompted

## Known Limitations

- Easter-based holidays (Easter Monday, Corpus Christi) are not yet implemented
- iCloud sync is not available (iOS app feature)
- Notification actions on iOS don't work the same way as on Android

## Future Enhancements

- [ ] Add Easter calculation for movable holidays
- [ ] Implement cloud sync (Firebase)
- [ ] Add export/import functionality
- [ ] Add widgets for home screen
- [ ] Add dark mode support
- [ ] Add multiple language support
- [ ] Add charts and graphs for statistics

