<?php
header('Content-Type: application/json');
include '../config.php';

// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Log debugging information
file_put_contents('debug.log', "=== " . date('Y-m-d H:i:s') . " ===\n", FILE_APPEND);

// Ambil data dari POST request
$input = json_decode(file_get_contents('php://input'), true);
file_put_contents('debug.log', "Input: " . print_r($input, true) . "\n", FILE_APPEND);

// Validasi input
if ($input === null) {
    file_put_contents('debug.log', "Error: JSON invalid\n", FILE_APPEND);
    echo json_encode(["success" => false, "message" => "Data JSON tidak valid"]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Method tidak diizinkan']);
    exit;
}

$kerjaan_uuid = $_POST['kerjaan_uuid'] ?? '';
$user_id = $_POST['user_id'] ?? '';

// Log values
file_put_contents('debug.log', "kerjaan_id: $kerjaan_id, user_id: $user_id\n", FILE_APPEND);

// Validasi data
if (empty($kerjaan_id) || empty($user_id)) {
    file_put_contents('debug.log', "Error: Data tidak lengkap\n", FILE_APPEND);
    echo json_encode(["success" => false, "message" => "Data tidak lengkap"]);
    exit;
}


try {
    // Dapatkan kerjaan_id dari uuid
    $stmt = $pdo->prepare("SELECT id FROM kerjaan WHERE uuid = ?");
    file_put_contents('debug.log', "Check SQL: $stmt\n", FILE_APPEND);
    
    $stmt->execute([$kerjaan_uuid]);
    $kerjaan = $stmt->fetch();
    
    if (!$kerjaan) {
        echo json_encode(['success' => false, 'message' => 'Pekerjaan tidak ditemukan']);
        exit;
    }
    
    $kerjaan_id = $kerjaan['id'];
    
    // Cek apakah pekerja sudah ada
    $stmt = $pdo->prepare("SELECT id FROM pekerja WHERE kerjaan_id = ? AND user_id = ?");
    $stmt->execute([$kerjaan_id, $user_id]);
    
    if ($stmt->fetch()) {
        echo json_encode(['success' => false, 'message' => 'Pekerja sudah ditambahkan']);
        exit;
    }
    
    // Simpan pekerja
    $stmt = $pdo->prepare("INSERT INTO pekerja ( kerjaan_id, user_id) VALUES (?, ?)");
    $stmt->execute([ $kerjaan_id, $user_id]);
    
    echo json_encode(['success' => true, 'message' => 'Pekerja berhasil ditambahkan']);
    
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
}
?>