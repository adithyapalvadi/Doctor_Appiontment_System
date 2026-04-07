import { supabase } from './supabase-config.js';

// Global Utility Functions
export const AppUtils = {
    showToast(message, type = 'info') {
        const toastContainer = document.getElementById('toast-container') || this.createToastContainer();
        
        const toast = document.createElement('div');
        toast.className = `toast toast-${type} glass-panel slide-in`;
        toast.innerHTML = `
            <div class="toast-content">
                <span class="toast-icon">${type === 'success' ? '✓' : type === 'error' ? '⚠' : 'ℹ'}</span>
                <span class="toast-message">${message}</span>
            </div>
            <button class="toast-close">&times;</button>
        `;
        
        toast.querySelector('.toast-close').addEventListener('click', () => {
            toast.style.animation = 'slideOut 0.3s ease forwards';
            setTimeout(() => toast.remove(), 300);
        });

        toastContainer.appendChild(toast);

        setTimeout(() => {
            if (toast.parentElement) {
                toast.style.animation = 'slideOut 0.3s ease forwards';
                setTimeout(() => toast.remove(), 300);
            }
        }, 4000);
    },

    createToastContainer() {
        const container = document.createElement('div');
        container.id = 'toast-container';
        document.body.appendChild(container);
        return container;
    },

    showLoading(text = 'Loading...') {
        let loader = document.getElementById('global-loader');
        if (!loader) {
            loader = document.createElement('div');
            loader.id = 'global-loader';
            loader.className = 'glass-overlay fade-in';
            loader.innerHTML = `
                <div class="spinner"></div>
                <p id="loader-text">${text}</p>
            `;
            document.body.appendChild(loader);
        } else {
            document.getElementById('loader-text').textContent = text;
            loader.classList.remove('hidden');
        }
    },

    hideLoading() {
        const loader = document.getElementById('global-loader');
        if (loader) loader.classList.add('hidden');
    },

    formatDate(dateString) {
        if (!dateString) return 'N/A';
        return new Date(dateString).toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' });
    },

    formatTime(timeString) {
        if (!timeString) return 'N/A';
        const [hour, minute] = timeString.split(':');
        const d = new Date();
        d.setHours(hour, minute);
        return d.toLocaleTimeString(undefined, { hour: 'numeric', minute: '2-digit' });
    }
};

// Auth initialization promise - created IMMEDIATELY so it's always available
let _authReadyResolve;
const _authReady = new Promise(resolve => { _authReadyResolve = resolve; });

// Global Authentication State Management
export const AuthManager = {
    currentUser: null,
    userProfile: null,

    // Returns a promise that resolves when auth is fully initialized
    waitForAuth() {
        return _authReady;
    },

    async initAuth() {
        try {
            const { data: { session } } = await supabase.auth.getSession();
            if (session) {
                await this.handleUserSignIn(session.user);
            } else {
                this.handleUserSignOut();
            }
        } catch (err) {
            console.error("Auth init error:", err);
            this.handleUserSignOut();
        }

        // Mark auth as ready
        _authReadyResolve();

        // Listen for future auth changes
        supabase.auth.onAuthStateChange(async (event, session) => {
            if (event === 'SIGNED_IN' && session) {
                await this.handleUserSignIn(session.user);
            } else if (event === 'SIGNED_OUT') {
                this.handleUserSignOut();
            }
        });
    },

    async handleUserSignIn(user) {
        this.currentUser = user;
        
        const { data, error } = await supabase
            .from('users')
            .select('*')
            .eq('id', user.id)
            .single();
            
        if (error) {
            console.error("Error fetching user profile:", error);
            return;
        }

        this.userProfile = data;
        window.dispatchEvent(new CustomEvent('authStateChanged', { detail: { user: this.userProfile } }));
        this.updateAuthUI();
    },

    handleUserSignOut() {
        this.currentUser = null;
        this.userProfile = null;
        window.dispatchEvent(new CustomEvent('authStateChanged', { detail: { user: null } }));
        this.updateAuthUI();
    },

    async logout() {
        AppUtils.showLoading("Signing out...");
        const { error } = await supabase.auth.signOut();
        AppUtils.hideLoading();
        if (error) {
            AppUtils.showToast(error.message, 'error');
        } else {
            AppUtils.showToast("Logged out successfully.", "success");
            window.location.href = 'index.html';
        }
    },

    updateAuthUI() {
        const authButtons = document.querySelectorAll('.auth-btn-group');
        const userMenu = document.querySelectorAll('.user-menu');
        const userMenuName = document.querySelectorAll('.user-menu-name');

        if (this.userProfile) {
            authButtons.forEach(el => el.style.display = 'none');
            userMenu.forEach(el => el.style.display = 'flex');
            userMenuName.forEach(el => el.textContent = `Hi, ${this.userProfile.name}`);
        } else {
            authButtons.forEach(el => el.style.display = 'flex');
            userMenu.forEach(el => el.style.display = 'none');
            userMenuName.forEach(el => el.textContent = '');
        }
    },

    // Route guard — always waits for auth to fully resolve first
    async requireAuth(allowedRoles = []) {
        await _authReady; // This is always available, no race condition

        if (!this.userProfile) {
            AppUtils.showToast("Please log in to access this page.", "warning");
            setTimeout(() => window.location.href = 'auth.html', 1500);
            return false;
        }
        if (allowedRoles.length > 0 && !allowedRoles.includes(this.userProfile.role)) {
            AppUtils.showToast("Access Denied.", "error");
            setTimeout(() => window.location.href = 'index.html', 1500);
            return false;
        }
        return true;
    }
};

// Expose to window for global inline clicks
window.logout = () => AuthManager.logout();

// Initialize auth immediately when this module loads
AuthManager.initAuth();
