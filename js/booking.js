import { supabase } from './supabase-config.js';
import { AuthManager, AppUtils } from './app.js';

document.addEventListener('DOMContentLoaded', async () => {
    // Wait for auth to fully initialize
    await AuthManager.waitForAuth();

    // Guard — redirect if not a patient
    if (!AuthManager.userProfile || AuthManager.userProfile.role !== 'patient') {
        AppUtils.showToast("Please log in as a patient.", "warning");
        setTimeout(() => window.location.href = 'auth.html', 1500);
        return;
    }

    const doctorId = sessionStorage.getItem('medconnect_booking_doctor_id');
    const doctorName = sessionStorage.getItem('medconnect_booking_doctor_name');
    const autoSymptoms = sessionStorage.getItem('medconnect_current_symptoms');

    if (!doctorId) {
        AppUtils.showToast("No doctor selected. Redirecting...", "warning");
        setTimeout(() => window.location.href = 'doctors.html', 1500);
        return;
    }

    document.getElementById('booking-doctor-name').textContent = doctorName;
    if (autoSymptoms) {
        document.getElementById('booking-symptoms').value = `Symptoms: ${autoSymptoms}`;
    }

    // Restrict date to today/future
    const dateInput = document.getElementById('booking-date');
    const today = new Date().toISOString().split('T')[0];
    dateInput.setAttribute('min', today);

    document.getElementById('booking-form').addEventListener('submit', async (e) => {
        e.preventDefault();

        const patientId = AuthManager.userProfile?.id;
        if (!patientId) {
            AppUtils.showToast("Authentication error. Please log in again.", "error");
            return;
        }

        const date = dateInput.value;
        const time = document.getElementById('booking-time').value;
        const symptoms = document.getElementById('booking-symptoms').value;

        AppUtils.showLoading("Confirming appointment...");

        const { error } = await supabase.from('appointments').insert([{
            patient_id: patientId,
            doctor_id: doctorId,
            appointment_date: date,
            appointment_time: time,
            symptoms_described: symptoms,
            status: 'pending'
        }]);

        AppUtils.hideLoading();

        if (error) {
            console.error("Booking err:", error);
            AppUtils.showToast("Booking failed: " + (error.message || "Unknown error"), "error");
        } else {
            sessionStorage.removeItem('medconnect_current_symptoms');
            document.getElementById('success-modal').style.display = 'flex';
        }
    });
});
