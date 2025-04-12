<?php
session_start();
require_once 'auth_utils.php';


// Database config
$servername = "localhost"; // Use 127.0.0.1 instead of 'localhost' for reliability
$username = "root";             // Default XAMPP username
$password = "";                 // Default XAMPP password (blank)
$dbname = "farmwise";

$conn = new mysqli($host, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$error = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // $usernameOrEmail = trim($_POST['username_or_email']);
    $email = trim($_POST['email']);
    $password = $_POST['password'];

    $stmt = $conn->prepare("SELECT id, username, password_hash FROM users WHERE username = ? OR email = ?");
    $stmt->bind_param("ss", $usernameOrEmail, $usernameOrEmail);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($user = $result->fetch_assoc()) {
        if (verifyPassword($password, $user['password_hash'])) {
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['username'] = $user['username'];
            header("Location: dashboard.php");
        } else {
            $error = "Invalid password.";
        }
    } else {
        $error = "User not found.";
    }
    $stmt->close();
}
?>

<!-- This part shows error on login page -->
<?php if ($error): ?>
    <div class="error" style="color: red; padding: 10px;">
        <?= htmlspecialchars($error) ?>
    </div>
<?php endif; ?>
