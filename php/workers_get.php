<?php
header('Content-Type: application/json');
include '../config.php';
// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Log debugging information
file_put_contents('debug.log', "=== " . date('Y-m-d H:i:s') . " ===\n", FILE_APPEND);

if (!isset($_GET['kerjaan_uuid'])) {
    echo json_encode(['success' => false, 'message' => 'UUID pekerjaan tidak diberikan']);
    exit;
}

$kerjaan_uuid = $_GET['kerjaan_uuid'];

$sql = "SELECT id FROM detail_kerjaan WHERE uuid = '$kerjaan_uuid'";
file_put_contents('debug.log', "Check SQL: $sql\n", FILE_APPEND);

$result = $conn->query($sql);

// Ambil id dari detail_kerjaan
$row_detail = $result->fetch_assoc();
$kerjaan_id = $row_detail['id'];
file_put_contents('debug.log', "kerjaan_id found: $kerjaan_id\n", FILE_APPEND);

$sql_join = "SELECT p.uuid, p.created_at, u.username, u.nama_lengkap, u.role 
            FROM pekerja p 
            JOIN users u ON p.user_id = u.id 
            JOIN detail_kerjaan k ON p.kerjaan_id = k.id 
            WHERE k.id = '$kerjaan_id'
            ORDER BY p.created_at DESC";
// '$kerjaan_id'
$result_join = $conn->query($sql_join);

// Ambil id dari detail_kerjaan
$workers = array();

while ($row = $result_join->fetch_assoc()){
  $workers[] = $row;
}
echo json_encode([
        'success' => true,
        'workers' => $workers
    ]);
/**
try {
    $sql_get = $conn->prepare("SELECT id FROM kerjaan WHERE uuid = ?");
    file_put_contents('debug.log', "SQL prepared for kerjaan lookup\n", FILE_APPEND);
    $sql_get->execute([$kerjaan_uuid]); // Perbaikan: hapus tanda $ dari variabel
    $kerjaan = $sql_get->fetch_assoc();
    
    if (!$kerjaan) {
        echo json_encode(['success' => false, 'message' => 'Pekerjaan tidak ditemukan']);
        exit;
    }
    
    $kerjaan_id = $kerjaan['id'];
    file_put_contents('debug.log', "Check ID: $kerjaan\n", FILE_APPEND);

    $sql = "SELECT p.uuid, p.created_at, u.username, u.nama_lengkap, u.role 
            FROM pekerja p 
            JOIN users u ON p.user_id = u.id 
            JOIN kerjaan k ON p.kerjaan_id = k.id 
            WHERE k.id = ? 
            ORDER BY p.created_at DESC";
    
    $stmt = $conn->prepare($sql);
    $stmt->execute([$kerjaan_id]); // Gunakan $kerjaan_id, bukan $kerjaan_uuid
    $workers = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'success' => true,
        'workers' => $workers
    ]);
} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Error: ' . $e->getMessage()
    ]);
}

**/
?>