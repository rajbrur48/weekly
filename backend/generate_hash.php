<?php
// Utility script to generate secure password hashes
// Usage: http://localhost/backend/generate_hash.php?password=yourpassword

header("Content-Type: text/plain");

$password = $_GET['password'] ?? '123456';

echo "Password: " . $password . "\n";
echo "Hash: " . password_hash($password, PASSWORD_DEFAULT) . "\n";
echo "\n";
echo "SQL Update Command:\n";
echo "UPDATE users SET password = '" . password_hash($password, PASSWORD_DEFAULT) . "' WHERE username = 'target_user';";
?>
