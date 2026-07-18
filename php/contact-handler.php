<?php
/**
 * WhiskedAway — Contact form handler
 * -----------------------------------------------------------------
 * Receives a JSON POST from js/app.js, validates it, and inserts a
 * row into contact_inquiries (see sql/00_public_site_schema.sql).
 *
 * This file NEVER touches events, invoices, payments, or any table
 * that stores pricing/financial data — the public site's only job is
 * to advertise and collect consultation requests.
 */

declare(strict_types=1);

header("Content-Type: application/json");

require_once __DIR__ . "/db-config.php";

function respond(int $statusCode, bool $success, string $message): void {
    http_response_code($statusCode);
    echo json_encode(["success" => $success, "message" => $message]);
    exit;
}

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    respond(405, false, "Method not allowed.");
}

$raw = file_get_contents("php://input");
$data = json_decode($raw, true);

if (!is_array($data)) {
    respond(400, false, "Invalid request body.");
}

// Honeypot: bots fill hidden fields, real visitors never do
if (!empty($data["website"])) {
    respond(200, true, "Thanks!"); // pretend success, do nothing
}

$name = trim((string)($data["name"] ?? ""));
$email = trim((string)($data["email"] ?? ""));
$phone = trim((string)($data["phone"] ?? ""));
$preferredPackage = trim((string)($data["preferred_package"] ?? ""));
$guestCountRaw = trim((string)($data["guest_count"] ?? ""));
$eventDateRaw = trim((string)($data["event_date"] ?? ""));
$message = trim((string)($data["message"] ?? ""));

if ($name === "" || $email === "" || $message === "") {
    respond(422, false, "Name, email, and message are required.");
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    respond(422, false, "Please provide a valid email address.");
}

if (mb_strlen($name) > 100 || mb_strlen($email) > 120 || mb_strlen($message) > 1000) {
    respond(422, false, "One of the fields is too long. Please shorten your message.");
}

$guestCount = null;
if ($guestCountRaw !== "") {
    if (!ctype_digit($guestCountRaw) || (int)$guestCountRaw <= 0) {
        respond(422, false, "Guest count must be a positive number.");
    }
    $guestCount = (int)$guestCountRaw;
}

$eventDate = null;
if ($eventDateRaw !== "") {
    $parsed = DateTime::createFromFormat("Y-m-d", $eventDateRaw);
    if (!$parsed) {
        respond(422, false, "Please provide a valid event date.");
    }
    $eventDate = $eventDateRaw;
}

try {
    $pdo = get_pdo_connection();

    $stmt = $pdo->prepare(
        "INSERT INTO contact_inquiries
            (name, email, phone, preferred_package, guest_count, event_date, message)
         VALUES
            (:name, :email, :phone, :preferred_package, :guest_count, :event_date, :message)"
    );

    $stmt->execute([
        ":name" => $name,
        ":email" => $email,
        ":phone" => $phone !== "" ? $phone : null,
        ":preferred_package" => $preferredPackage !== "" ? $preferredPackage : null,
        ":guest_count" => $guestCount,
        ":event_date" => $eventDate,
        ":message" => $message,
    ]);

    respond(200, true, "Thanks! We'll be in touch soon.");
} catch (Throwable $e) {
    error_log("WhiskedAway contact form error: " . $e->getMessage());
    respond(500, false, "We couldn't save your message right now. Please try again shortly.");
}
