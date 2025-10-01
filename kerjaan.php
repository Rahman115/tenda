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
ORDER BY tanggal DESC");

// WHERE status_pembayaran = 'no'

$jobs = [];
while ($row = $result->fetch_assoc()) {
    $jobs[] = $row;
}

header('Content-Type: application/json');
echo json_encode($jobs, JSON_PRETTY_PRINT);



?>
