<?php
require 'db_connect.php';

$input = json_decode(file_get_contents("php://input"), true);

$branch_id = $input['branch_id'] ?? 0;
$week_id = $input['week_id'] ?? 0;
$data = $input['data'] ?? [];

if (!$branch_id || !$week_id) {
    echo json_encode(["status" => "error", "message" => "Invalid ID"]);
    exit;
}

$conn->begin_transaction();

try {
    // 1. Get or Create Report ID
    $stmt_check = $conn->prepare("SELECT id FROM report_submissions WHERE branch_id = ? AND week_id = ?");
    $stmt_check->bind_param("ii", $branch_id, $week_id);
    $stmt_check->execute();
    $result = $stmt_check->get_result();

    if ($result->num_rows > 0) {
        $report_id = $result->fetch_assoc()['id'];
        $stmt_check->close();
    } else {
        $stmt_check->close();
        $stmt_ins = $conn->prepare("INSERT INTO report_submissions (branch_id, week_id, status) VALUES (?, ?, 'submitted')");
        $stmt_ins->bind_param("ii", $branch_id, $week_id);
        $stmt_ins->execute();
        $report_id = $stmt_ins->insert_id;
        $stmt_ins->close();
    }

    // 2. Insert/Update Deposits
    $dep = $data['deposits'];
    $conn->query("DELETE FROM data_deposits WHERE report_id = $report_id");

    $stmt_dep = $conn->prepare("INSERT INTO data_deposits
    (report_id, june_balance, target_deposit, achv_deposit, achv_deposit_curr_week, last_year_achv, balance_deposit,
     target_new_ac, achv_new_ac, target_schemes, achv_schemes)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

    $stmt_dep->bind_param("iddddddiiii",
        $report_id,
        $dep['june_balance'], $dep['target_deposit'], $dep['achv_deposit'], $dep['achv_deposit_curr_week'],
        $dep['last_year_achv'], $dep['balance_deposit'],
        $dep['target_new_ac'], $dep['achv_new_ac'], $dep['target_schemes'], $dep['achv_schemes']
    );
    $stmt_dep->execute();
    $stmt_dep->close();

    // 3. Insert/Update Recovery
    $rec = $data['recovery'];
    $conn->query("DELETE FROM data_recovery WHERE report_id = $report_id");

    $stmt_rec = $conn->prepare("INSERT INTO data_recovery
    (report_id, wcl_1_target, wcl_1_achv, wcl_2_target, wcl_2_achv, wcl_3_target, wcl_3_achv, wcl_4_target, wcl_4_achv,
     ncl_target, ncl_achv, cl_target, cl_achv, double_recovery_achv, reschedule_target, reschedule_achv,
     writeoff_target, writeoff_balance, suspense_52_target, suspense_52_achv, remittance_target, remittance_achv,
     outstanding_target, outstanding_balance)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

    $stmt_rec->bind_param("iddddddddddddddddddddddd",
        $report_id,
        $rec['wcl_1_target'], $rec['wcl_1_achv'], $rec['wcl_2_target'], $rec['wcl_2_achv'],
        $rec['wcl_3_target'], $rec['wcl_3_achv'], $rec['wcl_4_target'], $rec['wcl_4_achv'],
        $rec['ncl_target'], $rec['ncl_achv'], $rec['cl_target'], $rec['cl_achv'],
        $rec['double_recovery_achv'], $rec['reschedule_target'], $rec['reschedule_achv'],
        $rec['writeoff_target'], $rec['writeoff_balance'],
        $rec['suspense_52_target'], $rec['suspense_52_achv'],
        $rec['remittance_target'], $rec['remittance_achv'],
        $rec['outstanding_target'], $rec['outstanding_balance']
    );
    $stmt_rec->execute();
    $stmt_rec->close();

    // 4. Insert/Update Loan Sectors
    $sectors = $data['loan_sectors']; // Array
    $conn->query("DELETE FROM data_loan_sectors WHERE report_id = $report_id");

    $stmt_sec = $conn->prepare("INSERT INTO data_loan_sectors (report_id, sector_code, target, achv) VALUES (?, ?, ?, ?)");
    foreach ($sectors as $s) {
        $stmt_sec->bind_param("isdd", $report_id, $s['sector_code'], $s['target'], $s['achv']);
        $stmt_sec->execute();
    }
    $stmt_sec->close();

    // 5. Insert/Update General Loan Info
    $gen = $data['loan_general'];
    $conn->query("DELETE FROM data_loan_general WHERE report_id = $report_id");

    $stmt_gen = $conn->prepare("INSERT INTO data_loan_general
    (report_id, borrowers_june_balance, borrowers_target, borrowers_curr, ncl_status_balance, ncl_status_target,
     ratio_deposit_balance, ratio_loan_balance)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

    $stmt_gen->bind_param("iiiidddd",
        $report_id,
        $gen['borrowers_june_balance'], $gen['borrowers_target'], $gen['borrowers_curr'],
        $gen['ncl_status_balance'], $gen['ncl_status_target'],
        $gen['ratio_deposit_balance'], $gen['ratio_loan_balance']
    );
    $stmt_gen->execute();
    $stmt_gen->close();

    $conn->commit();
    echo json_encode(["status" => "success", "message" => "Report saved successfully"]);

} catch (Exception $e) {
    $conn->rollback();
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}

$conn->close();
?>
