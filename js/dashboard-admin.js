import { supabase } from './supabase-config.js';
import { AuthManager, AppUtils } from './app.js';

document.addEventListener('DOMContentLoaded', async () => {
    const allowed = await AuthManager.requireAuth(['admin']);
    if (!allowed) return;

    window.addEventListener('authStateChanged', async (e) => {
        if (e.detail.user && e.detail.user.role === 'admin') {
            await loadAnalytics();
        }
    });

    window.switchTab = (tabId) => {
        // Just mock placeholder for now, since we only built analytics view
        document.querySelectorAll('.sidebar-link').forEach(el => el.classList.remove('active'));
        event.target.classList.add('active');
    };
});

async function loadAnalytics() {
    AppUtils.showLoading("Loading data...");

    // Parallel fetches for counts
    const [
        { count: patientCount },
        { count: doctorCount },
        { count: apptCount }
    ] = await Promise.all([
        supabase.from('users').select('*', { count: 'exact', head: true }).eq('role', 'patient'),
        supabase.from('doctors').select('*', { count: 'exact', head: true }),
        supabase.from('appointments').select('*', { count: 'exact', head: true })
    ]);

    AppUtils.hideLoading();

    document.getElementById('stat-patients').textContent = patientCount || 0;
    document.getElementById('stat-doctors').textContent = doctorCount || 0;
    document.getElementById('stat-appointments').textContent = apptCount || 0;
}
