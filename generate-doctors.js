const https = require('https');
const fs = require('fs');

const specialties = [
    'Neurologist', 'Dermatologist', 'Gastroenterologist', 'Orthopedist',
    'Gynecologist', 'Pediatrician', 'ENT', 'Ophthalmologist',
    'Psychiatrist', 'Urologist', 'Pulmonologist', 'Endocrinologist',
    'General Surgeon', 'General Physician'
];

// We map Practo categories to our DB
const nameMap = {
    'Orthopedist': 'Orthopedic Surgeon',
    'ENT': 'ENT Specialist',
    'General Surgeon': 'General Surgeon',
    'General Physician': 'General Physician'
};

const outputSql = [];

function fetchPracto(specialty) {
    return new Promise((resolve) => {
        const query = encodeURIComponent(`[{"word":"${specialty}","autocompleted":true,"category":"subspeciality"}]`);
        const url = `https://www.practo.com/search/doctors?results_type=doctor&q=${query}&city=Chennai`;
        
        https.get(url, {
            headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                'Accept': 'text/html,application/xhtml+xml'
            }
        }, (res) => {
            let data = '';
            res.on('data', chunk => data += chunk);
            res.on('end', () => resolve(data));
        }).on('error', () => resolve(''));
    });
}

function randExp() { return Math.floor(Math.random() * 25) + 5; }
function phoneStr(i, j) { return `+91 9876${i}${j}001`; }

async function run() {
    console.log("Starting Practo scrape for 14 specialties...");
    
    for (let i=0; i<specialties.length; i++) {
        const spec = specialties[i];
        const dbSpec = nameMap[spec] || spec;
        console.log(`Scraping ${spec}...`);
        
        try {
            const html = await fetchPracto(spec);
            
            // Extract doctor names and clinics using regex
            const nameMatches = [...html.matchAll(/<h2 data-qa-id="doctor_name"[^>]*>(.*?)<\/h2>/g)].map(m => m[1]);
            const clinicMatches = [...html.matchAll(/<span data-qa-id="clinic_name"[^>]*>(.*?)<\/span>/g)].map(m => m[1]);
            const areaMatches = [...html.matchAll(/<span data-qa-id="clinic_locality"[^>]*>(.*?)<\/span>/g)].map(m => m[1]);
            
            // Limit to 8
            const numToExtract = Math.min(8, nameMatches.length);
            
            for(let j=0; j<numToExtract; j++) {
                const name = nameMatches[j];
                const area = areaMatches[j] || 'Chennai';
                const clinic = clinicMatches[j] || 'Specialty Clinic';
                const about = `Experienced ${dbSpec.toLowerCase()} in ${area}.`;
                const email = `${name.toLowerCase().replace(/[^a-z]/g, '')}@medconnect.com`;
                const phone = phoneStr(i, j);
                const exp = randExp();
                const address = `${clinic}, ${area}, Chennai`;
                
                outputSql.push(`    ('${name.replace(/'/g, "''")}', '${dbSpec.replace(/'/g, "''")}', ${exp}, '${about}', ARRAY['Monday', 'Wednesday', 'Friday'], '${email}', '${phone}', '${address.replace(/'/g, "''")}')`);
            }
            
            if (numToExtract < 8) {
                console.log(`  Warning: Only extracted ${numToExtract} doctors for ${spec}.`);
            }
        } catch(e) {
            console.log(" Error scraping", spec, e);
        }
        
        // delay to prevent rate limit
        await new Promise(r => setTimeout(r, 1000));
    }
    
    if (outputSql.length > 0) {
        const finalSql = `INSERT INTO public.doctors (name, specialty, experience_years, about, available_days, email, phone, address) VALUES \n` +
            outputSql.join(',\n') + '\nON CONFLICT DO NOTHING;';
            
        fs.writeFileSync('practo_seed.sql', finalSql);
        console.log(`\nSuccessfully generated ${outputSql.length} doctors into practo_seed.sql`);
    } else {
        console.log("No data extracted. Practo might be blocking the automated script.");
    }
}

run();
