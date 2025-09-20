<?php
$host = "127.0.0.1";
$user = "root";
$pass = "";
$db   = "tenda";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_errno) {
    http_response_code(500);
    echo json_encode(["error" => $conn->connect_error]);
    exit;
}

?>
