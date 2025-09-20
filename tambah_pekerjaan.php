<?php

require ('config.php');


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $jumlah_orang = $_POST['jumlah_orang'];
    $lokasi = $_POST['lokasi'];
    $jumlah_lokal = $_POST['jumlah_lokal'];
    $status = $_POST['status'];
    $tanggal = $_POST['tanggal'];

    $stmt = $conn->prepare("INSERT INTO pekerjaan (jumlah_orang, lokasi, jumlah_lokal, status, tanggal) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("isiss", $jumlah_orang, $lokasi, $jumlah_lokal, $status, $tanggal);

    if ($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "Data berhasil ditambahkan"]);
    } else {
        echo json_encode(["success" => false, "message" => $stmt->error]);
    }
}
?>
