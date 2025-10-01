<?php 
header('Content-Type: application/json');
include '../config.php';

if (!isset($_GET['action'])) {
    echo json_encode(['success' => false, 'message' => 'Jenis pekerjaan tidak diberikan']);
    exit;
}

$action = $_GET['action'];
$jenis = $_GET['jenis'];

// Log values
// file_put_contents('debug.log', "kerjaan_id: $jenis\n", FILE_APPEND);

  $sql = "SELECT k.pengguna, k.lokasi, d.tanggal, 
  CONVERT(d.jumlah_unit, SIGNED) as jumlah_unit
          FROM kerjaan AS k 
          INNER JOIN detail_kerjaan AS d 
          ON k.uuid = d.id_kerjaan 
          WHERE d.jenis = '$jenis' 
          AND d.status = 'ps'
          AND d.jumlah_unit IS NOT NULL
          ORDER BY d.tanggal DESC";
    
// Log values
// file_put_contents('debug.log', "kerjaan: $sql\n", FILE_APPEND);
    
  $result = $conn->query($sql);  
  
  $jobs = [];
while ($row = $result->fetch_assoc()) {
    $jobs[] = $row;
}

echo json_encode($jobs, JSON_PRETTY_PRINT);

?>