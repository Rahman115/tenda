<?php
$mysqli = new mysqli("127.0.0.1", "root", "", "tenda");

$id = (int)$_GET['id'];
$stmt = $mysqli->prepare("SELECT * FROM pekerjaan WHERE id=?");
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
$job = $result->fetch_assoc();

header('Content-Type: application/json');
echo json_encode($job);
