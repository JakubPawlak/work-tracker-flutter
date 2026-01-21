import { format } from 'date-fns';
import { pl } from 'date-fns/locale';
import { WorkType, WORK_TYPE_CONFIG } from '../types/models';
import { getHolidayName } from '../utils/polishHolidays';
import './DayControlView.css';

interface DayControlViewProps {
    date: Date;
    workType: WorkType;
    isWeekend: boolean;
    isHoliday: boolean;
    onSelectWorkType: (type: WorkType) => void;
}

export function DayControlView({ date, workType, isWeekend, isHoliday, onSelectWorkType }: DayControlViewProps) {
    const dateString = format(date, 'd MMMM yyyy', { locale: pl });
    const holidayName = getHolidayName(date);

    return (
        <div className="day-control">
            <h3 className="day-control-date">{dateString}</h3>

            {isWeekend && (
                <div className="day-control-info weekend-info">
                    <span className="info-emoji">🏖️</span>
                    <span>Weekend</span>
                </div>
            )}

            {isHoliday && holidayName && (
                <div className="day-control-info holiday-info">
                    <span className="info-emoji">🎉</span>
                    <span>{holidayName}</span>
                </div>
            )}

            {!isWeekend && !isHoliday && (
                <div className="day-control-buttons">
                    <button
                        className={`day-control-button ${workType === WorkType.Office ? 'active office' : ''}`}
                        onClick={() => onSelectWorkType(WorkType.Office)}
                    >
                        <span className="button-emoji">{WORK_TYPE_CONFIG[WorkType.Office].emoji}</span>
                        <span>{WORK_TYPE_CONFIG[WorkType.Office].label}</span>
                    </button>
                    <button
                        className={`day-control-button ${workType === WorkType.Remote ? 'active remote' : ''}`}
                        onClick={() => onSelectWorkType(WorkType.Remote)}
                    >
                        <span className="button-emoji">{WORK_TYPE_CONFIG[WorkType.Remote].emoji}</span>
                        <span>{WORK_TYPE_CONFIG[WorkType.Remote].label}</span>
                    </button>
                    <button
                        className={`day-control-button ${workType === WorkType.DayOff ? 'active dayoff' : ''}`}
                        onClick={() => onSelectWorkType(WorkType.DayOff)}
                    >
                        <span className="button-emoji">{WORK_TYPE_CONFIG[WorkType.DayOff].emoji}</span>
                        <span>{WORK_TYPE_CONFIG[WorkType.DayOff].label}</span>
                    </button>
                </div>
            )}
        </div>
    );
}
