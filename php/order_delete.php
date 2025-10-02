<?php
header("Content-Type: application/json");

include "../config.php";

// Enable error reporting
error_reporting(E_ALL);
ini_set("display_errors", 1);

// Log debugging information
file_put_contents(
  "debug.log",
  "Date :" . date("Y-m-d H:i:s") . " ===\n",
  FILE_APPEND
);
if ($_SERVER["REQUEST_METHOD"] === "DELETE") {
  $uuid = $_GET["uuid"] ?? "";
  // Log values
  file_put_contents("debug.log", "cek uuid : $uuid\n", FILE_APPEND);
  if (empty($uuid)) {
    echo json_encode(["success" => false, "message" => "UUID tidak valid"]);
    exit();
  }

  try {
    // Ambil id dari uuid detail_kerjaan
    $sql_detail_kerjaan = "SELECT id FROM detail_kerjaan WHERE uuid = '$uuid'";

    $result_detail_kerjaan = $conn->query($sql_detail_kerjaan);

    // Cek error query
    if (!$result_detail_kerjaan) {
      $error_msg = "Query error: " . $conn->error;

      echo json_encode(["success" => false, "message" => "Error sistem"]);
      exit();
    }

    // Cek apakah UUID ditemukan
    if ($result_detail_kerjaan->num_rows === 0) {
      echo json_encode([
        "success" => false,
        "message" => "Kerjaan tidak ditemukan",
      ]);
      exit();
    }

    // Ambil id dari detail_kerjaan
    $row_detail = $result_detail_kerjaan->fetch_assoc();
    $kerjaan_id = $row_detail["id"];
    file_put_contents(
      "debug.log",
      "kerjaan_id found: $kerjaan_id\n",
      FILE_APPEND
    );
    // mengecek Pekerja
    $sql_select_pekerja = "select id from pekerja where kerjaan_id = '$kerjaan_id'";
    $result_pekerja = $conn->query($sql_select_pekerja);

    // Cek error query
    if (!$result_pekerja) {
      $error_msg = "Query error: " . $conn->error;
      file_put_contents("debug.log", "$error_msg\n", FILE_APPEND);
      echo json_encode(["success" => false, "message" => "Error sistem"]);
      exit();
    }

    $num_rows_pekerja = $result_pekerja->num_rows;
    $sql_delete_detail_kerjaan = "delete from detail_kerjaan where id = '$kerjaan_id'";
    if ($num_rows_pekerja > 0) {
      $sql_delete_pekerja = "delete from pekerja where kerjaan_id = '$kerjaan_id'";
      $result_del_pekerja = $conn->query($sql_delete_pekerja);
      $result_del = $conn->query($sql_delete_detail_kerjaan);
      if ($result_del) {
        echo json_encode([
          "success" => true,
          "message" => "Pekerjaan berhasil dihapus",
        ]);
      }
    } else {
      $result_del = $conn->query($sql_delete_detail_kerjaan);
      if ($result_del) {
        echo json_encode([
          "success" => true,
          "message" => "Pekerjaan berhasil dihapus",
        ]);
      }
    }
  } catch (PDOException $e) {
    echo json_encode([
      "success" => false,
      "message" => "Error: " . $e->getMessage(),
    ]);
  }
} else {
  echo json_encode(["success" => false, "message" => "Method tidak diizinkan"]);
}
?>
