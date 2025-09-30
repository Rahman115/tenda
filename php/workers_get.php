<?php
header('Content-Type: application/json');
include '../config.php';

if (!isset($_GET['kerjaan_uuid'])) {
    echo json_encode(['success' => false, 'message' => 'UUID pekerjaan tidak diberikan']);
    exit;
}

$kerjaan_uuid = $_GET['kerjaan_uuid'];

try {
    $sql = "SELECT p.uuid, p.created_at, u.username, u.nama_lengkap, u.role 
            FROM pekerja p 
            JOIN users u ON p.user_id = u.id 
            JOIN kerjaan k ON p.kerjaan_id = k.id 
            WHERE k.uuid = ? 
            ORDER BY p.created_at DESC";
    
    $stmt = $conn->prepare($sql);
    $stmt->execute([$kerjaan_uuid]);
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
?>