<?php

require ('config.php');

$result = $conn->query("SELECT id, username, nama_lengkap, role, created_at FROM users WHERE role = 'user'");

//$m = $result->bind_params("s", "user");
//$result->execute();
//$user = $result->get_result();
//var_dump($m);

$users = [];
while ($row = $result->fetch_assoc()) {
    $users[] = $row;
}

header('Content-Type: application/json');
echo json_encode($users, JSON_PRETTY_PRINT);
$conn->close();




?>
