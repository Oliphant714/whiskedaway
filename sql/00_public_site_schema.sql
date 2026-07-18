-- =====================================================================
-- WhiskedAway — Public Site Schema
-- 00_public_site_schema.sql
--
-- This is the ONLY schema the live marketing site (contact-handler.php)
-- connects to. It intentionally excludes every financial/back-office
-- table (events, invoices, payments, staff, etc.) from
-- sql/01_schema.sql — those tables model WhiskedAway's internal
-- operations database and are kept in this repo purely as reference /
-- coursework artifacts. The public site's only job is to advertise
-- the business and capture consultation requests, so this is the only
-- table it is allowed to write to.
--
-- Style follows the same conventions as 01_schema.sql (utf8mb4,
-- AUTO_INCREMENT PK, CHECK constraints, named constraints).
-- Target: MySQL 8.0+ / MariaDB 10.11+
-- =====================================================================

CREATE DATABASE IF NOT EXISTS whiskedaway_public
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE whiskedaway_public;

-- ---------------------------------------------------------------------
-- contact_inquiries
-- One row per website "Request a Consultation" form submission.
-- No pricing, invoice, or payment data is ever written here — guest
-- count and package interest are stored only so staff can prepare for
-- the consultation call, not to generate a bill.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS contact_inquiries (
    inquiry_id          INT AUTO_INCREMENT PRIMARY KEY,
    name                VARCHAR(100)  NOT NULL,
    email               VARCHAR(120)  NOT NULL,
    phone               VARCHAR(20)   NULL,
    preferred_package   VARCHAR(100)  NULL,
    guest_count         INT           NULL,
    event_date          DATE          NULL,
    message             VARCHAR(1000) NOT NULL,
    submitted_at        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status              VARCHAR(20)   NOT NULL DEFAULT 'New',
    CONSTRAINT chk_inquiries_status CHECK (status IN
        ('New','Contacted','Converted','Closed')),
    CONSTRAINT chk_inquiries_guests CHECK (guest_count IS NULL OR guest_count > 0)
);

-- Example: staff pulling this week's new leads.
-- SELECT * FROM contact_inquiries WHERE status = 'New' ORDER BY submitted_at DESC;
