<?php
header('Content-Type: application/json');
include 'config.php';

// Enable error reporting untuk debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Log semua input yang diterima
file_put_contents('debug.log', "=== " . date('Y-m-d H:i:s') . " ===\n", FILE_APPEND);
file_put_contents('debug.log', "POST: " . print_r($_POST, true) . "\n", FILE_APPEND);
file_put_contents('debug.log', "GET: " . print_r($_GET, true) . "\n", FILE_APPEND);

try {
    // Validasi koneksi database
    if ($conn->connect_error) {
        throw new Exception('Database connection failed: ' . $conn->connect_error);
    }

    // Validasi input
    if (empty($_POST['id_kerjaan'])) {
        throw new Exception('ID Kerjaan is required');
    }

    $id_kerjaan = $conn->real_escape_string($_POST['id_kerjaan']);
    $jumlah_orang = isset($_POST['jumlah_orang']) ? (int)$_POST['jumlah_orang'] : 0;
    $jenis = isset($_POST['jenis']) ? $conn->real_escape_string($_POST['jenis']) : '';
    $jumlah_unit = isset($_POST['jumlah_unit']) ? (int)$_POST['jumlah_unit'] : 0;
    $status = isset($_POST['status']) ? $conn->real_escape_string($_POST['status']) : '';
    $tanggal = isset($_POST['tanggal']) ? $conn->real_escape_string($_POST['tanggal']) : date('Y-m-d');

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

    // Prepare statement
    $sql = "INSERT INTO detail_kerjaan (jumlah_orang, jenis, jumlah_unit, status, id_kerjaan, tanggal) VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);

    if (!$stmt) {
        throw new Exception('Prepare failed: ' . $conn->error);
    }

    // Bind parameters
    $stmt->bind_param("dsdsss", $jumlah_orang, $jenis, $jumlah_unit, $status, $id_kerjaan, $tanggal);

    if ($stmt->execute()) {
        $response = [
            'success' => true,
            'message' => 'Data berhasil disimpan',
            'insert_id' => $stmt->insert_id
        ];
    } else {
        throw new Exception('Execute failed: ' . $stmt->error);
    }

    $stmt->close();
    $conn->close();

    echo json_encode($response);

} catch (Exception $e) {
    // Log error
    file_put_contents('debug.log', "ERROR: " . $e->getMessage() . "\n", FILE_APPEND);
    
    $error_response = [
        'success' => false,
        'message' => $e->getMessage(),
        'debug' => [
            'post_data' => $_POST,
            'timestamp' => date('Y-m-d H:i:s')
        ]
    ];
    
    echo json_encode($error_response);
}
?>