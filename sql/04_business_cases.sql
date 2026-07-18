-- =====================================================================
-- WhiskedAway Wedding Catering Database — INTERNAL / BACK-OFFICE ONLY
-- 04_business_cases.sql
-- NOTE: reports against the internal ops database (sql/01_schema.sql).
-- Not used by the public site.
-- Advanced queries and views that answer real business questions.
-- =====================================================================

USE whiskedaway;

-- =====================================================================
-- BUSINESS CASE 1
-- Question: "Which package tiers generate the most confirmed revenue,
-- and how many bookings does each have?"
-- Approach: Aggregate (SUM/COUNT) with a GROUP BY across the events and
-- package_tiers tables, filtered to bookings that are actually going to
-- happen (excludes cancelled/inquiry-stage rows) so leadership sees real
-- revenue rather than pipeline noise.
-- =====================================================================
SELECT
    p.package_name,
    COUNT(e.event_id)              AS booked_events,
    SUM(e.guest_count)             AS total_guests,
    SUM(e.total_price)             AS confirmed_revenue,
    ROUND(AVG(e.total_price), 2)   AS avg_event_value
FROM package_tiers p
JOIN events e ON e.package_id = p.package_id
WHERE e.event_status IN ('Booked','Confirmed','Completed')
GROUP BY p.package_id, p.package_name
ORDER BY confirmed_revenue DESC;


-- =====================================================================
-- BUSINESS CASE 2
-- Question: "Which customers currently have an outstanding balance, and
-- how much do they still owe?"
-- Approach: A subquery per invoice sums that invoice's payments; the
-- outer query joins invoices back to events/customers and compares
-- amount_due against amount_paid so only balances still owed surface.
-- A correlated subquery is the cleanest way to net payments against an
-- invoice without collapsing the event/customer columns into the
-- aggregation.
-- =====================================================================
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    e.event_id,
    e.event_date,
    i.amount_due,
    COALESCE((SELECT SUM(pm.amount) FROM payments pm WHERE pm.invoice_id = i.invoice_id), 0) AS amount_paid,
    i.amount_due - COALESCE((SELECT SUM(pm.amount) FROM payments pm WHERE pm.invoice_id = i.invoice_id), 0) AS balance_remaining
FROM invoices i
JOIN events e     ON e.event_id = i.event_id
JOIN customers c  ON c.customer_id = e.customer_id
HAVING balance_remaining > 0
ORDER BY balance_remaining DESC;


-- =====================================================================
-- BUSINESS CASE 3
-- Question: "Which menu items appear in the most package tiers, and
-- what is each item's category? Useful for deciding what to feature in
-- marketing since it's what most customers will actually be served."
-- Approach: JOIN menu_items to its category and to the package_menu_items
-- junction, then GROUP BY/COUNT to rank item popularity across packages,
-- using a HAVING clause to focus on items with meaningful cross-package
-- reach.
-- =====================================================================
SELECT
    mi.item_name,
    mc.category_name,
    COUNT(pmi.package_id) AS packages_featured_in
FROM menu_items mi
JOIN menu_categories mc ON mc.category_id = mi.category_id
JOIN package_menu_items pmi ON pmi.item_id = mi.item_id
GROUP BY mi.item_id, mi.item_name, mc.category_name
HAVING COUNT(pmi.package_id) >= 1
ORDER BY packages_featured_in DESC, mi.item_name;


-- =====================================================================
-- BUSINESS CASE 4 (bonus)
-- Question: "Which venues have hosted the highest total guest volume,
-- and what is the average event size there?" Helps decide which venue
-- partnerships to deepen.
-- Approach: LEFT JOIN so venues with zero events still appear (with
-- NULL/0 stats), demonstrating that the report accounts for the full
-- venue roster, not just the ones already booked.
-- =====================================================================
SELECT
    v.venue_name,
    v.city,
    COUNT(e.event_id)                 AS events_hosted,
    COALESCE(SUM(e.guest_count), 0)   AS total_guests_hosted,
    ROUND(AVG(e.guest_count), 1)      AS avg_guests_per_event
FROM venues v
LEFT JOIN events e ON e.venue_id = v.venue_id
GROUP BY v.venue_id, v.venue_name, v.city
ORDER BY total_guests_hosted DESC;


-- =====================================================================
-- VIEW 1: vw_event_dashboard
-- Purpose: A one-stop "dashboard" row per event combining the customer,
-- venue, package, invoice status, and amount paid so front-desk staff
-- don't have to hand-write a five-table join every time they pull up an
-- event.
-- =====================================================================
CREATE OR REPLACE VIEW vw_event_dashboard AS
SELECT
    e.event_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.phone                                AS customer_phone,
    v.venue_name,
    p.package_name,
    e.event_date,
    e.guest_count,
    e.event_status,
    e.total_price,
    i.status                               AS invoice_status,
    COALESCE((SELECT SUM(pm.amount) FROM payments pm WHERE pm.invoice_id = i.invoice_id), 0) AS amount_paid,
    i.amount_due - COALESCE((SELECT SUM(pm.amount) FROM payments pm WHERE pm.invoice_id = i.invoice_id), 0) AS balance_remaining
FROM events e
JOIN customers c    ON c.customer_id = e.customer_id
JOIN venues v        ON v.venue_id = e.venue_id
JOIN package_tiers p ON p.package_id = e.package_id
LEFT JOIN invoices i ON i.event_id = e.event_id;

-- Example usage: front desk pulls up everything happening this quarter.
-- SELECT * FROM vw_event_dashboard WHERE event_date BETWEEN '2026-07-01' AND '2026-09-30';


-- =====================================================================
-- VIEW 2: vw_monthly_revenue_report
-- Purpose: A management-facing rollup of confirmed revenue and event
-- volume by month, so leadership can review business performance
-- without writing a new aggregate query every reporting cycle.
-- =====================================================================
CREATE OR REPLACE VIEW vw_monthly_revenue_report AS
SELECT
    DATE_FORMAT(e.event_date, '%Y-%m') AS event_month,
    COUNT(e.event_id)                  AS events_count,
    SUM(e.guest_count)                 AS total_guests,
    SUM(e.total_price)                 AS gross_revenue,
    ROUND(AVG(e.total_price), 2)       AS avg_event_value
FROM events e
WHERE e.event_status IN ('Booked','Confirmed','Completed')
GROUP BY DATE_FORMAT(e.event_date, '%Y-%m')
ORDER BY event_month;

-- Example usage: monthly leadership report.
-- SELECT * FROM vw_monthly_revenue_report;
