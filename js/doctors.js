import { supabase } from './supabase-config.js';
import { AppUtils } from './app.js';

let allDoctors = [];
let allSpecialties = new Set();
let doctorRatings = {}; // { doctor_id: { avg, count } }

document.addEventListener('DOMContentLoaded', async () => {
    AppUtils.showLoading("Loading doctors...");

    const urlParams = new URLSearchParams(window.location.search);
    const urlSpecialty = urlParams.get('specialty');

    // Fetch doctors and ratings in parallel
    const [doctorsRes, ratingsRes] = await Promise.all([
        supabase.from('doctors').select('*, users(email)'),
        supabase.from('ratings').select('doctor_id, rating')
    ]);

    AppUtils.hideLoading();

    if (doctorsRes.error) {
        console.error("Error fetching doctors:", doctorsRes.error);
        AppUtils.showToast("Failed to load doctor directory.", "error");
        return;
    }

    allDoctors = doctorsRes.data;
    allDoctors.forEach(doc => allSpecialties.add(doc.specialty));
    populateSpecialtyDropdown();

    // Calculate average ratings
    if (ratingsRes.data) {
        ratingsRes.data.forEach(r => {
            if (!doctorRatings[r.doctor_id]) {
                doctorRatings[r.doctor_id] = { total: 0, count: 0 };
            }
            doctorRatings[r.doctor_id].total += r.rating;
            doctorRatings[r.doctor_id].count += 1;
        });
        for (const id in doctorRatings) {
            doctorRatings[id].avg = (doctorRatings[id].total / doctorRatings[id].count).toFixed(1);
        }
    }

    if (urlSpecialty) {
        document.getElementById('recommended-banner').style.display = 'block';
        document.getElementById('recommended-specialty-text').textContent = urlSpecialty;

        const select = document.getElementById('filter-specialty');
        if ([...select.options].some(o => o.value === urlSpecialty)) {
            select.value = urlSpecialty;
        }
        renderDoctors(allDoctors.filter(d => d.specialty === urlSpecialty));
    } else {
        renderDoctors(allDoctors);
    }

    document.getElementById('filter-specialty').addEventListener('change', (e) => {
        const val = e.target.value;
        document.getElementById('recommended-banner').style.display = 'none';
        window.history.replaceState({}, '', 'doctors.html');
        renderDoctors(val === 'All' ? allDoctors : allDoctors.filter(d => d.specialty === val));
    });

    window.clearFilters = () => {
        document.getElementById('filter-specialty').value = 'All';
        document.getElementById('recommended-banner').style.display = 'none';
        window.history.replaceState({}, '', 'doctors.html');
        renderDoctors(allDoctors);
    };
});

function populateSpecialtyDropdown() {
    const select = document.getElementById('filter-specialty');
    Array.from(allSpecialties).sort().forEach(spec => {
        const opt = document.createElement('option');
        opt.value = spec;
        opt.textContent = spec;
        select.appendChild(opt);
    });
}

function renderStars(avg) {
    let html = '';
    const full = Math.floor(avg);
    const half = avg - full >= 0.5;
    for (let i = 1; i <= 5; i++) {
        if (i <= full) html += '<span>★</span>';
        else if (i === full + 1 && half) html += '<span>★</span>';
        else html += '<span class="star-empty" style="color: #cbd5e1;">☆</span>';
    }
    return html;
}

function renderDoctors(doctors) {
    const grid = document.getElementById('doctors-grid');
    grid.innerHTML = '';

    if (!doctors || doctors.length === 0) {
        grid.innerHTML = '<div class="empty-state" style="grid-column:1/-1;"><div class="empty-icon">👨‍⚕️</div><p>No doctors found for this specialty.</p></div>';
        return;
    }

    doctors.forEach(doc => {
        const initials = doc.name.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase();
        const ratingData = doctorRatings[doc.id];
        const contactEmail = doc.email || (doc.users && doc.users.email) || null;

        let ratingHtml = '';
        if (ratingData) {
            ratingHtml = `
                <div class="doctor-rating">
                    <div class="stars">${renderStars(parseFloat(ratingData.avg))}</div>
                    <span class="rating-number">${ratingData.avg}</span>
                    <span class="rating-count">(${ratingData.count})</span>
                </div>
            `;
        } else {
            ratingHtml = `<div class="doctor-rating"><span class="rating-count">No ratings yet</span></div>`;
        }

        const card = document.createElement('div');
        card.className = 'card doctor-card card-lift animation-card';
        card.style.height = '100%';
        card.style.display = 'flex';
        card.style.flexDirection = 'column';
        
        card.innerHTML = `
            <div class="doctor-avatar">${initials}</div>
            <div class="doctor-info" style="flex-grow: 1; display: flex; flex-direction: column;">
                <h3>${doc.name}</h3>
                <div class="doctor-specialty">${doc.specialty}</div>
                ${ratingHtml}
                <div class="doctor-meta">
                    <p><strong>${doc.experience_years}</strong> years experience</p>
                    ${doc.address ? `<p style="font-size: 0.85rem">📍 ${doc.address}</p>` : ''}
                    ${contactEmail ? `<p style="font-size: 0.85rem">✉️ ${contactEmail}</p>` : ''}
                </div>
                <div class="flex flex-wrap gap-1 mt-2 mb-2">
                    ${doc.available_days && doc.available_days.length > 0
                        ? doc.available_days.map(day => `<span class="slot">${day}</span>`).join('')
                        : '<span class="slot">Contact for availability</span>'}
                </div>
            </div>
            <button class="btn btn-primary btn-block book-btn" style="margin-top: auto;" data-id="${doc.id}">Book Appointment</button>
        `;

        card.querySelector('.book-btn').addEventListener('click', () => {
            sessionStorage.setItem('medconnect_booking_doctor_id', doc.id);
            sessionStorage.setItem('medconnect_booking_doctor_name', doc.name);
            window.location.href = 'booking.html';
        });

        grid.appendChild(card);
    });
}
