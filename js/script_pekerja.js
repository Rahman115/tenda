// Variabel global untuk menyimpan data
let kerjaanData = [];
let usersData = [];
let pekerjaData = [];

// Fungsi untuk memuat data dari API
async function loadData() {
    try {
        // Memuat data kerjaan
        const kerjaanResponse = await fetch('kerjaan.php');
        kerjaanData = await kerjaanResponse.json();
        populateKerjaanSelect();
        
        // Memuat data users
        const usersResponse = await fetch('users.php');
        usersData = await usersResponse.json();
        populateUsersSelect();
        
        // Memuat data pekerja (jika ada endpoint untuk ini)
        await loadPekerjaData();
        
    } catch (error) {
        console.error('Error loading data:', error);
        showMessage('Error memuat data: ' + error.message, 'error');
    }
}

// Fungsi untuk mengisi dropdown kerjaan
function populateKerjaanSelect() {
    const kerjaanSelect = document.getElementById('kerjaan');
    kerjaanSelect.innerHTML = '<option value="">-- Pilih Kerjaan --</option>';
    
    kerjaanData.forEach(kerjaan => {
        const option = document.createElement('option');
        option.value = kerjaan.uuid;
        option.textContent = kerjaan.pengguna;
        kerjaanSelect.appendChild(option);
    });
}

// Fungsi untuk mengisi dropdown users
function populateUsersSelect() {
    const userSelect = document.getElementById('user');
    userSelect.innerHTML = '<option value="">-- Pilih User --</option>';
    
    usersData.forEach(user => {
        const option = document.createElement('option');
        option.value = user.id;
        option.textContent = user.username;
        userSelect.appendChild(option);
    });
}

// Fungsi untuk memuat data pekerja
async function loadPekerjaData() {
    try {
        // Jika ada endpoint untuk mengambil data pekerja
        // const response = await fetch('get_pekerja.php');
        // pekerjaData = await response.json();
        
        // Untuk contoh, kita akan menggunakan data dummy
        // Dalam implementasi nyata, ganti dengan panggilan API yang sesungguhnya
        pekerjaData = [
            { id: 1, kerjaan_id: 1, user_id: 1, kerjaan: "Desain Web", username: "user1" },
            { id: 2, kerjaan_id: 1, user_id: 2, kerjaan: "Desain Web", username: "user2" },
            { id: 3, kerjaan_id: 2, user_id: 3, kerjaan: "Pengembangan Aplikasi", username: "user3" }
        ];
        
        populatePekerjaTable();
    } catch (error) {
        console.error('Error loading pekerja data:', error);
    }
}

// Fungsi untuk mengisi tabel pekerja
function populatePekerjaTable() {
    const tableBody = document.querySelector('#pekerjaTable tbody');
    tableBody.innerHTML = '';
    
    pekerjaData.forEach(pekerja => {
        const row = document.createElement('tr');
        
        // Cari nama kerjaan dan username berdasarkan ID
        const kerjaan = kerjaanData.find(k => k.id == pekerja.kerjaan_id) || { kerjaan: 'Tidak Diketahui' };
        const user = usersData.find(u => u.id == pekerja.user_id) || { username: 'Tidak Diketahui' };
        
        row.innerHTML = `
            <td>${pekerja.id}</td>
            <td>${kerjaan.kerjaan}</td>
            <td>${user.username}</td>
        `;
        
        tableBody.appendChild(row);
    });
}

// Fungsi untuk menampilkan pesan
function showMessage(message, type) {
    const messageDiv = document.getElementById('message');
    messageDiv.textContent = message;
    messageDiv.className = `message ${type}`;
    messageDiv.style.display = 'block';
    
    // Sembunyikan pesan setelah 5 detik
    setTimeout(() => {
        messageDiv.style.display = 'none';
    }, 5000);
}

// Event listener untuk form submission
document.getElementById('pekerjaForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    const kerjaanId = document.getElementById('kerjaan').value;
    const userId = document.getElementById('user').value;
    
    console.log('🔍 Form values:', { kerjaanId, userId }); // Debug
    
    if (!kerjaanId || !userId) {
        showMessage('Harap pilih kerjaan dan user!', 'error');
        return;
    }
    
    try {
        console.log('📤 Sending request...');
        const response = await fetch('php/pekerja_save.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                kerjaan_id: kerjaanId,
                user_id: userId
            })
        });
        
        console.log('📥 Response status:', response.status);
        
        // Cek jika response bukan JSON yang valid
        const responseText = await response.text();
        console.log('📥 Raw response text:', responseText);
        
        let data;
        try {
            data = JSON.parse(responseText);
        } catch (parseError) {
            console.error('❌ JSON Parse Error:', parseError);
            console.error('❌ Response text that failed to parse:', responseText);
            showMessage('Error: Response dari server tidak valid', 'error');
            return;
        }
        
        console.log('📥 Parsed JSON data:', data);
        
        if (data.success) {
            showMessage('Pekerja berhasil ditambahkan!', 'success');
            // Reset form
            document.getElementById('pekerjaForm').reset();
            // Muat ulang data pekerja
            await loadPekerjaData();
        } else {
            showMessage('Gagal menambahkan pekerja: ' + data.message, 'error');
        }
    } catch (error) {
        console.error('❌ Error:', error);
        showMessage('Error: ' + error.message, 'error');
    }
});
// Muat data saat halaman dimuat
document.addEventListener('DOMContentLoaded', loadData);