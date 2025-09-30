<?php 
header('Content-Type: application/json');
include '../config.php';

if (!isset($_GET['action'])) {
    echo json_encode(['success' => false, 'message' => 'List USER tidak diberikan']);
    exit;
}

$list = $_GET['action'];

// Log values
// file_put_contents('debug.log', "kerjaan_id: $jenis\n", FILE_APPEND);

  $sql = "select username, role from users where role = 'user'";
  
// Log values
// file_put_contents('debug.log', "kerjaan: $sql\n", FILE_APPEND);
    
  $result = $conn->query($sql);  
  
  $users = [];
while ($row = $result->fetch_assoc()) {
    $users[] = $row;
}
echo json_encode($users, JSON_PRETTY_PRINT);

?>