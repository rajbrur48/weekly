CREATE DATABASE IF NOT EXISTS weekly_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE weekly_db;

-- Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Hash this in real app
    role ENUM('admin', 'branch_user') NOT NULL,
    branch_id INT NULL, -- NULL for admin
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Branches Table
CREATE TABLE branches (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_bn VARCHAR(100) NOT NULL, -- e.g. "ফেনী"
    code VARCHAR(20) NULL,
    sort_order INT DEFAULT 0
);

-- Weeks Table
CREATE TABLE weeks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    week_number VARCHAR(50) NOT NULL, -- e.g. "27th"
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Main Report Submission Table
CREATE TABLE report_submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    branch_id INT NOT NULL,
    week_id INT NOT NULL,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('draft', 'submitted', 'approved') DEFAULT 'draft',
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (week_id) REFERENCES weeks(id),
    UNIQUE KEY (branch_id, week_id)
);

-- 1. Deposit Data (Amanot)
CREATE TABLE data_deposits (
    report_id INT PRIMARY KEY,

    -- Deposit Collection (Amanot Songroho)
    june_balance DECIMAL(15,2) DEFAULT 0, -- June/25 Balance
    target_deposit DECIMAL(15,2) DEFAULT 0,
    achv_deposit DECIMAL(15,2) DEFAULT 0,
    achv_deposit_curr_week DECIMAL(15,2) DEFAULT 0,
    last_year_achv DECIMAL(15,2) DEFAULT 0,
    balance_deposit DECIMAL(15,2) DEFAULT 0, -- Amanoter Shiti

    -- New Accounts
    target_new_ac INT DEFAULT 0,
    achv_new_ac INT DEFAULT 0,

    -- 6 Attractive Schemes
    target_schemes INT DEFAULT 0,
    achv_schemes INT DEFAULT 0,

    FOREIGN KEY (report_id) REFERENCES report_submissions(id) ON DELETE CASCADE
);

-- 2. Loan Recovery Data (Rin Aday) - Detailed Part 1
CREATE TABLE data_recovery (
    report_id INT PRIMARY KEY,

    -- WCL 1
    wcl_1_target DECIMAL(15,2) DEFAULT 0,
    wcl_1_achv DECIMAL(15,2) DEFAULT 0,

    -- WCL 2
    wcl_2_target DECIMAL(15,2) DEFAULT 0,
    wcl_2_achv DECIMAL(15,2) DEFAULT 0,

    -- WCL 3
    wcl_3_target DECIMAL(15,2) DEFAULT 0,
    wcl_3_achv DECIMAL(15,2) DEFAULT 0,

    -- WCL 4
    wcl_4_target DECIMAL(15,2) DEFAULT 0,
    wcl_4_achv DECIMAL(15,2) DEFAULT 0,

    -- NCL
    ncl_target DECIMAL(15,2) DEFAULT 0,
    ncl_achv DECIMAL(15,2) DEFAULT 0,

    -- CL
    cl_target DECIMAL(15,2) DEFAULT 0,
    cl_achv DECIMAL(15,2) DEFAULT 0,

    -- Double Recovery
    double_recovery_achv DECIMAL(15,2) DEFAULT 0,

    -- Reschedule
    reschedule_target DECIMAL(15,2) DEFAULT 0,
    reschedule_achv DECIMAL(15,2) DEFAULT 0,

    -- Write-off (Oblopon)
    writeoff_target DECIMAL(15,2) DEFAULT 0,
    writeoff_balance DECIMAL(15,2) DEFAULT 0,

    -- 52 Suspense
    suspense_52_target DECIMAL(15,2) DEFAULT 0,
    suspense_52_achv DECIMAL(15,2) DEFAULT 0,

    -- Remittance
    remittance_target DECIMAL(15,2) DEFAULT 0,
    remittance_achv DECIMAL(15,2) DEFAULT 0,

    -- Outstanding (Onadayi)
    outstanding_target DECIMAL(15,2) DEFAULT 0,
    outstanding_balance DECIMAL(15,2) DEFAULT 0,

    FOREIGN KEY (report_id) REFERENCES report_submissions(id) ON DELETE CASCADE
);

-- 3. Loan Disbursement Sectors (Rin Bitoron) - Part 2 & 3
CREATE TABLE data_loan_sectors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    sector_code VARCHAR(50) NOT NULL, -- e.g. 'crop', 'fishery', 'sme'

    target DECIMAL(15,2) DEFAULT 0,
    achv DECIMAL(15,2) DEFAULT 0,

    FOREIGN KEY (report_id) REFERENCES report_submissions(id) ON DELETE CASCADE,
    UNIQUE KEY (report_id, sector_code)
);

-- 4. General Loan Info & Ratios
CREATE TABLE data_loan_general (
    report_id INT PRIMARY KEY,

    -- Borrowers
    borrowers_june_balance INT DEFAULT 0,
    borrowers_target INT DEFAULT 0,
    borrowers_curr INT DEFAULT 0,

    -- NCL Status Balance
    ncl_status_balance DECIMAL(15,2) DEFAULT 0,
    ncl_status_target DECIMAL(15,2) DEFAULT 0,

    -- Ratios
    ratio_deposit_balance DECIMAL(15,2) DEFAULT 0,
    ratio_loan_balance DECIMAL(15,2) DEFAULT 0,

    FOREIGN KEY (report_id) REFERENCES report_submissions(id) ON DELETE CASCADE
);

-- SEED DATA
INSERT INTO branches (name_bn, sort_order) VALUES
('ফেনী', 1), ('এবি হাট', 2), ('ফাজিলপুর', 3), ('মুক্ত বাজার', 4), ('ছাগলনাইয়া', 5),
('কুহুমা', 6), ('শুভপুর', 7), ('সোনাগাজী', 8), ('কুঠিরহাট', 9), ('দাগনভূঞা', 10),
('জায়লস্কর', 11), ('দুধমুখা', 12), ('কুরাইশ মুন্সী', 13), ('পরশুরাম', 14), ('বি.এম বাজার', 15),
('ফুলগাজী', 16), ('জিএমহাট', 17), ('আমজাদহাট', 18);

INSERT INTO users (username, password, role, branch_id) VALUES
('admin', 'admin123', 'admin', NULL),
('feni', '123456', 'branch_user', 1),
('ebihat', '123456', 'branch_user', 2);
-- Add more users as needed

INSERT INTO weeks (week_number, end_date) VALUES ('27th', '2025-12-31');
