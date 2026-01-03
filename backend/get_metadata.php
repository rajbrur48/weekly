<?php
require 'db_connect.php';

$branches = [];
$sql_branches = "SELECT * FROM branches ORDER BY sort_order ASC";
$res_branches = $conn->query($sql_branches);
while ($row = $res_branches->fetch_assoc()) {
    $branches[] = $row;
}

$weeks = [];
$sql_weeks = "SELECT * FROM weeks ORDER BY id DESC";
$res_weeks = $conn->query($sql_weeks);
while ($row = $res_weeks->fetch_assoc()) {
    $weeks[] = $row;
}

echo json_encode([
    "status" => "success",
    "branches" => $branches,
    "weeks" => $weeks
]);

$conn->close();
?>
