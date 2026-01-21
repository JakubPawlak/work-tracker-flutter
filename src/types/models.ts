export enum WorkType {
    Office = 'office',
    Remote = 'remote',
    DayOff = 'dayOff',
    NotSet = 'notSet'
}

export interface WorkDay {
    id: string;
    date: string; // ISO date string (YYYY-MM-DD)
    workType: WorkType;
}

export interface MonthlyStats {
    totalWorkDays: number;
    officeDays: number;
    remoteDays: number;
    daysOff: number;
    averageOfficeDaysPerWeek: number;
}

export interface NotificationSettings {
    enabled: boolean;
    hour: number;
    minute: number;
}

export const WORK_TYPE_CONFIG = {
    [WorkType.Office]: {
        label: 'Biuro',
        emoji: '🏢',
        color: '#2196F3'
    },
    [WorkType.Remote]: {
        label: 'Zdalnie',
        emoji: '🏠',
        color: '#4CAF50'
    },
    [WorkType.DayOff]: {
        label: 'Urlop',
        emoji: '🌴',
        color: '#FF9800'
    },
    [WorkType.NotSet]: {
        label: 'Nie ustawiono',
        emoji: '❓',
        color: 'transparent'
    }
} as const;
