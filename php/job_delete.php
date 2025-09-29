<?php
header('Content-Type: application/json');

include('../config_pdo.php');

if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $uuid = $_GET['uuid'] ?? '';
    
    if (empty($uuid)) {
        echo json_encode(['success' => false, 'message' => 'UUID tidak valid']);
        exit;
    }
    
    try {
        // Hapus orders terkait terlebih dahulu (jika ada foreign key constraint)
        $stmt = $pdo->prepare("DELETE FROM detail_kerjaan WHERE id_kerjaan = ?");
        $stmt->execute([$uuid]);
        
        // Hapus pekerjaan
        $stmt = $pdo->prepare("DELETE FROM kerjaan WHERE uuid = ?");
        $stmt->execute([$uuid]);
        
        echo json_encode(['success' => true, 'message' => 'Pekerjaan berhasil dihapus']);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method tidak diizinkan']);
}
?>