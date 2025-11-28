# Quick Start Guide - Days Gone

## 🚀 Run the App Immediately

### Option 1: iOS Simulator (Recommended for Mac users)
```bash
# Navigate to project
cd /Users/dima/dev/days_gone

# Run on iOS
flutter run
```

Flutter will automatically:
- Open the iOS Simulator
- Build the app
- Install and launch it

### Option 2: Android Emulator
```bash
# List available emulators
flutter emulators

# Launch an emulator
flutter emulators --launch <emulator-name>

# Run the app
flutter run
```

### Option 3: Physical Device
```bash
# Connect your device via USB
# Enable Developer Mode on the device
# Run:
flutter run
```

## 📱 First Launch

When you first launch the app:

1. **Main Screen**: You'll see a calendar for the current month
2. **Select Today**: Today's date will be highlighted with an orange border
3. **Log Your Work**: Tap one of the three options:
   - 🏢 **Biuro** (Office)
   - 🏠 **Zdalnie** (Remote)
   - 🌴 **Urlop** (Day Off)
4. **View Stats**: Scroll down to see your statistics

## ⚙️ Enable Notifications

1. Tap the gear icon (⚙️) in the top left
2. Toggle "Włącz codzienne przypomnienia" to ON
3. Grant notification permissions when prompted
4. Set your preferred reminder time (default: 18:00)
5. Tap "Gotowe" to save

## 🎯 Key Features

### Calendar
- **Orange Border**: Today's date
- **Blue Border**: Selected date
- **Background Colors**:
  - Blue: Office day
  - Green: Remote day
  - Orange: Day off
  - Gray: Weekend or holiday
  
### Navigation
- **← →**: Change months
- **Dzisiaj**: Jump to today
- **Tap any date**: Select that date

### Statistics
- Shows monthly breakdown of work days
- 3-month rolling average
- Red warning if office % is below 60%

## 🔍 Troubleshooting

### App won't run?
```bash
flutter clean
flutter pub get
flutter run
```

### Build errors?
```bash
flutter doctor
# Fix any issues shown
```

### iOS Simulator not opening?
```bash
open -a Simulator
# Then run: flutter run
```

### Notifications not working?
- Check device settings for app permissions
- iOS: Settings > Days Gone > Notifications
- Android: Settings > Apps > Days Gone > Notifications

## 📊 Understanding Statistics

### Monthly Stats
- **Biuro**: Days worked from office
- **Zdalnie**: Days worked remotely  
- **Dni robocze**: Total work days (excludes weekends & holidays)
- **Urlopy**: Vacation/days off taken
- **Śr. % biuro/tydzień**: Average % of work week in office

### 3-Month Stats (3m)
Same metrics calculated over current + 2 previous months

### Warning Colors
- **Red background**: Metric needs attention
  - Office % < 60% (may not meet requirements)
  - Remote % > 40% (too much remote work)

## 🗓️ Polish Holidays

The app automatically marks these Polish holidays:
- Nowy Rok (New Year)
- Święto Trzech Króli (Epiphany)
- Święto Pracy (Labour Day)
- Święto Konstytucji 3 Maja (Constitution Day)
- Wniebowzięcie NMP (Assumption of Mary)
- Wszystkich Świętych (All Saints)
- Święto Niepodległości (Independence Day)
- Boże Narodzenie (Christmas)

Weekends and holidays are automatically excluded from work day calculations.

## 💡 Pro Tips

1. **Quick Logging**: Tap notification action buttons to log without opening app
2. **Month Review**: Use ← → to review previous months
3. **Weekly Planning**: Check "Śr. % biuro/tydzień" to plan office days
4. **Red Alerts**: If stats show red, increase office days next week

## 🎨 App Theme

- **Primary Color**: Blue (office/work)
- **Accent Colors**: 
  - Green (remote work)
  - Orange (vacation/today)
  - Purple (statistics)

## Need Help?

Check the detailed guides:
- `README.md` - Installation instructions
- `APP_GUIDE.md` - Feature details
- `MIGRATION_SUMMARY.md` - Technical details

Enjoy tracking your work! 🎉

