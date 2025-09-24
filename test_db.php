<?php
header('Content-Type: text/plain');

$servername = "127.0.0.1";
$username = "root";
$password = "";
$dbname = "tenda";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo "Connection failed: " . $conn->connect_error;
} else {
    echo "Connection successful!";
    
    // Test query
    $result = $conn->query("SHOW TABLES LIKE 'detail_kerjaan'");
    if ($result->num_rows > 0) {
        echo "\nTable detail_kerjaan exists!";
    } else {
        echo "\nTable detail_kerjaan does NOT exist!";
    }
}

$conn->close();
?>