<?php
/**
 * WhiskedAway — database connection
 * -----------------------------------------------------------------
 * Reads credentials from environment variables so nothing sensitive
 * is committed to the repo (see .env.example / .gitignore, which
 * already excludes .env). Connects ONLY to whiskedaway_public —
 * never point this at the internal "whiskedaway" ops database.
 */

declare(strict_types=1);

function get_pdo_connection(): PDO {
    $host = getenv("DB_HOST") ?: "127.0.0.1";
    $port = getenv("DB_PORT") ?: "3306";
    $name = getenv("DB_NAME") ?: "whiskedaway_public";
    $user = getenv("DB_USER") ?: "whiskedaway_app";
    $pass = getenv("DB_PASS") ?: "";

    $dsn = "mysql:host={$host};port={$port};dbname={$name};charset=utf8mb4";

    return new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);
}
