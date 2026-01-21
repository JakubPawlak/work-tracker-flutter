import { useState } from 'react';
import { useNotifications } from '../hooks/useNotifications';
import './SettingsView.css';

interface SettingsViewProps {
    onClose: () => void;
}

export function SettingsView({ onClose }: SettingsViewProps) {
    const { settings, setNotificationsEnabled, setNotificationTime } = useNotifications();
    const [hour, setHour] = useState(settings.hour);
    const [minute, setMinute] = useState(settings.minute);

    const handleToggle = async () => {
        await setNotificationsEnabled(!settings.enabled);
    };

    const handleSave = () => {
        setNotificationTime(hour, minute);
        onClose();
    };

    return (
        <div className="settings-overlay">
            <div className="settings-container">
                <div className="settings-header">
                    <button className="back-button" onClick={onClose}>
                        ← Wróć
                    </button>
                    <h2 className="settings-title">Ustawienia</h2>
                </div>

                <div className="settings-content">
                    <div className="setting-item">
                        <div className="setting-label">
                            <span className="setting-icon">🔔</span>
                            <span>Włącz codzienne przypomnienia</span>
                        </div>
                        <label className="toggle-switch">
                            <input
                                type="checkbox"
                                checked={settings.enabled}
                                onChange={handleToggle}
                            />
                            <span className="toggle-slider"></span>
                        </label>
                    </div>

                    {settings.enabled && (
                        <div className="setting-item">
                            <div className="setting-label">
                                <span className="setting-icon">⏰</span>
                                <span>Godzina przypomnienia</span>
                            </div>
                            <div className="time-picker">
                                <input
                                    type="number"
                                    min="0"
                                    max="23"
                                    value={hour}
                                    onChange={(e) => setHour(parseInt(e.target.value))}
                                    className="time-input"
                                />
                                <span className="time-separator">:</span>
                                <input
                                    type="number"
                                    min="0"
                                    max="59"
                                    value={minute}
                                    onChange={(e) => setMinute(parseInt(e.target.value))}
                                    className="time-input"
                                />
                            </div>
                        </div>
                    )}
                </div>

                <button className="save-button" onClick={handleSave}>
                    Gotowe
                </button>
            </div>
        </div>
    );
}
