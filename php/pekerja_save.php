<?php
header("Content-Type: application/json");

include "../config.php";

// Enable error reporting
error_reporting(E_ALL);
ini_set("display_errors", 1);

// Log debugging information
//file_put_contents('debug.log', "=== " . date('Y-m-d H:i:s') . " ===\n", FILE_APPEND);

// Ambil data dari POST request
$input = json_decode(file_get_contents("php://input"), true);
//file_put_contents('debug.log', "Input: " . print_r($input, true) . "\n", FILE_APPEND);

// Validasi input
if ($input === null) {
  //file_put_contents('debug.log', "Error: JSON invalid\n", FILE_APPEND);
  echo json_encode(["success" => false, "message" => "Data JSON tidak valid"]);
  exit();
}

$kerjaan_uuid = $conn->real_escape_string($input["kerjaan_uuid"]);
$user_id = $conn->real_escape_string($input["user_id"]);

// Log values
//file_put_contents('debug.log', "kerjaan_uuid: $kerjaan_uuid, user_id: $user_id\n", FILE_APPEND);

// Validasi data
if (empty($kerjaan_uuid) || empty($user_id)) {
  //file_put_contents('debug.log', "Error: Data tidak lengkap\n", FILE_APPEND);
  echo json_encode(["success" => false, "message" => "Data tidak lengkap"]);
  exit();
}

// Ambil id dari uuid detail_kerjaan
$sql_detail_kerjaan = "SELECT id FROM detail_kerjaan WHERE uuid = '$kerjaan_uuid'";
//file_put_contents('debug.log', "Check SQL: $sql_detail_kerjaan\n", FILE_APPEND);

$result_detail_kerjaan = $conn->query($sql_detail_kerjaan);

// Cek error query
if (!$result_detail_kerjaan) {
  $error_msg = "Query error: " . $conn->error;
  //file_put_contents("debug.log", "$error_msg\n", FILE_APPEND);
  echo json_encode(["success" => false, "message" => "Error sistem"]);
  exit();
}

// Cek apakah UUID ditemukan
if ($result_detail_kerjaan->num_rows === 0) {
  file_put_contents(
    "debug.log",
    "Error: UUID kerjaan tidak ditemukan\n",
    FILE_APPEND
  );
  echo json_encode([
    "success" => false,
    "message" => "Kerjaan tidak ditemukan",
  ]);
  exit();
}

// Ambil id dari detail_kerjaan
$row_detail = $result_detail_kerjaan->fetch_assoc();
$kerjaan_id = $row_detail["id"];
//file_put_contents("debug.log", "kerjaan_id found: $kerjaan_id\n", FILE_APPEND);

// Cek apakah user sudah terdaftar untuk kerjaan ini
$check_sql = "SELECT id FROM pekerja WHERE kerjaan_id = '$kerjaan_id' AND user_id = '$user_id'";
//file_put_contents("debug.log", "Check SQL: $check_sql\n", FILE_APPEND);

$check_result = $conn->query($check_sql);

// Cek error query
if (!$check_result) {
  $error_msg = "Query error: " . $conn->error;
  //file_put_contents("debug.log", "$error_msg\n", FILE_APPEND);
  echo json_encode(["success" => false, "message" => "Error sistem"]);
  exit();
}

if ($check_result->num_rows > 0) {
  //file_put_contents("debug.log", "Error: User sudah terdaftar\n", FILE_APPEND);
  echo json_encode([
    "success" => false,
    "message" => "User sudah terdaftar untuk kerjaan ini",
  ]);
  exit();
}

// Fungsi untuk generate UUID v4
function generateUUID()
{
  return sprintf(
    "%04x%04x-%04x-%04x-%04x-%04x%04x%04x",
    mt_rand(0, 0xffff),
    mt_rand(0, 0xffff),
    mt_rand(0, 0xffff),
    mt_rand(0, 0x0fff) | 0x4000,
    mt_rand(0, 0x3fff) | 0x8000,
    mt_rand(0, 0xffff),
    mt_rand(0, 0xffff),
    mt_rand(0, 0xffff)
  );
}

// Dalam kode insert
$uuid = generateUUID();
$sql = "INSERT INTO pekerja (uuid, kerjaan_id, user_id) VALUES ('$uuid', '$kerjaan_id', '$user_id')";

// Insert data pekerja baru
//file_put_contents("debug.log", "Insert SQL: $sql\n", FILE_APPEND);

if ($conn->query($sql) === true) {
  file_put_contents("debug.log", "Success: Data inserted\n", FILE_APPEND);
  echo json_encode([
    "success" => true,
    "message" => "Pekerja berhasil ditambahkan",
  ]);
} else {
  $error_msg = "Insert error: " . $conn->error;
  //file_put_contents("debug.log", "$error_msg\n", FILE_APPEND);
  echo json_encode([
    "success" => false,
    "message" => "Error: Terjadi kesalahan sistem",
  ]);
}

$conn->close();
?>
