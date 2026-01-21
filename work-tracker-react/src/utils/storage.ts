import { NotificationSettings } from '../types/models';

const NOTIFICATIONS_KEY = 'notifications';

// localStorage wrapper for WorkDay (Legacy - now utilizing Firestore)
/* 
export const saveWorkDays = (workDays: Record<string, WorkDay>): void => {
    try {
        const json = JSON.stringify(workDays);
        localStorage.setItem(WORK_DAYS_KEY, json);
    } catch (e) {
        console.error('Failed to save work days', e);
    }
};

export const loadWorkDays = (): Record<string, WorkDay> => {
    try {
        const json = localStorage.getItem(WORK_DAYS_KEY);
        if (!json) return {};
        return JSON.parse(json);
    } catch (e) {
        console.error('Failed to load work days', e);
        return {};
    }
};
*/

// localStorage wrapper for NotificationSettings
export const saveNotificationSettings = (settings: NotificationSettings): void => {
    try {
        const json = JSON.stringify(settings);
        localStorage.setItem(NOTIFICATIONS_KEY, json);
    } catch (e) {
        console.error('Failed to save notification settings', e);
    }
};

export const loadNotificationSettings = (): NotificationSettings => {
    try {
        const json = localStorage.getItem(NOTIFICATIONS_KEY);
        if (!json) {
            return {
                enabled: false,
                hour: 18,
                minute: 0
            };
        }
        return JSON.parse(json);
    } catch (e) {
        console.error('Failed to load notification settings', e);
        return {
            enabled: false,
            hour: 18,
            minute: 0
        };
    }
};
