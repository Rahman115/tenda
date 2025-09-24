<?php
header('Content-Type: application/json');
include 'config.php';

$uuid_kerjaan = $_GET['uuid_kerjaan'] ?? null;

if ($uuid_kerjaan) {
    // Dapatkan ID kerjaan berdasarkan UUID
    $stmt = $conn->prepare("SELECT id FROM kerjaan WHERE uuid = ?");
    $stmt->bind_param("s", $uuid_kerjaan);
    $stmt->execute();
    $result = $stmt->get_result();
    $kerjaan = $result->fetch_assoc();
    
    if ($kerjaan) {
        $id_kerjaan = $kerjaan['id'];
        $stmt = $conn->prepare("SELECT * FROM detail_kerjaan WHERE id_kerjaan = ?");
        $stmt->bind_param("s", $uuid_kerjaan);
        $stmt->execute();
        $result = $stmt->get_result();
        $orders = $result->fetch_all(MYSQLI_ASSOC);
        echo json_encode($orders);
    } else {
        echo json_encode([]);
    }
} else {
    echo json_encode([]);
}
?>