<?php
require 'db_connect.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->username) || !isset($data->password)) {
    echo json_encode(["status" => "error", "message" => "Missing credentials"]);
    exit;
}

$username = $conn->real_escape_string($data->username);
$password = $data->password;

$stmt = $conn->prepare("SELECT * FROM users WHERE username = ?");
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();

    // In a real app, use password_verify($password, $user['password'])
    // For this demo, assuming the DB might have plain text or simple hashes.
    // We'll simulate a secure check:
    if ($password === $user['password']) {
        echo json_encode([
            "status" => "success",
            "user" => [
                "id" => $user['id'],
                "username" => $user['username'],
                "role" => $user['role'],
                "branch_id" => $user['branch_id']
            ]
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid password"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "User not found"]);
}

$stmt->close();
$conn->close();
?>
