# Roadmap & Technical Improvements

This document outlines recommended improvements for the **BKB Performance Manager** application to transition it from a functional prototype to a production-grade enterprise system.

## 1. Security Enhancements (Critical)

*   **Password Hashing:**
    *   **Current:** Plain text passwords are used for demonstration.
    *   **Improvement:** Use PHP's `password_hash()` to store passwords and `password_verify()` during login. (See `backend/generate_hash.php`).
*   **JWT Authentication:**
    *   **Current:** Basic user ID checking.
    *   **Improvement:** Implement JSON Web Tokens (JWT). Upon login, the server issues a token. The Flutter app sends this token in the `Authorization` header for every request (`submit_report`, `get_report`). This prevents unauthorized API access.
*   **SSL/HTTPS:**
    *   **Improvement:** Ensure the PHP server is hosted on HTTPS to encrypt data in transit.

## 2. Backend & Database

*   **Input Validation:**
    *   **Improvement:** Add server-side validation logic. For example, check if `Achievement <= Target` (optional warning) or ensure `Target > 0` before calculating percentages.
*   **Audit Logging:**
    *   **Improvement:** Create an `audit_logs` table (`user_id`, `action`, `timestamp`, `ip_address`). Log every time a user submits or updates a report.
*   **Database Indexing:**
    *   **Improvement:** Add indexes on `report_submissions(branch_id, week_id)` for faster query performance as data grows.

## 3. Frontend (Flutter) UX/UI

*   **Offline Support:**
    *   **Improvement:** Use a local database (like `sqflite` or `hive`). Allow Branch Managers to save a draft offline and sync when the internet is available.
*   **Dashboard Analytics:**
    *   **Improvement:** Add visual charts (using `fl_chart`) on the Dashboard to show:
        *   "Recovery Rate Trend" (Last 4 weeks).
        *   "Deposit Target vs Achievement" Pie chart.
*   **Biometric Login:**
    *   **Improvement:** Use `local_auth` package to allow login via Fingerprint/FaceID after the first successful password login.

## 4. Reporting Features

*   **Custom Date Ranges:**
    *   **Improvement:** Instead of just "Weeks", allow selecting a Start Date and End Date to generate a cumulative report.
*   **Region-wise Aggregation:**
    *   **Improvement:** If the app scales to multiple regions, add a "Super Admin" dashboard that aggregates data from all branches in a region.

## 5. DevOps & Deployment

*   **Docker:**
    *   **Improvement:** Create a `Dockerfile` for the PHP/Apache environment to ensure consistent deployment across servers.
*   **CI/CD:**
    *   **Improvement:** Set up GitHub Actions to automatically build the Flutter APK and run PHP unit tests on push.
