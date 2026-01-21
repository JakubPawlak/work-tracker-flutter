import { useState, useEffect, useCallback } from 'react';
import { NotificationSettings } from '../types/models';
import { saveNotificationSettings, loadNotificationSettings } from '../utils/storage';

export function useNotifications() {
    const [settings, setSettings] = useState<NotificationSettings>({
        enabled: false,
        hour: 18,
        minute: 0
    });
    const [permission, setPermission] = useState<NotificationPermission>('default');

    useEffect(() => {
        const loaded = loadNotificationSettings();
        setSettings(loaded);

        if ('Notification' in window) {
            setPermission(Notification.permission);
        }
    }, []);

    const requestPermission = useCallback(async (): Promise<boolean> => {
        if (!('Notification' in window)) {
            console.warn('This browser does not support notifications');
            return false;
        }

        try {
            const result = await Notification.requestPermission();
            setPermission(result);
            return result === 'granted';
        } catch (error) {
            console.error('Failed to request notification permission:', error);
            return false;
        }
    }, []);

    const setNotificationsEnabled = useCallback(async (enabled: boolean) => {
        if (enabled) {
            const granted = await requestPermission();
            if (!granted) {
                return;
            }
        }

        const newSettings = { ...settings, enabled };
        setSettings(newSettings);
        saveNotificationSettings(newSettings);

        if (enabled) {
            scheduleNotification(newSettings);
        }
    }, [settings, requestPermission]);

    const setNotificationTime = useCallback((hour: number, minute: number) => {
        const newSettings = { ...settings, hour, minute };
        setSettings(newSettings);
        saveNotificationSettings(newSettings);

        if (settings.enabled) {
            scheduleNotification(newSettings);
        }
    }, [settings]);

    const scheduleNotification = useCallback((notifSettings: NotificationSettings) => {
        if (!('Notification' in window) || Notification.permission !== 'granted') {
            return;
        }

        // Calculate time until next notification
        const now = new Date();
        const scheduledTime = new Date();
        scheduledTime.setHours(notifSettings.hour, notifSettings.minute, 0, 0);

        // If the time has passed today, schedule for tomorrow
        if (scheduledTime <= now) {
            scheduledTime.setDate(scheduledTime.getDate() + 1);
        }

        const timeUntilNotification = scheduledTime.getTime() - now.getTime();

        // Schedule the notification
        setTimeout(() => {
            if (Notification.permission === 'granted') {
                new Notification('Be selfish', {
                    body: 'Czy pracowałeś dzisiaj w biurze?',
                    icon: '/icon-192.png',
                    badge: '/icon-192.png',
                    tag: 'daily-work-reminder',
                    requireInteraction: false
                });

                // Schedule next day's notification
                scheduleNotification(notifSettings);
            }
        }, timeUntilNotification);
    }, []);

    return {
        settings,
        permission,
        setNotificationsEnabled,
        setNotificationTime,
        requestPermission
    };
}
