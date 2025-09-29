<?php
header('Content-Type: application/json');

include('../config_pdo.php');
// Enable error reporting untuk debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Log semua input yang diterima
file_put_contents('debug.log', "=== " . date('Y-m-d H:i:s') . " ===\n", FILE_APPEND);
file_put_contents('debug.log', "POST: " . print_r($_POST, true) . "\n", FILE_APPEND);
file_put_contents('debug.log', "GET: " . print_r($_GET, true) . "\n", FILE_APPEND);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    // Validasi data
    if (empty($data['pengguna']) || empty($data['lokasi']) || empty($data['tanggal'])) {
        echo json_encode(['success' => false, 'message' => 'Data tidak lengkap']);
        exit;
    }
    
    // Generate UUID
    $uuid = generateUUID();
    
    try {
        $stmt = $pdo->prepare("INSERT INTO kerjaan (pengguna, lokasi, status_pembayaran, tanggal) VALUES (?, ?, ?, ?)");
        $stmt->execute([
            $data['pengguna'],
            $data['lokasi'],
            $data['status_pembayaran'],
            $data['tanggal']
        ]);
        
        echo json_encode(['success' => true, 'message' => 'Pekerjaan berhasil ditambahkan', 'uuid' => $uuid]);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method tidak diizinkan']);
}

function generateUUID() {
    return sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
        mt_rand(0, 0xffff), mt_rand(0, 0xffff),
        mt_rand(0, 0xffff),
        mt_rand(0, 0x0fff) | 0x4000,
        mt_rand(0, 0x3fff) | 0x8000,
        mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
    );
}
?>