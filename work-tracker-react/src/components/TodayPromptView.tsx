import { WorkType, WORK_TYPE_CONFIG } from '../types/models';
import './TodayPromptView.css';

interface TodayPromptViewProps {
    onSelectWorkType: (type: WorkType) => void;
}

export function TodayPromptView({ onSelectWorkType }: TodayPromptViewProps) {
    return (
        <div className="today-prompt">
            <h2 className="today-prompt-title">Gdzie pracowałeś dzisiaj?</h2>
            <div className="today-prompt-buttons">
                <button
                    className="work-type-button work-type-office"
                    onClick={() => onSelectWorkType(WorkType.Office)}
                >
                    <span className="work-type-emoji">{WORK_TYPE_CONFIG[WorkType.Office].emoji}</span>
                    <span className="work-type-label">{WORK_TYPE_CONFIG[WorkType.Office].label}</span>
                </button>
                <button
                    className="work-type-button work-type-remote"
                    onClick={() => onSelectWorkType(WorkType.Remote)}
                >
                    <span className="work-type-emoji">{WORK_TYPE_CONFIG[WorkType.Remote].emoji}</span>
                    <span className="work-type-label">{WORK_TYPE_CONFIG[WorkType.Remote].label}</span>
                </button>
                <button
                    className="work-type-button work-type-dayoff"
                    onClick={() => onSelectWorkType(WorkType.DayOff)}
                >
                    <span className="work-type-emoji">{WORK_TYPE_CONFIG[WorkType.DayOff].emoji}</span>
                    <span className="work-type-label">{WORK_TYPE_CONFIG[WorkType.DayOff].label}</span>
                </button>
            </div>
        </div>
    );
}
