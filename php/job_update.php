<?php
header('Content-Type: application/json');

include('../config_pdo.php');

// Enable error reporting untuk debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Log semua input yang diterima
file_put_contents('debug.log', "=== " . date('Y-m-d H:i:s') . " ===\n", FILE_APPEND);

if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    // Ambil data dari PUT request
    $input = json_decode(file_get_contents('php://input'), true);
    file_put_contents('debug.log', "Raw Input: " . file_get_contents('php://input') . "\n", FILE_APPEND);
    file_put_contents('debug.log', "Parsed Input: " . print_r($input, true) . "\n", FILE_APPEND);
    
    // Ambil UUID dari parameter GET (bukan $_GET['$job_uuid'])
    $uuid = isset($_GET['job_uuid']) ? $_GET['job_uuid'] : null;
    file_put_contents('debug.log', "UUID from GET: " . $uuid . "\n", FILE_APPEND);
    
    if (empty($uuid)) {
        file_put_contents('debug.log', "Error: UUID kosong\n", FILE_APPEND);
        echo json_encode(['success' => false, 'message' => 'UUID tidak ditemukan']);
        exit;
    }
    
    if (empty($input['pengguna']) || empty($input['lokasi']) || empty($input['status_pembayaran']) || empty($input['tanggal'])) {
        file_put_contents('debug.log', "Error: Data form tidak lengkap\n", FILE_APPEND);
        echo json_encode(['success' => false, 'message' => 'Data tidak lengkap']);
        exit;
    }
    
    try {
        $stmt = $pdo->prepare("UPDATE kerjaan SET pengguna = ?, lokasi = ?, status_pembayaran = ?, tanggal = ? WHERE uuid = ?");
        $success = $stmt->execute([
            $input['pengguna'],
            $input['lokasi'],
            $input['status_pembayaran'],
            $input['tanggal'],
            $uuid
        ]);
        
        file_put_contents('debug.log', "Update executed: " . ($success ? 'success' : 'failed') . "\n", FILE_APPEND);
        file_put_contents('debug.log', "Rows affected: " . $stmt->rowCount() . "\n", FILE_APPEND);
        
        if ($stmt->rowCount() > 0) {
            echo json_encode(['success' => true, 'message' => 'Pekerjaan berhasil diupdate']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Tidak ada data yang diupdate atau UUID tidak ditemukan']);
        }
    } catch (PDOException $e) {
        file_put_contents('debug.log', "Database Error: " . $e->getMessage() . "\n", FILE_APPEND);
        echo json_encode(['success' => false, 'message' => 'Error database: ' . $e->getMessage()]);
    }
} else {
    file_put_contents('debug.log', "Error: Method tidak diizinkan - " . $_SERVER['REQUEST_METHOD'] . "\n", FILE_APPEND);
    echo json_encode(['success' => false, 'message' => 'Method tidak diizinkan']);
}
?>