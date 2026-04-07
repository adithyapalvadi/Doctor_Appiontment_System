import { supabase } from './supabase-config.js';
import { AuthManager, AppUtils } from './app.js';

let allAppointments = [];

document.addEventListener('DOMContentLoaded', async () => {
    await AuthManager.waitForAuth();

    if (!AuthManager.userProfile || AuthManager.userProfile.role !== 'doctor') {
        AppUtils.showToast("Please log in as a doctor.", "warning");
        setTimeout(() => window.location.href = 'auth.html', 1500);
        return;
    }

    await fetchAppointments();
    window.switchTab('requests');
});

async function fetchAppointments() {
    AppUtils.showLoading("Loading schedule...");

    const { data, error } = await supabase
        .from('appointments')
        .select('*, users(name, email)')
        .order('appointment_date', { ascending: true });

    AppUtils.hideLoading();

    if (error) {
        console.error("Fetch err:", error);
        AppUtils.showToast("Could not load schedule.", "error");
        return;
    }

    allAppointments = data;
}

window.switchTab = (tabId) => {
    document.querySelectorAll('.sidebar-link').forEach(el => el.classList.remove('active'));
    if (event && event.target) {
        event.target.closest('.sidebar-link').classList.add('active');
    }

    const content = document.getElementById('dashboard-content');

    let title, emptyIcon, emptyMsg;
    if (tabId === 'requests') {
        title = 'Appointment Requests';
        emptyIcon = '📩';
        emptyMsg = 'No pending requests.';
    } else if (tabId === 'schedule') {
        title = 'Confirmed Schedule';
        emptyIcon = '📅';
        emptyMsg = 'No scheduled appointments.';
    } else {
        title = 'Appointment History';
        emptyIcon = '🕒';
        emptyMsg = 'No past appointments yet.';
    }

    content.innerHTML = `<h2>${title}</h2>`;

    const filtered = allAppointments.filter(app => {
        if (tabId === 'requests') return app.status === 'pending';
        if (tabId === 'schedule') return app.status === 'confirmed';
        // history: completed or cancelled
        return app.status === 'completed' || app.status === 'cancelled';
    });

    if (filtered.length === 0) {
        content.innerHTML += `<div class="empty-state"><div class="empty-icon">${emptyIcon}</div><p>${emptyMsg}</p></div>`;
        return;
    }

    filtered.forEach(app => {
        const patName = app.users ? app.users.name : 'Unknown Patient';
        const patEmail = app.users ? app.users.email : '';

        let actionButtons = '';
        if (app.status === 'pending') {
            actionButtons = `
                <button class="btn btn-success btn-sm" onclick="updateStatus('${app.id}', 'confirmed')">Accept</button>
                <button class="btn btn-danger btn-sm" onclick="updateStatus('${app.id}', 'cancelled')">Decline</button>
            `;
        } else if (app.status === 'confirmed') {
            actionButtons = `
                <button class="btn btn-primary btn-sm" onclick="updateStatus('${app.id}', 'completed')">Complete</button>
            `;
        }

        const row = document.createElement('div');
        row.className = 'appointment-row fade-in';
        row.innerHTML = `
            <div class="appt-info">
                <h4>${patName}</h4>
                ${tabId === 'history' && patEmail ? `<span class="text-xs text-muted">${patEmail}</span>` : ''}
                <div class="appt-meta">
                    <span>📅 ${AppUtils.formatDate(app.appointment_date)}</span>
                    <span>🕒 ${AppUtils.formatTime(app.appointment_time)}</span>
                </div>
                ${app.symptoms_described ? `<div class="appt-symptoms"><strong>Symptoms:</strong> ${app.symptoms_described}</div>` : ''}
            </div>
            <div class="appt-actions">
                <span class="badge badge-${app.status}">${app.status}</span>
                ${actionButtons}
            </div>
        `;
        content.appendChild(row);
    });
};

window.updateStatus = async (id, status) => {
    AppUtils.showLoading("Updating...");
    const { error } = await supabase.from('appointments').update({ status, updated_at: new Date().toISOString() }).eq('id', id);
    AppUtils.hideLoading();

    if (error) {
        AppUtils.showToast("Update failed.", "error");
    } else {
        AppUtils.showToast(`Appointment ${status}.`, "success");
        await fetchAppointments();
        if (status === 'completed') window.switchTab('history');
        else window.switchTab('requests');
    }
};
