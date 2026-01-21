import { MonthlyStats } from '../types/models';
import './MonthlyStatsView.css';

interface MonthlyStatsViewProps {
    stats: MonthlyStats;
    threeMonthStats: MonthlyStats;
}

export function MonthlyStatsView({ stats, threeMonthStats }: MonthlyStatsViewProps) {
    const getOfficePercentage = (s: MonthlyStats) => {
        if (s.totalWorkDays === 0) return 0;
        return Math.round((s.officeDays / s.totalWorkDays) * 100);
    };

    const getRemotePercentage = (s: MonthlyStats) => {
        if (s.totalWorkDays === 0) return 0;
        return Math.round((s.remoteDays / s.totalWorkDays) * 100);
    };

    const shouldWarnOffice = (percentage: number) => percentage < 60;
    const shouldWarnRemote = (percentage: number) => percentage > 40;

    const renderStatsCard = (title: string, s: MonthlyStats) => {
        const officePercentage = getOfficePercentage(s);
        const remotePercentage = getRemotePercentage(s);
        const avgOfficePerWeek = Math.round(s.averageOfficeDaysPerWeek);

        return (
            <div className="stats-card">
                <h3 className="stats-title">{title}</h3>
                <div className="stats-grid">
                    <div className={`stat-item ${shouldWarnOffice(officePercentage) ? 'warn' : ''}`}>
                        <span className="stat-label">🏢 Biuro</span>
                        <span className="stat-value">{s.officeDays} dni ({officePercentage}%)</span>
                    </div>
                    <div className={`stat-item ${shouldWarnRemote(remotePercentage) ? 'warn' : ''}`}>
                        <span className="stat-label">🏠 Zdalnie</span>
                        <span className="stat-value">{s.remoteDays} dni ({remotePercentage}%)</span>
                    </div>
                    <div className="stat-item">
                        <span className="stat-label">💼 Dni robocze</span>
                        <span className="stat-value">{s.totalWorkDays}</span>
                    </div>
                    <div className="stat-item">
                        <span className="stat-label">🌴 Urlopy</span>
                        <span className="stat-value">{s.daysOff}</span>
                    </div>
                    <div className={`stat-item full-width ${shouldWarnOffice(avgOfficePerWeek) ? 'warn' : ''}`}>
                        <span className="stat-label">📊 Śr. % biuro/tydzień</span>
                        <span className="stat-value">{avgOfficePerWeek}%</span>
                    </div>
                </div>
            </div>
        );
    };

    return (
        <div className="monthly-stats">
            {renderStatsCard('Statystyki miesięczne', stats)}
            {renderStatsCard('Statystyki 3-miesięczne (3m)', threeMonthStats)}
        </div>
    );
}
