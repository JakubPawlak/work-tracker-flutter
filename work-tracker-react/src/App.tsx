import { useState } from 'react';
import { format, isSameDay } from 'date-fns';
import { pl } from 'date-fns/locale';
import { useWorkData } from './hooks/useWorkData';
import { CalendarView } from './components/CalendarView';
import { TodayPromptView } from './components/TodayPromptView';
import { DayControlView } from './components/DayControlView';
import { MonthlyStatsView } from './components/MonthlyStatsView';
import { SettingsView } from './components/SettingsView';
import { WorkType } from './types/models';
import { isHoliday, isWeekend } from './utils/polishHolidays';
import './App.css';

function App() {
    const [selectedDate, setSelectedDate] = useState(new Date());
    const [currentMonth, setCurrentMonth] = useState(new Date());
    const [showSettings, setShowSettings] = useState(false);

    const { getWorkType, setWorkType, getMonthlyStats, getThreeMonthStats } = useWorkData();

    const handlePreviousMonth = () => {
        setCurrentMonth(new Date(currentMonth.getFullYear(), currentMonth.getMonth() - 1, 1));
    };

    const handleNextMonth = () => {
        setCurrentMonth(new Date(currentMonth.getFullYear(), currentMonth.getMonth() + 1, 1));
    };

    const handleToday = () => {
        const today = new Date();
        setSelectedDate(today);
        setCurrentMonth(today);
    };

    const handleSelectWorkType = (type: WorkType) => {
        setWorkType(selectedDate, type);
    };

    const isToday = isSameDay(selectedDate, new Date());
    const isSelectedWeekend = isWeekend(selectedDate);
    const isSelectedHoliday = isHoliday(selectedDate);
    const isWorkday = !isSelectedWeekend && !isSelectedHoliday;

    const monthYearString = format(currentMonth, 'LLLL yyyy', { locale: pl });
    const capitalizedMonth = monthYearString.charAt(0).toUpperCase() + monthYearString.slice(1);

    const monthlyStats = getMonthlyStats(currentMonth);
    const threeMonthStats = getThreeMonthStats(currentMonth);

    return (
        <div className="app">
            <header className="app-header">
                <button className="settings-icon" onClick={() => setShowSettings(true)}>
                    ⚙️
                </button>
                <h1 className="app-title">Be selfish</h1>
                <button className="today-button" onClick={handleToday}>
                    Dzisiaj
                </button>
            </header>

            <main className="app-content">
                <div className="month-navigation">
                    <button className="nav-button" onClick={handlePreviousMonth}>
                        ←
                    </button>
                    <h2 className="month-title">{capitalizedMonth}</h2>
                    <button className="nav-button" onClick={handleNextMonth}>
                        →
                    </button>
                </div>

                <CalendarView
                    selectedDate={selectedDate}
                    currentMonth={currentMonth}
                    onDateSelected={setSelectedDate}
                    getWorkType={getWorkType}
                />

                {isToday && isWorkday && (
                    <TodayPromptView onSelectWorkType={handleSelectWorkType} />
                )}

                {(!isToday || !isWorkday) && (
                    <DayControlView
                        date={selectedDate}
                        workType={getWorkType(selectedDate)}
                        isWeekend={isSelectedWeekend}
                        isHoliday={isSelectedHoliday}
                        onSelectWorkType={handleSelectWorkType}
                    />
                )}

                <MonthlyStatsView
                    stats={monthlyStats}
                    threeMonthStats={threeMonthStats}
                />
            </main>

            {showSettings && <SettingsView onClose={() => setShowSettings(false)} />}
        </div>
    );
}

export default App;
