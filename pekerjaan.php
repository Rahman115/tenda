<?php

require ('config.php');

$result = $conn->query("SELECT id, jumlah_orang, lokasi, jumlah_lokal, status, tanggal, created_at, updated_at FROM pekerjaan");

$jobs = [];
while ($row = $result->fetch_assoc()) {
    $jobs[] = $row;
}

header('Content-Type: application/json');
echo json_encode($jobs, JSON_PRETTY_PRINT);



?>
