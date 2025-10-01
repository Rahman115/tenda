<?php

require ('config.php');

$result = $conn->query("SELECT 
    uuid,
    pengguna,
    lokasi,
    tanggal,
    status_pembayaran,
    created_at,
    updated_at 
FROM kerjaan 
WHERE status_pembayaran = 'no'
ORDER BY tanggal DESC");

$jobs = [];
while ($row = $result->fetch_assoc()) {
    $jobs[] = $row;
}

header('Content-Type: application/json');
echo json_encode($jobs, JSON_PRETTY_PRINT);



?>
