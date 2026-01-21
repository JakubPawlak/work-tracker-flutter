import { useAuth } from '../hooks/useAuth';
import { useNotifications } from '../hooks/useNotifications';
import './SettingsView.css';

interface SettingsViewProps {
    onClose: () => void;
}

export function SettingsView({ onClose }: SettingsViewProps) {
    const { user, signOut } = useAuth();
    const {
        settings,
        permission,
        setNotificationsEnabled,
        setNotificationTime,
        requestPermission
    } = useNotifications();

    const handleTimeChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const [hours, minutes] = e.target.value.split(':').map(Number);
        setNotificationTime(hours, minutes);
    };

    const handleToggleNotifications = async (e: React.ChangeEvent<HTMLInputElement>) => {
        if (e.target.checked && permission !== 'granted') {
            const granted = await requestPermission();
            if (!granted) return;
        }
        setNotificationsEnabled(e.target.checked);
    };

    const timeString = `${settings.hour.toString().padStart(2, '0')}:${settings.minute.toString().padStart(2, '0')}`;

    return (
        <div className="settings-overlay" onClick={onClose}>
            <div className="settings-card" onClick={e => e.stopPropagation()}>
                <div className="settings-header">
                    <h2>Ustawienia</h2>
                    <button className="close-button" onClick={onClose}>×</button>
                </div>

                <div className="settings-section">
                    <h3>Konto</h3>
                    <div className="account-info">
                        <div className="user-profile">
                            {user?.photoURL ? (
                                <img src={user.photoURL} alt="Profile" className="settings-avatar" />
                            ) : (
                                <div className="settings-avatar-placeholder">
                                    {user?.email?.charAt(0).toUpperCase()}
                                </div>
                            )}
                            <div className="user-details">
                                <div className="user-name">{user?.displayName || 'Użytkownik'}</div>
                                <div className="user-email">{user?.email}</div>
                            </div>
                        </div>
                        <button className="sign-out-button" onClick={() => {
                            signOut();
                            onClose();
                        }}>
                            Wyloguj się
                        </button>
                    </div>
                </div>

                <div className="settings-section">
                    <h3>Powiadomienia</h3>

                    <div className="setting-row">
                        <div className="setting-label">
                            <span>Włącz powiadomienia</span>
                            {permission === 'denied' && (
                                <span className="permission-warning">
                                    (Zablokowane w ustawieniach przeglądarki)
                                </span>
                            )}
                        </div>
                        <label className="switch">
                            <input
                                type="checkbox"
                                checked={settings.enabled}
                                onChange={handleToggleNotifications}
                                disabled={permission === 'denied'}
                            />
                            <span className="slider round"></span>
                        </label>
                    </div>

                    <div className="setting-row">
                        <span>Czas przypomnienia</span>
                        <input
                            type="time"
                            value={timeString}
                            onChange={handleTimeChange}
                            disabled={!settings.enabled}
                            className="time-picker"
                        />
                    </div>
                </div>

                <div className="settings-footer">
                    <p>Dla pewności działania na iOS, dodaj aplikację do ekranu głównego.</p>
                </div>
            </div>
        </div>
    );
}
