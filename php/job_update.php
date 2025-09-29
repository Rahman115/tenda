<?php
header('Content-Type: application/json');

include('../config_pdo.php');

if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    if (empty($data['uuid']) || empty($data['pengguna']) || empty($data['lokasi'])) {
        echo json_encode(['success' => false, 'message' => 'Data tidak lengkap']);
        exit;
    }
    
    try {
        $stmt = $pdo->prepare("UPDATE kerjaan SET pengguna = ?, lokasi = ?, status_pembayaran = ?, tanggal = ? WHERE uuid = ?");
        $stmt->execute([
            $data['pengguna'],
            $data['lokasi'],
            $data['status_pembayaran'],
            $data['tanggal'],
            $data['uuid']
        ]);
        
        echo json_encode(['success' => true, 'message' => 'Pekerjaan berhasil diupdate']);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method tidak diizinkan']);
}
?>