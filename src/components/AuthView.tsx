import { useAuth } from '../hooks/useAuth';
import './AuthView.css';

export function AuthView() {
    const { signInWithGoogle, error, loading } = useAuth();

    return (
        <div className="auth-container">
            <div className="auth-card">
                <div className="auth-header">
                    <div className="auth-icon">🏢</div>
                    <h1 className="auth-title">Shiftly</h1>
                    <p className="auth-subtitle">Track your work location simply and effectively</p>
                </div>

                {error && <div className="auth-error">{error}</div>}

                <button
                    className="google-signin-button"
                    onClick={signInWithGoogle}
                    disabled={loading}
                >
                    <img
                        src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg"
                        alt="Google logo"
                        className="google-icon"
                    />
                    {loading ? 'Signing in...' : 'Sign in with Google'}
                </button>

                <div className="auth-features">
                    <div className="feature-item">
                        <span className="feature-icon">☁️</span>
                        <span>Sync across all your devices</span>
                    </div>
                    <div className="feature-item">
                        <span className="feature-icon">🔒</span>
                        <span>Secure and private</span>
                    </div>
                    <div className="feature-item">
                        <span className="feature-icon">📱</span>
                        <span>Offline support</span>
                    </div>
                </div>
            </div>
        </div>
    );
}
