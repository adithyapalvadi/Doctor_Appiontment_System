import { supabase } from './supabase-config.js';
import { AuthManager, AppUtils } from './app.js';

let allAppointments = [];
let existingRatings = {}; // { appointment_id: { rating, review } }
let currentRatingContext = null; // { appointment_id, doctor_id, doctor_name }

document.addEventListener('DOMContentLoaded', async () => {
    // Wait for auth to fully resolve
    await AuthManager.waitForAuth();

    if (!AuthManager.userProfile || AuthManager.userProfile.role !== 'patient') {
        AppUtils.showToast("Please log in as a patient.", "warning");
        setTimeout(() => window.location.href = 'auth.html', 1500);
        return;
    }

    // Auth is ready — directly load data
    await fetchAppointments();
    await fetchExistingRatings();
    window.switchTab('upcoming');
    initRatingModal();
});

async function fetchAppointments() {
    AppUtils.showLoading("Loading appointments...");

    const { data, error } = await supabase
        .from('appointments')
        .select(`
            *,
            doctors (
                name, specialty, email, phone, address,
                users (email)
            )
        `)
        .eq('patient_id', AuthManager.userProfile.id)
        .order('appointment_date', { ascending: false });

    AppUtils.hideLoading();

    if (error) {
        console.error("Fetch err:", error);
        AppUtils.showToast("Could not load appointments.", "error");
        return;
    }

    allAppointments = data;
}

async function fetchExistingRatings() {
    const { data, error } = await supabase
        .from('ratings')
        .select('appointment_id, rating, review')
        .eq('patient_id', AuthManager.userProfile.id);

    if (!error && data) {
        data.forEach(r => {
            existingRatings[r.appointment_id] = { rating: r.rating, review: r.review };
        });
    }
}

function initRatingModal() {
    const starBtns = document.querySelectorAll('#rating-stars .star-btn');
    let selectedRating = 0;

    starBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            selectedRating = parseInt(btn.dataset.value);
            starBtns.forEach(b => {
                b.classList.toggle('active', parseInt(b.dataset.value) <= selectedRating);
            });
            document.getElementById('submit-rating-btn').disabled = false;
        });

        // Hover preview
        btn.addEventListener('mouseenter', () => {
            const val = parseInt(btn.dataset.value);
            starBtns.forEach(b => {
                if (parseInt(b.dataset.value) <= val) b.style.color = 'var(--accent-amber)';
                else b.style.color = '';
            });
        });

        btn.addEventListener('mouseleave', () => {
            starBtns.forEach(b => {
                if (!b.classList.contains('active')) b.style.color = '';
            });
        });
    });

    document.getElementById('submit-rating-btn').addEventListener('click', async () => {
        if (!currentRatingContext || selectedRating === 0) return;

        AppUtils.showLoading("Submitting rating...");

        const { error } = await supabase.from('ratings').insert([{
            patient_id: AuthManager.userProfile.id,
            doctor_id: currentRatingContext.doctor_id,
            appointment_id: currentRatingContext.appointment_id,
            rating: selectedRating,
            review: document.getElementById('rating-review').value || null
        }]);

        AppUtils.hideLoading();

        if (error) {
            console.error("Rating err:", error);
            AppUtils.showToast("Failed to submit rating. " + (error.message || ''), "error");
        } else {
            existingRatings[currentRatingContext.appointment_id] = {
                rating: selectedRating,
                review: document.getElementById('rating-review').value
            };
            AppUtils.showToast("Rating submitted! Thank you.", "success");
            window.switchTab('history');
        }

        closeRatingModal();
        selectedRating = 0;
    });
}

window.openRatingModal = (appointmentId, doctorId, doctorName) => {
    currentRatingContext = { appointment_id: appointmentId, doctor_id: doctorId, doctor_name: doctorName };
    document.getElementById('rating-doctor-label').textContent = `How was your visit with ${doctorName}?`;
    document.getElementById('rating-review').value = '';
    document.querySelectorAll('#rating-stars .star-btn').forEach(b => b.classList.remove('active'));
    document.getElementById('submit-rating-btn').disabled = true;
    document.getElementById('rating-modal').classList.add('show');
};

window.closeRatingModal = () => {
    document.getElementById('rating-modal').classList.remove('show');
    currentRatingContext = null;
};

window.switchTab = (tabId) => {
    document.querySelectorAll('.sidebar-link').forEach(el => el.classList.remove('active'));
    if (event && event.target) {
        event.target.closest('.sidebar-link').classList.add('active');
    }

    const content = document.getElementById('dashboard-content');
    const title = tabId === 'upcoming' ? 'Upcoming Appointments' : 'Appointment History';
    content.innerHTML = `<h2>${title}</h2>`;

    const now = new Date();
    now.setHours(0, 0, 0, 0);

    const filtered = allAppointments.filter(app => {
        const appDate = new Date(app.appointment_date);
        appDate.setHours(0, 0, 0, 0);

        if (tabId === 'upcoming') {
            return appDate >= now && app.status !== 'cancelled' && app.status !== 'completed';
        } else {
            return appDate < now || app.status === 'cancelled' || app.status === 'completed';
        }
    });

    if (filtered.length === 0) {
        content.innerHTML += `<div class="empty-state"><div class="empty-icon">📋</div><p>No ${tabId} appointments.</p></div>`;
        return;
    }

    filtered.forEach(app => {
        const docName = app.doctors ? app.doctors.name : 'Unknown Doctor';
        const docSpec = app.doctors ? app.doctors.specialty : '';
        const docEmail = (app.doctors && app.doctors.email) || (app.doctors && app.doctors.users && app.doctors.users.email) || '';
        const docPhone = app.doctors && app.doctors.phone ? app.doctors.phone : '';
        const docAddress = app.doctors && app.doctors.address ? app.doctors.address : '';
        const rated = existingRatings[app.id];

        let actionButtons = '';

        if (tabId === 'upcoming' && app.status !== 'cancelled') {
            actionButtons = `<button class="btn btn-danger btn-sm" onclick="cancelAppointment('${app.id}')">Cancel</button>`;
        }

        if (app.status === 'completed') {
            if (rated) {
                actionButtons = `
                    <span class="meta-tag" style="background: rgba(245,158,11,0.1); color: var(--accent-amber);">
                        ${'★'.repeat(rated.rating)}${'☆'.repeat(5 - rated.rating)} Rated
                    </span>
                `;
            } else {
                actionButtons = `
                    <button class="btn btn-primary btn-sm" onclick="openRatingModal('${app.id}', '${app.doctor_id}', '${docName}')">
                        ⭐ Rate Doctor
                    </button>
                `;
            }
        }

        const row = document.createElement('div');
        row.className = 'appointment-row fade-in';
        row.innerHTML = `
            <div class="appt-info">
                <h4>${docName}</h4>
                <span class="specialty-text text-sm" style="color: var(--primary-500); font-weight:600;">${docSpec}</span>
                ${docEmail || docPhone || docAddress ? `
                <div class="appt-contact text-sm text-muted" style="margin-top: 0.5rem; margin-bottom: 0.5rem; line-height: 1.4;">
                    ${docAddress ? `<div>📍 <strong>Address:</strong> ${docAddress}</div>` : ''}
                    ${docEmail ? `<div>✉️ <strong>Email:</strong> ${docEmail}</div>` : ''}
                    ${docPhone ? `<div>📞 <strong>Phone:</strong> ${docPhone}</div>` : ''}
                </div>` : ''}
                <div class="appt-meta">
                    <span>📅 ${AppUtils.formatDate(app.appointment_date)}</span>
                    <span>🕒 ${AppUtils.formatTime(app.appointment_time)}</span>
                </div>
                ${app.symptoms_described ? `<div class="appt-symptoms">${app.symptoms_described}</div>` : ''}
            </div>
            <div class="appt-actions">
                <span class="badge badge-${app.status}">${app.status}</span>
                ${actionButtons}
            </div>
        `;
        content.appendChild(row);
    });
};

window.cancelAppointment = async (id) => {
    AppUtils.showLoading("Cancelling...");
    const { error } = await supabase.from('appointments').update({ status: 'cancelled', updated_at: new Date().toISOString() }).eq('id', id);
    AppUtils.hideLoading();

    if (error) {
        console.error("Cancel err:", error);
        AppUtils.showToast("Failed to cancel: " + (error.message || "Unknown error"), "error");
    } else {
        AppUtils.showToast("Appointment cancelled.", "success");
        await fetchAppointments();
        window.switchTab('upcoming');
    }
};
