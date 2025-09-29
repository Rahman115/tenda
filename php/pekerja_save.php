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

$kerjaan_id = $conn->real_escape_string($input['kerjaan_id']);
$user_id = $conn->real_escape_string($input['user_id']);

// Log values
file_put_contents('debug.log', "kerjaan_id: $kerjaan_id, user_id: $user_id\n", FILE_APPEND);

// Validasi data
if (empty($kerjaan_id) || empty($user_id)) {
    file_put_contents('debug.log', "Error: Data tidak lengkap\n", FILE_APPEND);
    echo json_encode(["success" => false, "message" => "Data tidak lengkap"]);
    exit;
}

// DEBUG: Tampilkan query di log
$check_sql = "SELECT id FROM pekerja WHERE kerjaan_id = '$kerjaan_id' AND user_id = '$user_id'";
file_put_contents('debug.log', "Check SQL: $check_sql\n", FILE_APPEND);

$check_result = $conn->query($check_sql);

// DEBUG: Cek error query
if (!$check_result) {
    $error_msg = "Query error: " . $conn->error;
    file_put_contents('debug.log', "$error_msg\n", FILE_APPEND);
    echo json_encode(["success" => false, "message" => "Error sistem"]);
    exit;
}

if ($check_result->num_rows > 0) {
    file_put_contents('debug.log', "Error: User sudah terdaftar\n", FILE_APPEND);
    echo json_encode(["success" => false, "message" => "User sudah terdaftar untuk kerjaan ini"]);
    exit;
}

// DEBUG: Tampilkan query INSERT di log
$sql = "INSERT INTO pekerja (kerjaan_id, user_id) VALUES ('$kerjaan_id', '$user_id')";
file_put_contents('debug.log', "Insert SQL: $sql\n", FILE_APPEND);

if ($conn->query($sql) === TRUE) {
    file_put_contents('debug.log', "Success: Data inserted\n", FILE_APPEND);
    echo json_encode(["success" => true, "message" => "Pekerja berhasil ditambahkan"]);
} else {
    $error_msg = "Insert error: " . $conn->error;
    file_put_contents('debug.log', "$error_msg\n", FILE_APPEND);
    echo json_encode(["success" => false, "message" => "Error: Terjadi kesalahan sistem"]);
}

$conn->close();
?>