<?php

require ('config.php');

    $pekerjaan_id = (int)($_GET['id'] ?? 0);
    
    $pek = $conn->prepare("SELECT * FROM pekerjaan WHERE id = ?");
    $pek->bind_param("i", $pekerjaan_id);
    $pek->execute();
    $job = $pek->get_result()->fetch_assoc();
    
    $stmt = $conn->prepare("
        SELECT u.username
        FROM users u
        JOIN jobs j ON u.id = j.user_id
        WHERE j.pekerjaan_id = ?
    ");
    $stmt->bind_param("i", $pekerjaan_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $workers = [];
    while ($row = $result->fetch_assoc()) {
        $workers[] = $row;
    }
    
    $job['pekerja'] = $workers;
    echo json_encode($job);


?>
