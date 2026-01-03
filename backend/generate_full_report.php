<?php
require 'db_connect.php';

$week_id = isset($_GET['week_id']) ? intval($_GET['week_id']) : 0;

if ($week_id == 0) {
    echo json_encode(["status" => "error", "message" => "Missing week ID"]);
    exit;
}

$reports = [];
$sql = "SELECT
            b.name_bn as branch_name,
            b.sort_order,
            r.id as report_id,
            d.*,
            rec.*,
            lg.*
        FROM branches b
        LEFT JOIN report_submissions r ON b.id = r.branch_id AND r.week_id = $week_id
        LEFT JOIN data_deposits d ON r.id = d.report_id
        LEFT JOIN data_recovery rec ON r.id = rec.report_id
        LEFT JOIN data_loan_general lg ON r.id = lg.report_id
        ORDER BY b.sort_order ASC";

$result = $conn->query($sql);

while ($row = $result->fetch_assoc()) {
    $report_id = $row['report_id'];

    // Fetch sectors if report exists
    $sectors = [];
    if ($report_id) {
        $sql_sec = "SELECT sector_code, target, achv FROM data_loan_sectors WHERE report_id = $report_id";
        $res_sec = $conn->query($sql_sec);
        while ($s = $res_sec->fetch_assoc()) {
            $sectors[$s['sector_code']] = $s;
        }
    }

    $row['loan_sectors'] = $sectors;
    $reports[] = $row;
}

echo json_encode(["status" => "success", "data" => $reports]);
$conn->close();
?>
