<?php 
header('Content-Type: application/json');
include '../config.php';

if (!isset($_GET['kerjaan_jenis'])) {
    echo json_encode(['success' => false, 'message' => 'Jenis pekerjaan tidak diberikan']);
    exit;
}

$jenis = $_GET['kerjaan_jenis'];

// Log values
// file_put_contents('debug.log', "kerjaan_id: $jenis\n", FILE_APPEND);

  $sql = "SELECT SUM(d.jumlah_unit) as total_jumlah_unit
FROM kerjaan AS k 
LEFT JOIN detail_kerjaan AS d 
    ON k.uuid = d.id_kerjaan 
    AND d.jenis = '$jenis' 
    AND d.status = 'ps'";
    

    
// Log values
// file_put_contents('debug.log', "kerjaan: $sql\n", FILE_APPEND);
    
  $result = $conn->query($sql);  
  
  $jobs = [];
while ($row = $result->fetch_assoc()) {
    $jobs[] = $row;
}

echo json_encode($jobs, JSON_PRETTY_PRINT);


/**

$result = $conn->query("SELECT SUM(d.jumlah_unit) as total_jumlah_unit
FROM kerjaan AS k 
LEFT JOIN detail_kerjaan AS d 
    ON k.uuid = d.id_kerjaan 
    AND d.jenis = ? 
    AND d.status = 'ps'");

$jobs = [];
while ($row = $result->fetch_assoc()) {
    $jobs[] = $row;
}

echo json_encode($jobs, JSON_PRETTY_PRINT);

**/
?>