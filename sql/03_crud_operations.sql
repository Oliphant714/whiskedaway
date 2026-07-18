-- =====================================================================
-- WhiskedAway Wedding Catering Database — INTERNAL / BACK-OFFICE ONLY
-- 03_crud_operations.sql
-- NOTE: operates on the internal ops database (sql/01_schema.sql).
-- Not used by the public site.
-- CRUD demonstrations, each preceded by the business task it solves.
-- =====================================================================

USE whiskedaway;

-- =====================================================================
-- CREATE
-- =====================================================================

-- Business Task 1: A new couple just called to inquire about catering.
-- Register their profile so staff can begin planning their event.
INSERT INTO customers (first_name, last_name, email, phone, created_at)
VALUES ('Chloe', 'Whitfield', 'chloe.whitfield@example.com', '424-555-0501', CURDATE());

-- Business Task 2: WhiskedAway is adding a new dessert to the menu
-- catalog so it can be included in future package offerings.
INSERT INTO menu_items (category_id, item_name, description, unit_cost, is_vegetarian, is_active)
VALUES (3, 'Lavender Honey Panna Cotta', 'Silky panna cotta infused with lavender and local honey.', 5.50, 1, 1);

-- Business Task 3: A new optional add-on service is being launched
-- (a photo booth) and needs to be available for customers to select.
INSERT INTO add_ons (addon_name, description, price, is_active)
VALUES ('Photo Booth Rental', 'Open-air photo booth with props, staffed for 3 hours.', 425.00, 1);


-- =====================================================================
-- READ
-- =====================================================================

-- Business Task 4: A coordinator needs every order (event) placed by a
-- specific customer, e.g. to review a couple's full booking history.
SELECT e.event_id, e.event_date, v.venue_name, p.package_name,
       e.guest_count, e.event_status, e.total_price
FROM events e
JOIN customers c        ON c.customer_id = e.customer_id
JOIN venues v            ON v.venue_id = e.venue_id
JOIN package_tiers p     ON p.package_id = e.package_id
WHERE c.email = 'ava.bennett@example.com'
ORDER BY e.event_date;

-- Business Task 5: The events team needs the full schedule of weddings
-- happening on a specific date, with venue and guest count, for staffing.
SELECT e.event_id, CONCAT(c.first_name, ' ', c.last_name) AS couple,
       v.venue_name, e.guest_count, e.event_status
FROM events e
JOIN customers c ON c.customer_id = e.customer_id
JOIN venues v    ON v.venue_id = e.venue_id
WHERE e.event_date = '2026-06-13';


-- =====================================================================
-- UPDATE
-- =====================================================================

-- Business Task 6: A customer moved and gave WhiskedAway a new phone
-- number; update their contact record to keep it accurate.
UPDATE customers
SET phone = '310-555-9999'
WHERE email = 'ava.bennett@example.com';

-- Business Task 7: A payment cleared for event #3's invoice; mark it
-- "Paid" now that the balance has been settled in full.
UPDATE invoices
SET status = 'Paid'
WHERE invoice_id = (SELECT invoice_id FROM (
        SELECT invoice_id FROM invoices WHERE event_id = 3
     ) AS sub);


-- =====================================================================
-- DELETE
-- =====================================================================

-- Business Task 8: A couple canceled an optional add-on (the Kids Meal
-- Package) they had selected for event #9; remove that line item.
DELETE FROM event_addons
WHERE event_id = 9 AND addon_id = (SELECT addon_id FROM (
        SELECT addon_id FROM add_ons WHERE addon_name = 'Kids Meal Package'
     ) AS sub);

-- Business Task 9: A stale, unconverted website inquiry (older lead
-- WhiskedAway never heard back from) is being purged from active leads.
DELETE FROM contact_inquiries
WHERE email = 'isaiah.turner@example.com' AND status = 'Closed';
