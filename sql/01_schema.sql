-- =====================================================================
-- WhiskedAway Wedding Catering Database
-- 01_schema.sql
-- Creates all tables, primary keys, foreign keys, and integrity
-- constraints (NOT NULL, UNIQUE, CHECK) for the WhiskedAway platform.
-- Target: MySQL 8.0+ (MySQL Workbench)
-- =====================================================================

DROP DATABASE IF EXISTS whiskedaway;
CREATE DATABASE whiskedaway CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE whiskedaway;

-- ---------------------------------------------------------------------
-- 1. customers
-- Engaged couples / clients who inquire about or book catering.
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    customer_id     INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    email           VARCHAR(120) NOT NULL,
    phone           VARCHAR(20)  NOT NULL,
    created_at      DATE         NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT uq_customers_email UNIQUE (email)
);

-- ---------------------------------------------------------------------
-- 2. venues
-- Reception locations WhiskedAway caters at.
-- ---------------------------------------------------------------------
CREATE TABLE venues (
    venue_id        INT AUTO_INCREMENT PRIMARY KEY,
    venue_name      VARCHAR(100) NOT NULL,
    address         VARCHAR(150) NOT NULL,
    city            VARCHAR(60)  NOT NULL,
    state           VARCHAR(2)   NOT NULL,
    zip_code        VARCHAR(10)  NOT NULL,
    capacity        INT          NOT NULL,
    contact_phone   VARCHAR(20),
    CONSTRAINT chk_venues_capacity CHECK (capacity > 0)
);

-- ---------------------------------------------------------------------
-- 3. menu_categories
-- Groups dishes (appetizers, mains, desserts, etc.)
-- ---------------------------------------------------------------------
CREATE TABLE menu_categories (
    category_id     INT AUTO_INCREMENT PRIMARY KEY,
    category_name   VARCHAR(50) NOT NULL,
    description     VARCHAR(255),
    CONSTRAINT uq_menu_categories_name UNIQUE (category_name)
);

-- ---------------------------------------------------------------------
-- 4. menu_items
-- Individual dishes offered, tied to a category.
-- ---------------------------------------------------------------------
CREATE TABLE menu_items (
    item_id         INT AUTO_INCREMENT PRIMARY KEY,
    category_id     INT NOT NULL,
    item_name       VARCHAR(100) NOT NULL,
    description     VARCHAR(255),
    unit_cost       DECIMAL(8,2) NOT NULL,
    is_vegetarian   TINYINT(1)   NOT NULL DEFAULT 0,
    is_active       TINYINT(1)   NOT NULL DEFAULT 1,
    CONSTRAINT fk_menuitems_category FOREIGN KEY (category_id)
        REFERENCES menu_categories(category_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_menuitems_cost CHECK (unit_cost >= 0)
);

-- ---------------------------------------------------------------------
-- 5. package_tiers
-- Catering package levels (Silver/Gold/Platinum) with per-guest pricing.
-- ---------------------------------------------------------------------
CREATE TABLE package_tiers (
    package_id      INT AUTO_INCREMENT PRIMARY KEY,
    package_name    VARCHAR(50)  NOT NULL,
    price_per_guest DECIMAL(8,2) NOT NULL,
    min_guests      INT          NOT NULL,
    description     VARCHAR(255),
    CONSTRAINT uq_package_tiers_name UNIQUE (package_name),
    CONSTRAINT chk_package_price CHECK (price_per_guest > 0),
    CONSTRAINT chk_package_min_guests CHECK (min_guests > 0)
);

-- ---------------------------------------------------------------------
-- 6. package_menu_items  (junction: package_tiers <-> menu_items, M:N)
-- ---------------------------------------------------------------------
CREATE TABLE package_menu_items (
    package_id      INT NOT NULL,
    item_id         INT NOT NULL,
    PRIMARY KEY (package_id, item_id),
    CONSTRAINT fk_pmi_package FOREIGN KEY (package_id)
        REFERENCES package_tiers(package_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pmi_item FOREIGN KEY (item_id)
        REFERENCES menu_items(item_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------------------
-- 7. events
-- Central table: one row per wedding/event booking.
-- ---------------------------------------------------------------------
CREATE TABLE events (
    event_id        INT AUTO_INCREMENT PRIMARY KEY,
    customer_id     INT  NOT NULL,
    venue_id        INT  NOT NULL,
    package_id      INT  NOT NULL,
    event_date      DATE NOT NULL,
    guest_count     INT  NOT NULL,
    event_status    VARCHAR(20) NOT NULL DEFAULT 'Inquiry',
    total_price     DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_events_customer FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_events_venue FOREIGN KEY (venue_id)
        REFERENCES venues(venue_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_events_package FOREIGN KEY (package_id)
        REFERENCES package_tiers(package_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_events_guests CHECK (guest_count > 0),
    CONSTRAINT chk_events_price CHECK (total_price >= 0),
    CONSTRAINT chk_events_status CHECK (event_status IN
        ('Inquiry','Booked','Confirmed','Completed','Cancelled'))
);

-- ---------------------------------------------------------------------
-- 8. add_ons
-- Optional extra services available to attach to an event.
-- ---------------------------------------------------------------------
CREATE TABLE add_ons (
    addon_id        INT AUTO_INCREMENT PRIMARY KEY,
    addon_name      VARCHAR(100) NOT NULL,
    description     VARCHAR(255),
    price           DECIMAL(8,2) NOT NULL,
    is_active       TINYINT(1)   NOT NULL DEFAULT 1,
    CONSTRAINT uq_addons_name UNIQUE (addon_name),
    CONSTRAINT chk_addons_price CHECK (price >= 0)
);

-- ---------------------------------------------------------------------
-- 9. event_addons  (junction: events <-> add_ons, M:N)
-- ---------------------------------------------------------------------
CREATE TABLE event_addons (
    event_addon_id  INT AUTO_INCREMENT PRIMARY KEY,
    event_id        INT NOT NULL,
    addon_id        INT NOT NULL,
    quantity        INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_eventaddons_event FOREIGN KEY (event_id)
        REFERENCES events(event_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_eventaddons_addon FOREIGN KEY (addon_id)
        REFERENCES add_ons(addon_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_event_addon UNIQUE (event_id, addon_id),
    CONSTRAINT chk_eventaddons_qty CHECK (quantity > 0)
);

-- ---------------------------------------------------------------------
-- 10. staff
-- Catering employees (chefs, servers, coordinators).
-- ---------------------------------------------------------------------
CREATE TABLE staff (
    staff_id        INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    role            VARCHAR(40) NOT NULL,
    hourly_rate     DECIMAL(6,2) NOT NULL,
    phone           VARCHAR(20),
    email           VARCHAR(120) NOT NULL,
    CONSTRAINT uq_staff_email UNIQUE (email),
    CONSTRAINT chk_staff_rate CHECK (hourly_rate >= 0)
);

-- ---------------------------------------------------------------------
-- 11. event_staff_assignments  (junction: events <-> staff, M:N)
-- ---------------------------------------------------------------------
CREATE TABLE event_staff_assignments (
    assignment_id   INT AUTO_INCREMENT PRIMARY KEY,
    event_id        INT NOT NULL,
    staff_id        INT NOT NULL,
    role_on_event   VARCHAR(40) NOT NULL,
    hours_worked    DECIMAL(5,2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_esa_event FOREIGN KEY (event_id)
        REFERENCES events(event_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_esa_staff FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_event_staff UNIQUE (event_id, staff_id),
    CONSTRAINT chk_esa_hours CHECK (hours_worked >= 0)
);

-- ---------------------------------------------------------------------
-- 12. invoices
-- One billing record per event.
-- ---------------------------------------------------------------------
CREATE TABLE invoices (
    invoice_id      INT AUTO_INCREMENT PRIMARY KEY,
    event_id        INT NOT NULL,
    invoice_date    DATE NOT NULL,
    due_date        DATE NOT NULL,
    amount_due      DECIMAL(10,2) NOT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'Pending',
    CONSTRAINT fk_invoices_event FOREIGN KEY (event_id)
        REFERENCES events(event_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_invoices_event UNIQUE (event_id),
    CONSTRAINT chk_invoices_amount CHECK (amount_due >= 0),
    CONSTRAINT chk_invoices_status CHECK (status IN
        ('Pending','Paid','Overdue','Cancelled')),
    CONSTRAINT chk_invoices_dates CHECK (due_date >= invoice_date)
);

-- ---------------------------------------------------------------------
-- 13. payments
-- Individual payments applied against an invoice.
-- ---------------------------------------------------------------------
CREATE TABLE payments (
    payment_id      INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id      INT NOT NULL,
    payment_date    DATE NOT NULL,
    amount          DECIMAL(10,2) NOT NULL,
    payment_method  VARCHAR(20) NOT NULL,
    CONSTRAINT fk_payments_invoice FOREIGN KEY (invoice_id)
        REFERENCES invoices(invoice_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_payments_amount CHECK (amount > 0),
    CONSTRAINT chk_payments_method CHECK (payment_method IN
        ('Credit Card','Debit Card','Cash','Check','Bank Transfer'))
);

-- ---------------------------------------------------------------------
-- 14. contact_inquiries
-- Website contact-form submissions; may later link to a booked event.
-- ---------------------------------------------------------------------
CREATE TABLE contact_inquiries (
    inquiry_id      INT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    email           VARCHAR(120) NOT NULL,
    phone           VARCHAR(20),
    message         VARCHAR(500) NOT NULL,
    submitted_at    DATE NOT NULL,
    event_id        INT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'New',
    CONSTRAINT fk_inquiries_event FOREIGN KEY (event_id)
        REFERENCES events(event_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_inquiries_status CHECK (status IN
        ('New','Contacted','Converted','Closed'))
);
