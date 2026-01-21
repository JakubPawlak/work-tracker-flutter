import { startOfMonth, endOfMonth, eachDayOfInterval, isSameDay } from 'date-fns';
import { WorkType } from '../types/models';
import { isHoliday, isWeekend } from '../utils/polishHolidays';
import './CalendarView.css';

interface DayCellProps {
    date: Date;
    workType: WorkType;
    isSelected: boolean;
    isToday: boolean;
    onSelect: () => void;
}

function DayCell({ date, workType, isSelected, isToday, onSelect }: DayCellProps) {
    const weekend = isWeekend(date);
    const holiday = isHoliday(date);

    const getBackgroundClass = () => {
        if (weekend || holiday) return 'day-cell-weekend';
        switch (workType) {
            case WorkType.Office: return 'day-cell-office';
            case WorkType.Remote: return 'day-cell-remote';
            case WorkType.DayOff: return 'day-cell-dayoff';
            default: return '';
        }
    };

    const getBorderClass = () => {
        if (isSelected) return 'day-cell-selected';
        if (isToday) return 'day-cell-today';
        return '';
    };

    const getEmoji = () => {
        switch (workType) {
            case WorkType.Office: return '🏢';
            case WorkType.Remote: return '🏠';
            case WorkType.DayOff: return '🌴';
            default: return '';
        }
    };

    return (
        <button
            className={`day-cell ${getBackgroundClass()} ${getBorderClass()}`}
            onClick={onSelect}
        >
            <div className="day-number">{date.getDate()}</div>
            <div className="day-emoji">{getEmoji()}</div>
        </button>
    );
}

interface CalendarViewProps {
    selectedDate: Date;
    currentMonth: Date;
    onDateSelected: (date: Date) => void;
    getWorkType: (date: Date) => WorkType;
}

export function CalendarView({ selectedDate, currentMonth, onDateSelected, getWorkType }: CalendarViewProps) {
    const daysOfWeek = ['Pn', 'Wt', 'Śr', 'Cz', 'Pt', 'Sb', 'Nd'];

    const getDaysInMonth = () => {
        const start = startOfMonth(currentMonth);
        const end = endOfMonth(currentMonth);
        const days = eachDayOfInterval({ start, end });

        // Get the first day of the month and calculate offset for Monday start
        const firstDayWeekday = start.getDay();
        const offset = firstDayWeekday === 0 ? 6 : firstDayWeekday - 1; // Monday = 0

        // Add empty cells for days before month starts
        const emptyDays = Array(offset).fill(null);

        return [...emptyDays, ...days];
    };

    const allDays = getDaysInMonth();

    return (
        <div className="calendar-view">
            <div className="calendar-header">
                {daysOfWeek.map(day => (
                    <div key={day} className="calendar-header-day">{day}</div>
                ))}
            </div>
            <div className="calendar-grid">
                {allDays.map((day, index) => {
                    if (day === null) {
                        return <div key={`empty-${index}`} className="day-cell-empty" />;
                    }
                    return (
                        <DayCell
                            key={day.toISOString()}
                            date={day}
                            workType={getWorkType(day)}
                            isSelected={isSameDay(day, selectedDate)}
                            isToday={isSameDay(day, new Date())}
                            onSelect={() => onDateSelected(day)}
                        />
                    );
                })}
            </div>
        </div>
    );
}
