# Days Gone - React PWA

A Progressive Web App (PWA) for tracking your work location: office, remote, or day off. This is a React port of the Flutter "Days Gone" work tracker application.

## Features

- 📅 **Monthly Calendar View** - Visual calendar with Polish day names
- 📊 **Statistics** - Monthly and 3-month work statistics with warnings
- 🔔 **Daily Notifications** - Customizable reminders via Web Notifications API
- 🇵🇱 **Polish Holidays** - Automatic detection of Polish public holidays
- 💾 **Data Persistence** - All data saved locally using localStorage
- 📱 **PWA Ready** - Installable on desktop and mobile devices
- 🌐 **Cross-Platform** - Works on any device with a modern browser

## Work Types

- 🏢 **Office** (Biuro) - Working from the office
- 🏠 **Remote** (Zdalnie) - Working remotely
- 🌴 **Day Off** (Urlop) - Vacation/day off

## Quick Start

### Prerequisites

- Node.js 18+ and npm

### Installation

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

### Access the App

Development: `http://localhost:5173`

## Usage

1. **Select a Date**: Click on any date in the calendar
2. **Log Work Type**: Choose Office (🏢), Remote (🏠), or Day Off (🌴)
3. **View Statistics**: Scroll down to see monthly and 3-month statistics
4. **Enable Notifications**: Click settings icon (⚙️) and toggle notifications
5. **Navigate Months**: Use left/right arrows to change months
6. **Go to Today**: Click "Dzisiaj" button in the top right

## Statistics Explained

### Monthly Stats
- **Biuro (Office)**: Number of office days and percentage
- **Zdalnie (Remote)**: Number of remote days and percentage
- **Dni robocze (Work Days)**: Total work days (office + remote)
- **Urlopy (Vacations)**: Number of vacation days
- **Śr. % biuro/tydzień**: Average office percentage per week

### Warning Indicators
- Red background appears when:
  - Office percentage is below 60%
  - Remote percentage is above 40%

## Polish Holidays

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

## PWA Installation

### Desktop
1. Open the app in Chrome or Edge
2. Click the install icon in the address bar
3. Click "Install" in the prompt

### Mobile
1. Open the app in your mobile browser
2. Tap the browser menu
3. Select "Add to Home Screen"
4. Confirm installation

The app will run in standalone mode like a native app.

## Technology Stack

- **React 18** - UI framework
- **TypeScript** - Type safety
- **Vite** - Build tool and dev server
- **date-fns** - Date manipulation with Polish locale
- **vite-plugin-pwa** - PWA manifest and service worker
- **Vanilla CSS** - Custom styling with CSS variables

## Project Structure

```
src/
├── components/          # React UI components
│   ├── CalendarView.tsx
│   ├── DayControlView.tsx
│   ├── TodayPromptView.tsx
│   ├── MonthlyStatsView.tsx
│   └── SettingsView.tsx
├── hooks/               # Custom React hooks
│   ├── useWorkData.ts
│   └── useNotifications.ts
├── types/               # TypeScript definitions
│   └── models.ts
├── utils/               # Utility functions
│   ├── polishHolidays.ts
│   └── storage.ts
├── App.tsx              # Main application
└── main.tsx             # Entry point
```

## Browser Support

- Chrome/Edge 90+
- Firefox 88+
- Safari 14+
- Mobile browsers (iOS Safari, Chrome Android)

## Known Limitations

- Web notifications have browser limitations (see below)
- No cloud sync (data stored locally only)
- Easter-based holidays not yet implemented

### Web Notifications Limitations

- Only work when browser is open or recently used
- Safari on iOS has limited notification support
- Background notifications less reliable than native apps
- User must grant explicit permission

## Deployment

Build the app for production:

```bash
npm run build
```

The `dist/` folder can be deployed to:
- Vercel
- Netlify
- GitHub Pages
- Any static hosting service

## Development

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build

### Code Style

- TypeScript strict mode enabled
- ESLint for code quality
- Prettier for code formatting (recommended)

## Future Enhancements

- [ ] Easter calculation for movable holidays
- [ ] Cloud sync with Firebase
- [ ] Data export/import functionality
- [ ] Charts and graphs for statistics
- [ ] Dark mode support
- [ ] Multiple language support
- [ ] Keyboard shortcuts

## License

This project is a React port of the Flutter "Days Gone" application.

## Support

For issues or questions, please refer to the walkthrough documentation in the project.

---

Enjoy tracking your work! 🎉
