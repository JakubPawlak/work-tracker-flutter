import { WorkDay, NotificationSettings } from '../types/models';

const WORK_DAYS_KEY = 'workDays';
const NOTIFICATION_SETTINGS_KEY = 'notificationSettings';

export function saveWorkDays(workDays: Record<string, WorkDay>): void {
    try {
        localStorage.setItem(WORK_DAYS_KEY, JSON.stringify(workDays));
    } catch (error) {
        console.error('Failed to save work days:', error);
    }
}

export function loadWorkDays(): Record<string, WorkDay> {
    try {
        const data = localStorage.getItem(WORK_DAYS_KEY);
        if (!data) return {};
        return JSON.parse(data);
    } catch (error) {
        console.error('Failed to load work days:', error);
        return {};
    }
}

export function saveNotificationSettings(settings: NotificationSettings): void {
    try {
        localStorage.setItem(NOTIFICATION_SETTINGS_KEY, JSON.stringify(settings));
    } catch (error) {
        console.error('Failed to save notification settings:', error);
    }
}

export function loadNotificationSettings(): NotificationSettings {
    try {
        const data = localStorage.getItem(NOTIFICATION_SETTINGS_KEY);
        if (!data) {
            return { enabled: false, hour: 18, minute: 0 };
        }
        return JSON.parse(data);
    } catch (error) {
        console.error('Failed to load notification settings:', error);
        return { enabled: false, hour: 18, minute: 0 };
    }
}
