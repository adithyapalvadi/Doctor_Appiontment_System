import { supabase } from './supabase-config.js';
import { AuthManager, AppUtils } from './app.js';

let allSymptoms = [];
let currentMgmtTab = 'doctors';

document.addEventListener('DOMContentLoaded', async () => {
    // 1. Guard access
    const allowed = await AuthManager.requireAuth(['admin']);
    if (!allowed) return;

    // 2. Global Helpers
    window.openModal = (id) => document.getElementById(id).classList.add('show');
    window.closeModal = (id) => document.getElementById(id).classList.remove('show');

    // 3. Tab Switching Logic for Management Section
    window.switchMgmtTab = (tabId) => {
        currentMgmtTab = tabId;
        document.querySelectorAll('.mgmt-tab').forEach(el => {
            el.classList.toggle('active', el.getAttribute('onclick').includes(tabId));
        });
        
        if (tabId === 'doctors') renderDoctors();
        else renderSymptoms();
    };

    // 4. Initial Load
    await loadDashboardData();

    // 5. Form Listeners
    document.getElementById('add-symptom-form').addEventListener('submit', handleAddSymptom);
});

async function loadDashboardData() {
    AppUtils.showLoading("Loading dashboard...");
    
    // Fetch all necessary data for analytics and management
    const [
        { count: patientCount },
        { count: doctorCount },
        { data: appts, error: apptErr },
        { data: symptoms, error: sympErr }
    ] = await Promise.all([
        supabase.from('users').select('*', { count: 'exact', head: true }).eq('role', 'patient'),
        supabase.from('doctors').select('*', { count: 'exact', head: true }),
        supabase.from('appointments').select('*, doctors(specialty)'),
        supabase.from('symptoms').select('*')
    ]);

    AppUtils.hideLoading();

    if (apptErr || sympErr) {
        AppUtils.showToast("Error loading some data.", "error");
    }

    allSymptoms = symptoms || [];
    
    // Render Components
    renderTopStats(patientCount, doctorCount, appts || []);
    renderCharts(appts || []);
    window.switchMgmtTab(currentMgmtTab);
}

// --- TOP STATS ---
function renderTopStats(patients, doctors, appts) {
    const today = new Date().toISOString().split('T')[0];
    const todayAppts = appts.filter(a => a.appointment_date === today).length;
    const completedTotal = appts.filter(a => a.status === 'completed').length;

    const row = document.getElementById('top-stats-row');
    row.innerHTML = `
        <div class="stat-card-pill">
            <div class="stat-icon-wrapper stat-icon-blue">👥</div>
            <div class="stat-content">
                <h2>${patients.toLocaleString()}</h2>
                <p>Total Patients</p>
            </div>
        </div>
        <div class="stat-card-pill">
            <div class="stat-icon-wrapper stat-icon-teal">🩺</div>
            <div class="stat-content">
                <h2>${doctors.toLocaleString()}</h2>
                <p>Total Doctors</p>
            </div>
        </div>
        <div class="stat-card-pill">
            <div class="stat-icon-wrapper stat-icon-green">📅</div>
            <div class="stat-content">
                <h2>${todayAppts}</h2>
                <p>Today's Appointments</p>
            </div>
        </div>
        <div class="stat-card-pill">
            <div class="stat-icon-wrapper stat-icon-amber">📈</div>
            <div class="stat-content">
                <h2>${completedTotal.toLocaleString()}</h2>
                <p>Completed Total</p>
            </div>
        </div>
    `;
}

// --- CHARTS ---
function renderCharts(appts) {
    const chartsGrid = document.getElementById('charts-section');
    
    // 1. Appointments by Status
    const statusCounts = { completed: 0, confirmed: 0, pending: 0, cancelled: 0 };
    appts.forEach(a => statusCounts[a.status] = (statusCounts[a.status] || 0) + 1);
    
    const maxStatus = Math.max(...Object.values(statusCounts), 1);
    const statusColors = { completed: '#22c55e', confirmed: '#3b82f6', pending: '#f59e0b', cancelled: '#ef4444' };
    const statusLabels = { completed: 'Completed', confirmed: 'Booked', pending: 'Pending', cancelled: 'Cancelled' };

    // 2. Appointments by Specialty
    const specCounts = {};
    appts.forEach(a => {
        const spec = a.doctors?.specialty || 'Unknown';
        specCounts[spec] = (specCounts[spec] || 0) + 1;
    });
    const sortedSpecs = Object.entries(specCounts).sort((a,b) => b[1] - a[1]).slice(0, 5);
    const maxSpec = Math.max(...sortedSpecs.map(s => s[1]), 1);
    const specColors = ['#3b82f6', '#14b8a6', '#0ea5e9', '#8b5cf6', '#ec4899'];

    const noAppts = appts.length === 0;

    chartsGrid.innerHTML = `
        <div class="chart-card">
            <h3>📊 Appointments by Status</h3>
            ${noAppts ? `<p class="text-muted text-sm" style="padding: 1rem 0;">No appointment data yet. Charts will populate as patients book appointments.</p>` :
            Object.entries(statusCounts).map(([status, count]) => `
                <div class="bar-item">
                    <div class="bar-header">
                        <span style="color: ${statusColors[status]}; font-weight: 600;">${statusLabels[status]}</span>
                        <span style="font-weight: 700;">${count}</span>
                    </div>
                    <div class="bar-track">
                        <div class="bar-fill" style="width: ${(count/maxStatus)*100}%; background: ${statusColors[status]}"></div>
                    </div>
                </div>
            `).join('')}
        </div>
        <div class="chart-card">
            <h3>🧬 Appointments by Specialty</h3>
            ${noAppts || sortedSpecs.length === 0 ? `<p class="text-muted text-sm" style="padding: 1rem 0;">No specialty data yet. Charts will populate as patients book appointments.</p>` :
            sortedSpecs.map(([spec, count], i) => `
                <div class="bar-item">
                    <div class="bar-header">
                        <span style="font-weight: 600;">${spec}</span>
                        <span style="font-weight: 700;">${count}</span>
                    </div>
                    <div class="bar-track">
                        <div class="bar-fill" style="width: ${(count/maxSpec)*100}%; background: ${specColors[i % specColors.length]}"></div>
                    </div>
                </div>
            `).join('')}
        </div>
    `;
}

// --- DOCTOR MANAGEMENT ---
async function renderDoctors() {
    const mgmtContent = document.getElementById('mgmt-content');
    mgmtContent.innerHTML = '<div class="loading-state"><div class="spinner"></div></div>';

    const { data: doctors, error } = await supabase.from('doctors').select('*').order('name');

    if (error) {
        mgmtContent.innerHTML = `<p class="text-danger">Error: ${error.message}</p>`;
        return;
    }

    mgmtContent.innerHTML = `
        <div class="card p-0" style="overflow-x: auto;">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Specialty</th>
                        <th>Experience</th>
                        <th>Address</th>
                        <th style="width: 100px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    ${doctors.map(doc => `
                        <tr>
                            <td class="font-semibold">${doc.name}</td>
                            <td><span class="status-badge status-confirmed">${doc.specialty}</span></td>
                            <td>${doc.experience_years} Years</td>
                            <td class="text-sm">${doc.address || 'Chennai'}</td>
                            <td>
                                <button class="btn btn-ghost btn-sm text-danger" onclick="deleteDoctor('${doc.id}', '${doc.name}')">Delete</button>
                            </td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        </div>
    `;
}

// --- SYMPTOM MANAGEMENT ---
async function renderSymptoms(filter = '') {
    const mgmtContent = document.getElementById('mgmt-content');
    
    const filtered = allSymptoms.filter(s => s.symptom_name.toLowerCase().includes(filter.toLowerCase()));
    const specialties = new Set(allSymptoms.map(s => s.mapped_specialty));

    mgmtContent.innerHTML = `
        <div class="symptom-tag-card">
            <div class="flex justify-between items-center mb-4">
                <div class="search-wrapper flex-1">
                    <span class="icon">🔍</span>
                    <input type="text" id="symp-search" class="form-control" placeholder="Search symptoms..." value="${filter}" oninput="handleSymptomSearch(this.value)">
                </div>
                <button class="btn btn-primary ml-4" onclick="openModal('add-symptom-modal')">+ Add Symptom</button>
            </div>
            
            <div class="tag-cloud">
                ${filtered.length ? filtered.map(s => `
                    <div class="symptom-tag">
                        ${s.symptom_name}
                        <button class="tag-remove" onclick="deleteSymptom('${s.id}', '${s.symptom_name}')">×</button>
                    </div>
                `).join('') : '<p class="text-muted p-4">No symptoms found.</p>'}
            </div>

            <div class="summary-stats-grid">
                <div class="summary-stat-card">
                    <h2>${allSymptoms.length}</h2>
                    <p>Total Symptoms</p>
                </div>
                <div class="summary-stat-card">
                    <h2>${specialties.size}</h2>
                    <p>Specialties Covered</p>
                </div>
                <div class="summary-stat-card">
                    <h2>${(allSymptoms.length / (specialties.size || 1)).toFixed(1)}</h2>
                    <p>Avg per Specialty</p>
                </div>
            </div>
        </div>
    `;

    // Focus search if it was active
    if (filter) document.getElementById('symp-search').focus();
}

window.handleSymptomSearch = (val) => {
    // We don't want to re-render the whole management content on every keystroke if it's too expensive, 
    // but for symptoms (< 100 items), it's fine.
    renderSymptoms(val);
};

// --- CRUD OPS ---
async function handleAddSymptom(e) {
    e.preventDefault();
    const name = document.getElementById('new-symptom-name').value;
    const specialty = document.getElementById('new-symptom-specialty').value;

    AppUtils.showLoading("Adding...");
    const { error } = await supabase.from('symptoms').insert([{ symptom_name: name, mapped_specialty: specialty }]);
    AppUtils.hideLoading();

    if (error) {
        AppUtils.showToast("Error: " + error.message, "error");
    } else {
        AppUtils.showToast("Symptom added!", "success");
        window.closeModal('add-symptom-modal');
        document.getElementById('add-symptom-form').reset();
        await loadDashboardData(); // Refresh everything
    }
}

window.deleteDoctor = async (id, name) => {
    if (!confirm(`Delete Dr. ${name}?`)) return;
    const { error } = await supabase.from('doctors').delete().eq('id', id);
    if (!error) renderDoctors();
};

window.deleteSymptom = async (id, name) => {
    if (!confirm(`Remove "${name}"?`)) return;
    const { error } = await supabase.from('symptoms').delete().eq('id', id);
    if (!error) {
        allSymptoms = allSymptoms.filter(s => s.id !== id);
        renderSymptoms();
    }
};
