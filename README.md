# BKB Performance Manager (Weekly)

A comprehensive mobile application for managing weekly performance reports for **Bangladesh Krishi Bank (BKB)** branches. Built with **Flutter** (Frontend), **PHP** (Backend), and **MySQL** (Database).

## Features

*   **Secure Authentication:** Branch-specific login.
*   **Data Entry:** organized tabs for Deposits, Loans (Sector-wise), and Recovery (WCL/NCL).
*   **Auto-Calculation:** Real-time percentage calculation.
*   **Reporting:** Detailed scrollable table view matching official bank formats.
*   **Export:** Generate **PDF** and **Excel (.xlsx)** reports directly from the app.
*   **Bengali UI:** Full native language support.

## Project Structure

*   `weekly_app/`: Flutter Mobile Application source code.
*   `backend/`: PHP API scripts (`login.php`, `submit_report.php`, etc.).
*   `database/`: MySQL Schema (`schema.sql`).

## Setup Instructions

### 1. Database Setup
1.  Create a MySQL database named `msrbmcom_weekly_db` (or update `backend/db_connect.php` with your own credentials).
2.  Import the schema:
    ```bash
    mysql -u [username] -p msrbmcom_weekly_db < database/schema.sql
    ```

### 2. Backend Setup
1.  Host the `backend/` folder on a PHP-enabled server (Apache/Nginx/XAMPP).
2.  Ensure `backend/db_connect.php` has the correct database credentials.
3.  **Testing:** Access `http://your-server-ip/backend/get_metadata.php` in a browser. You should see a JSON response with branches.

### 3. Flutter App Setup
1.  Navigate to the app directory:
    ```bash
    cd weekly_app
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  **Configure API URL:**
    *   Open `lib/services/api_service.dart`.
    *   Update `baseUrl` to point to your PHP server (e.g., `http://192.168.1.100/backend`).
    *   *Note: If using Android Emulator, use `http://10.0.2.2/backend`.*
4.  Run the app:
    ```bash
    flutter run
    ```

## Future Roadmap
See [IMPROVEMENTS.md](IMPROVEMENTS.md) for a detailed list of recommended security and feature enhancements.
