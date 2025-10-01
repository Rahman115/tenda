<?php
header("Content-Type: application/json");

// koneksi MariaDB
include('../config.php');

// Enable error reporting untuk debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Log semua input yang diterima
file_put_contents('debug.log', "=== " . date('Y-m-d H:i:s') . " ===\n", FILE_APPEND);
file_put_contents('debug.log', "POST: " . print_r($_POST, true) . "\n", FILE_APPEND);
file_put_contents('debug.log', "GET: " . print_r($_GET, true) . "\n", FILE_APPEND);

// ambil data dari POST
$id_kerjaan   = $_POST['id_kerjaan'] ?? '';
$jenis        = $_POST['jenis'] ?? '';
$jumlah_unit  = $_POST['jumlah_unit'] ?? 0;
$status       = $_POST['status'] ?? '';
$jumlah_orang = $_POST['jumlah_orang'] ?? 0;
$tanggal      = $_POST['tanggal'] ?? '';

// Debug data yang akan disimpan
    $debug_data = [
        'id_kerjaan' => $id_kerjaan,
        'jumlah_orang' => $jumlah_orang,
        'jenis' => $jenis,
        'jumlah_unit' => $jumlah_unit,
        'status' => $status,
        'tanggal' => $tanggal
    ];
    
    file_put_contents('debug.log', "Processed data: " . print_r($debug_data, true) . "\n", FILE_APPEND);


// validasi singkat
if ($id_kerjaan === '' || $jenis === '' || $status === '' || $tanggal === '') {
    echo json_encode(["success" => false, "message" => "Data tidak lengkap"]);
    exit;
}

// cek apakah sudah ada di detail_kerjaan
$stmt = $conn->prepare("SELECT id FROM detail_kerjaan WHERE id_kerjaan=? AND jenis=? AND tanggal=?");
$stmt->bind_param("sss", $id_kerjaan, $jenis, $tanggal);
$stmt->execute();
$res = $stmt->get_result();

if ($res->num_rows > 0) {
    // update
    $row = $res->fetch_assoc();
    $update = $conn->prepare("UPDATE detail_kerjaan 
        SET jumlah_unit=?, status=?, jumlah_orang=?, tanggal=? 
        WHERE id=?");
    $update->bind_param("dsisi", $jumlah_unit, $status, $jumlah_orang, $tanggal, $row['id']);
    $update->execute();
    $update->close();
    echo json_encode(["success" => true, "message" => "Data diupdate"]);
} else {
    // insert baru
    $insert = $conn->prepare("INSERT INTO detail_kerjaan 
        (id_kerjaan, jenis, jumlah_unit, status, jumlah_orang, tanggal) 
        VALUES (?,?,?,?,?,?)");
    $insert->bind_param("ssdsis", $id_kerjaan, $jenis, $jumlah_unit, $status, $jumlah_orang, $tanggal);
    $insert->execute();
    $insert->close();
    echo json_encode(["success" => true, "message" => "Data ditambahkan"]);
}

$stmt->close();
$conn->close();

?>