import { supabase } from './supabase-config.js';
import { AppUtils } from './app.js';

let allSymptoms = [];
let selectedSymptoms = new Set();
let symptomMapping = {};

document.addEventListener('DOMContentLoaded', async () => {
    AppUtils.showLoading("Loading symptoms...");

    const { data, error } = await supabase
        .from('symptoms')
        .select('*');

    AppUtils.hideLoading();

    if (error) {
        console.error("Error fetching symptoms:", error);
        AppUtils.showToast("Failed to load symptoms. Please try again later.", "error");
        return;
    }

    allSymptoms = data;
    allSymptoms.forEach(s => {
        symptomMapping[s.symptom_name] = s.mapped_specialty;
    });

    renderSymptoms(allSymptoms);

    // Search filter
    document.getElementById('symptom-search').addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        const filtered = allSymptoms.filter(s => s.symptom_name.toLowerCase().includes(query));
        renderSymptoms(filtered);
    });

    // Find doctors button
    document.getElementById('find-doctor-btn').addEventListener('click', calculateSpecialtyAndRedirect);
});

function renderSymptoms(list) {
    const grid = document.getElementById('symptoms-grid');
    grid.innerHTML = '';

    if (list.length === 0) {
        grid.innerHTML = '<div class="empty-state" style="grid-column:1/-1;"><div class="empty-icon">🔍</div><p>No symptoms found matching your search.</p></div>';
        return;
    }

    list.forEach(symptom => {
        const isSelected = selectedSymptoms.has(symptom.symptom_name);
        const chip = document.createElement('div');
        chip.className = `symptom-chip ${isSelected ? 'selected' : ''}`;
        chip.innerHTML = `
            <span class="check-circle">${isSelected ? '✓' : ''}</span>
            <span>${symptom.symptom_name}</span>
        `;

        chip.addEventListener('click', () => {
            if (selectedSymptoms.has(symptom.symptom_name)) {
                selectedSymptoms.delete(symptom.symptom_name);
            } else {
                selectedSymptoms.add(symptom.symptom_name);
            }
            renderSymptoms(list); // Re-render to show updated state
            updateSelectedPills();
        });

        grid.appendChild(chip);
    });
}

function updateSelectedPills() {
    const container = document.getElementById('selected-symptoms-container');
    container.innerHTML = '';

    const btn = document.getElementById('find-doctor-btn');
    btn.disabled = selectedSymptoms.size === 0;

    selectedSymptoms.forEach(s => {
        const pill = document.createElement('span');
        pill.className = 'pill';
        pill.innerHTML = `${s} <span class="remove" data-symptom="${s}">&times;</span>`;
        pill.querySelector('.remove').addEventListener('click', (e) => {
            e.stopPropagation();
            selectedSymptoms.delete(s);
            renderSymptoms(allSymptoms);
            updateSelectedPills();
        });
        container.appendChild(pill);
    });
}

function calculateSpecialtyAndRedirect() {
    if (selectedSymptoms.size === 0) return;

    const specialtyCounts = {};
    selectedSymptoms.forEach(symptom => {
        const specialty = symptomMapping[symptom];
        if (specialty) {
            specialtyCounts[specialty] = (specialtyCounts[specialty] || 0) + 1;
        }
    });

    let targetSpecialty = 'General Physician';
    let maxCount = 0;

    for (const [specialty, count] of Object.entries(specialtyCounts)) {
        if (count > maxCount) {
            maxCount = count;
            targetSpecialty = specialty;
        }
    }

    sessionStorage.setItem('medconnect_current_symptoms', Array.from(selectedSymptoms).join(', '));

    AppUtils.showLoading(`Routing to ${targetSpecialty}...`);
    setTimeout(() => {
        window.location.href = `doctors.html?specialty=${encodeURIComponent(targetSpecialty)}`;
    }, 800);
}
