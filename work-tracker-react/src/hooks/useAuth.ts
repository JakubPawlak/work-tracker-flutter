import { useState, useEffect } from 'react';
import { User, signInWithPopup, signOut as firebaseSignOut } from 'firebase/auth';
import { auth, googleProvider } from '../config/firebase';

export function useAuth() {
    const [user, setUser] = useState<User | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const unsubscribe = auth.onAuthStateChanged((user) => {
            setUser(user);
            setLoading(false);
        });

        return unsubscribe;
    }, []);

    const signInWithGoogle = async () => {
        setLoading(true);
        setError(null);
        try {
            await signInWithPopup(auth, googleProvider);
        } catch (err: any) {
            console.error('Error signing in with Google', err);
            setError(err.message || 'Failed to sign in');
            setLoading(false);
        }
    };

    const signOut = async () => {
        setLoading(true);
        try {
            await firebaseSignOut(auth);
        } catch (err: any) {
            console.error('Error signing out', err);
            setError(err.message || 'Failed to sign out');
            setLoading(false);
        }
    };

    return {
        user,
        loading,
        error,
        signInWithGoogle,
        signOut
    };
}
