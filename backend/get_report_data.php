<?php
require 'db_connect.php';

$branch_id = isset($_GET['branch_id']) ? intval($_GET['branch_id']) : 0;
$week_id = isset($_GET['week_id']) ? intval($_GET['week_id']) : 0;

if ($branch_id == 0 || $week_id == 0) {
    echo json_encode(["status" => "error", "message" => "Missing branch or week ID"]);
    exit;
}

// Check for existing submission
$sql_report = "SELECT id, status FROM report_submissions WHERE branch_id = $branch_id AND week_id = $week_id";
$res_report = $conn->query($sql_report);

$data = [
    "deposits" => null,
    "recovery" => null,
    "loan_sectors" => [],
    "loan_general" => null
];

if ($res_report->num_rows > 0) {
    $report = $res_report->fetch_assoc();
    $report_id = $report['id'];

    // Fetch Deposits
    $sql_dep = "SELECT * FROM data_deposits WHERE report_id = $report_id";
    $res_dep = $conn->query($sql_dep);
    if ($res_dep->num_rows > 0) $data["deposits"] = $res_dep->fetch_assoc();

    // Fetch Recovery
    $sql_rec = "SELECT * FROM data_recovery WHERE report_id = $report_id";
    $res_rec = $conn->query($sql_rec);
    if ($res_rec->num_rows > 0) $data["recovery"] = $res_rec->fetch_assoc();

    // Fetch Loan Sectors
    $sql_sec = "SELECT * FROM data_loan_sectors WHERE report_id = $report_id";
    $res_sec = $conn->query($sql_sec);
    while ($row = $res_sec->fetch_assoc()) {
        $data["loan_sectors"][] = $row;
    }

    // Fetch General Loan Info
    $sql_gen = "SELECT * FROM data_loan_general WHERE report_id = $report_id";
    $res_gen = $conn->query($sql_gen);
    if ($res_gen->num_rows > 0) $data["loan_general"] = $res_gen->fetch_assoc();
} else {
    // Logic for "Copy Previous" or Return Empty
    // For now returning empty, client can request "copy previous" explicitly
}

echo json_encode(["status" => "success", "data" => $data]);
$conn->close();
?>
