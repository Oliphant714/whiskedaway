-- =====================================================================
-- WhiskedAway Wedding Catering Database — INTERNAL / BACK-OFFICE ONLY
-- 02_seed_data.sql
-- NOTE: seeds the internal ops database (sql/01_schema.sql). Not used
-- by the public site, which only touches sql/00_public_site_schema.sql.
-- Realistic sample data for every table (10-15 rows each), inserted in
-- dependency order so all foreign key references are valid.
-- =====================================================================

USE whiskedaway;

-- ---------------------------------------------------------------------
-- 1. customers  (14 rows)
-- ---------------------------------------------------------------------
INSERT INTO customers (first_name, last_name, email, phone, created_at) VALUES
('Ava','Bennett','ava.bennett@example.com','310-555-0101','2025-01-12'),
('Liam','Chen','liam.chen@example.com','310-555-0102','2025-01-20'),
('Sofia','Reyes','sofia.reyes@example.com','323-555-0103','2025-02-02'),
('Noah','Patel','noah.patel@example.com','323-555-0104','2025-02-14'),
('Emma','Johansson','emma.johansson@example.com','818-555-0105','2025-02-28'),
('Mateo','Alvarez','mateo.alvarez@example.com','818-555-0106','2025-03-05'),
('Olivia','Kim','olivia.kim@example.com','562-555-0107','2025-03-11'),
('Ethan','Brooks','ethan.brooks@example.com','562-555-0108','2025-03-19'),
('Isabella','Rossi','isabella.rossi@example.com','626-555-0109','2025-04-01'),
('Lucas','Nguyen','lucas.nguyen@example.com','626-555-0110','2025-04-09'),
('Mia','Thompson','mia.thompson@example.com','213-555-0111','2025-04-22'),
('Benjamin','Osei','benjamin.osei@example.com','213-555-0112','2025-05-03'),
('Charlotte','Dubois','charlotte.dubois@example.com','747-555-0113','2025-05-15'),
('James','Kowalski','james.kowalski@example.com','747-555-0114','2025-05-27');

-- ---------------------------------------------------------------------
-- 2. venues  (12 rows)
-- ---------------------------------------------------------------------
INSERT INTO venues (venue_name, address, city, state, zip_code, capacity, contact_phone) VALUES
('The Rosewood Estate','4521 Vineyard Ln','Malibu','CA','90265',220,'310-555-0201'),
('Grand Magnolia Hall','88 Orchard Ave','Pasadena','CA','91101',300,'626-555-0202'),
('Seaside Terrace Club','12 Harbor Dr','Long Beach','CA','90802',180,'562-555-0203'),
('The Ivy Garden','765 Blossom St','Glendale','CA','91205',150,'818-555-0204'),
('Sunset Vineyard','9901 Ridge Rd','Malibu','CA','90265',200,'310-555-0205'),
('Old Mill Barn','3400 County Rd 12','Ojai','CA','93023',160,'805-555-0206'),
('The Metropolitan Loft','200 Spring St','Los Angeles','CA','90012',250,'213-555-0207'),
('Lakeview Pavilion','55 Shoreline Dr','Lake Arrowhead','CA','92352',140,'909-555-0208'),
('The Orangery','1220 Citrus Ave','Pasadena','CA','91106',190,'626-555-0209'),
('Cliffside Manor','77 Coastal Hwy','Palos Verdes','CA','90274',210,'310-555-0210'),
('Botanica Hall','333 Fern Way','Arcadia','CA','91007',175,'626-555-0211'),
('The Regal Ballroom','900 Grand Blvd','Los Angeles','CA','90017',350,'213-555-0212');

-- ---------------------------------------------------------------------
-- 3. menu_categories  (12 rows)
-- ---------------------------------------------------------------------
INSERT INTO menu_categories (category_name, description) VALUES
('Appetizers','Passed and stationed starters served before the main course.'),
('Main Dishes','Plated or buffet-style entrees.'),
('Desserts','Cakes, plated sweets, and dessert-table items.'),
('Beverages','Non-alcoholic and bar-service drink options.'),
('Sides','Accompaniments served alongside the main course.'),
('Charcuterie & Grazing','Curated boards of cured meats, cheeses, and accompaniments.'),
('Bar & Cocktails','Signature cocktails and standard bar service.'),
('Kids Menu','Simplified dishes portioned for younger guests.'),
('Vegan & Plant-Based','Fully plant-based appetizer and entree options.'),
('Late-Night Bites','Casual comfort food served late in the reception.'),
('Brunch & Breakfast','Options for daytime and brunch-style receptions.'),
('Regional Specialties','Cultural and regional dishes for themed menus.');

-- ---------------------------------------------------------------------
-- 4. menu_items  (15 rows)
-- ---------------------------------------------------------------------
INSERT INTO menu_items (category_id, item_name, description, unit_cost, is_vegetarian, is_active) VALUES
(1,'Caprese Skewers','Cherry tomato, mozzarella, and basil with balsamic glaze.',3.50,1,1),
(1,'Bacon-Wrapped Dates','Medjool dates stuffed with almond, wrapped in bacon.',4.00,0,1),
(1,'Mini Crab Cakes','Pan-seared crab cakes with remoulade.',5.25,0,1),
(2,'Herb-Roasted Chicken','Free-range chicken with rosemary jus.',14.00,0,1),
(2,'Grilled Filet Mignon','6oz filet with red wine reduction.',22.00,0,1),
(2,'Wild Mushroom Risotto','Creamy arborio risotto with seasonal mushrooms.',13.00,1,1),
(2,'Pan-Seared Salmon','Atlantic salmon with lemon-caper butter.',17.50,0,1),
(3,'Classic Vanilla Bean Cake','Layered vanilla cake with buttercream.',6.00,1,1),
(3,'Chocolate Ganache Torte','Rich flourless chocolate torte.',6.50,1,1),
(3,'Mini Fruit Tarts','Assorted seasonal fruit tarts.',4.75,1,1),
(4,'Signature Lemonade Bar','Fresh-squeezed lemonade with herb infusions.',2.50,1,1),
(4,'Espresso & Coffee Station','Full-service coffee and espresso bar.',3.00,1,1),
(5,'Garlic Herb Potatoes','Roasted fingerling potatoes.',3.25,1,1),
(5,'Grilled Seasonal Vegetables','Chef''s selection of grilled vegetables.',3.00,1,1),
(5,'Truffle Mac and Cheese','Creamy mac and cheese with truffle oil.',4.50,1,1);

-- ---------------------------------------------------------------------
-- 5. package_tiers  (11 rows)
-- ---------------------------------------------------------------------
INSERT INTO package_tiers (package_name, price_per_guest, min_guests, description) VALUES
('Essentials','65.00',50,'A curated two-course menu with one appetizer and one entree.'),
('Classic','95.00',75,'Three-course plated service with two entree choices.'),
('Signature','135.00',100,'Full-service plated dinner with premium proteins and dessert table.'),
('Luxe','185.00',100,'Chef''s tasting menu with filet/salmon duet and open dessert bar.'),
('Micro-Wedding','110.00',20,'Intimate plated dinner service designed for small guest counts.'),
('Brunch Celebration','58.00',40,'Daytime brunch menu with breakfast and light lunch fare.'),
('Vegan Deluxe','98.00',50,'Fully plant-based three-course tasting menu.'),
('Cocktail Reception','72.00',60,'Heavy passed hors d''oeuvres in place of a seated dinner.'),
('Seasonal Harvest','118.00',75,'Farm-to-table menu built around seasonal ingredients.'),
('Regional Fusion','128.00',75,'Chef-curated menu blending two regional culinary traditions.'),
('Grand Celebration','225.00',150,'Our most elaborate multi-station tasting experience for large weddings.');

-- ---------------------------------------------------------------------
-- 6. package_menu_items  (junction, 16 rows)
-- ---------------------------------------------------------------------
INSERT INTO package_menu_items (package_id, item_id) VALUES
(1,1),(1,4),(1,8),
(2,1),(2,4),(2,6),(2,8),
(3,2),(3,5),(3,7),(3,9),(3,14),
(4,3),(4,5),(4,10);

-- ---------------------------------------------------------------------
-- 7. events  (14 rows)
-- ---------------------------------------------------------------------
INSERT INTO events (customer_id, venue_id, package_id, event_date, guest_count, event_status, total_price) VALUES
(1,1,3,'2026-06-13',120,'Confirmed',16200.00),
(2,2,2,'2026-07-04',150,'Confirmed',14250.00),
(3,3,1,'2026-05-30',90,'Booked',5850.00),
(4,4,4,'2026-08-22',110,'Confirmed',20350.00),
(5,5,2,'2026-09-05',80,'Booked',7600.00),
(6,6,1,'2026-06-27',60,'Completed',3900.00),
(7,7,3,'2026-10-10',140,'Confirmed',18900.00),
(8,8,1,'2026-05-16',55,'Completed',3575.00),
(9,9,2,'2026-11-14',95,'Booked',9025.00),
(10,10,4,'2026-09-19',130,'Confirmed',24050.00),
(11,11,3,'2026-07-18',105,'Booked',14175.00),
(12,12,2,'2026-12-05',160,'Inquiry',15200.00),
(13,1,1,'2026-08-08',65,'Booked',4225.00),
(14,2,3,'2026-10-24',115,'Confirmed',15525.00);

-- ---------------------------------------------------------------------
-- 8. add_ons  (10 rows)
-- ---------------------------------------------------------------------
INSERT INTO add_ons (addon_name, description, price, is_active) VALUES
('Late-Night Snack Bar','Mini sliders and fries served at 10pm.',450.00,1),
('Champagne Toast','Sparkling wine pour for all guests.',3.50,1),
('Chocolate Fountain','Self-serve chocolate fountain with dippers.',350.00,1),
('Signature Cocktail Bar','Two custom cocktails crafted for the couple.',600.00,1),
('Passed Hors d''oeuvres Upgrade','Additional appetizer course, passed.',5.00,1),
('Kids Meal Package','Chicken tenders and fries for guests under 12.',12.00,1),
('Vendor Meal Package','Discounted meals for photographers/DJs/etc.',18.00,1),
('Late Departure Extension','Extends staffed service by two hours.',500.00,1),
('Custom Wedding Cake Upgrade','Upgrades standard cake to a designer tier cake.',700.00,1),
('S''mores Station','Outdoor fire-pit s''mores bar.',275.00,1);

-- ---------------------------------------------------------------------
-- 9. event_addons  (junction, 15 rows)
-- ---------------------------------------------------------------------
INSERT INTO event_addons (event_id, addon_id, quantity) VALUES
(1,2,120),(1,4,1),
(2,1,1),(2,9,1),
(3,6,10),
(4,3,1),(4,4,1),(4,8,1),
(5,2,80),
(7,1,1),(7,2,140),
(9,6,8),
(10,3,1),(10,9,1),
(14,2,115);

-- ---------------------------------------------------------------------
-- 10. staff  (12 rows)
-- ---------------------------------------------------------------------
INSERT INTO staff (first_name, last_name, role, hourly_rate, phone, email) VALUES
('Grace','Miller','Executive Chef',45.00,'310-555-0301','grace.miller@whiskedaway.com'),
('Daniel','Ortiz','Sous Chef',32.00,'310-555-0302','daniel.ortiz@whiskedaway.com'),
('Priya','Sharma','Event Coordinator',28.00,'323-555-0303','priya.sharma@whiskedaway.com'),
('Marcus','Lee','Server',20.00,'323-555-0304','marcus.lee@whiskedaway.com'),
('Hannah','Wright','Server',20.00,'818-555-0305','hannah.wright@whiskedaway.com'),
('Tomas','Garcia','Bartender',24.00,'818-555-0306','tomas.garcia@whiskedaway.com'),
('Nicole','Baker','Pastry Chef',30.00,'562-555-0307','nicole.baker@whiskedaway.com'),
('Aaron','Fields','Server',20.00,'562-555-0308','aaron.fields@whiskedaway.com'),
('Yuki','Tanaka','Event Coordinator',28.00,'626-555-0309','yuki.tanaka@whiskedaway.com'),
('Diego','Morales','Server',20.00,'626-555-0310','diego.morales@whiskedaway.com'),
('Lena','Petrova','Bartender',24.00,'213-555-0311','lena.petrova@whiskedaway.com'),
('Samuel','Cole','Server',20.00,'213-555-0312','samuel.cole@whiskedaway.com');

-- ---------------------------------------------------------------------
-- 11. event_staff_assignments  (junction, 15 rows)
-- ---------------------------------------------------------------------
INSERT INTO event_staff_assignments (event_id, staff_id, role_on_event, hours_worked) VALUES
(1,1,'Lead Chef',8.0),
(1,3,'Coordinator',10.0),
(1,4,'Server',7.0),
(2,2,'Lead Chef',7.5),
(2,9,'Coordinator',9.0),
(3,7,'Pastry Lead',5.0),
(4,1,'Lead Chef',9.0),
(4,6,'Bartender',6.0),
(5,5,'Server',6.5),
(6,2,'Lead Chef',6.0),
(7,1,'Lead Chef',9.5),
(7,11,'Bartender',7.0),
(9,3,'Coordinator',8.0),
(10,7,'Pastry Lead',5.5),
(14,9,'Coordinator',8.5);

-- ---------------------------------------------------------------------
-- 12. invoices  (14 rows, one per event)
-- ---------------------------------------------------------------------
INSERT INTO invoices (event_id, invoice_date, due_date, amount_due, status) VALUES
(1,'2026-04-13','2026-05-13',16200.00,'Paid'),
(2,'2026-05-04','2026-06-04',14250.00,'Paid'),
(3,'2026-04-01','2026-05-01',5850.00,'Pending'),
(4,'2026-06-22','2026-07-22',20350.00,'Paid'),
(5,'2026-07-05','2026-08-05',7600.00,'Pending'),
(6,'2026-04-27','2026-05-27',3900.00,'Paid'),
(7,'2026-08-10','2026-09-10',18900.00,'Pending'),
(8,'2026-03-16','2026-04-16',3575.00,'Paid'),
(9,'2026-09-14','2026-10-14',9025.00,'Pending'),
(10,'2026-07-19','2026-08-19',24050.00,'Overdue'),
(11,'2026-05-18','2026-06-18',14175.00,'Pending'),
(12,'2026-10-05','2026-11-05',15200.00,'Pending'),
(13,'2026-06-08','2026-07-08',4225.00,'Pending'),
(14,'2026-08-24','2026-09-24',15525.00,'Paid');

-- ---------------------------------------------------------------------
-- 13. payments  (15 rows)
-- ---------------------------------------------------------------------
INSERT INTO payments (invoice_id, payment_date, amount, payment_method) VALUES
(1,'2026-04-20',8100.00,'Credit Card'),
(1,'2026-05-10',8100.00,'Credit Card'),
(2,'2026-05-10',14250.00,'Bank Transfer'),
(3,'2026-04-05',2000.00,'Check'),
(4,'2026-06-25',10175.00,'Bank Transfer'),
(4,'2026-07-15',10175.00,'Bank Transfer'),
(5,'2026-07-10',2000.00,'Credit Card'),
(6,'2026-05-01',3900.00,'Cash'),
(7,'2026-08-15',9450.00,'Credit Card'),
(8,'2026-03-20',3575.00,'Debit Card'),
(9,'2026-09-20',3000.00,'Credit Card'),
(10,'2026-07-25',12025.00,'Bank Transfer'),
(11,'2026-05-25',5000.00,'Check'),
(13,'2026-06-12',1500.00,'Cash'),
(14,'2026-08-30',15525.00,'Credit Card');

-- ---------------------------------------------------------------------
-- 14. contact_inquiries  (13 rows)
-- ---------------------------------------------------------------------
INSERT INTO contact_inquiries (name, email, phone, message, submitted_at, event_id, status) VALUES
('Ava Bennett','ava.bennett@example.com','310-555-0101','Interested in a Signature package for ~120 guests in June.','2025-01-10',1,'Converted'),
('Liam Chen','liam.chen@example.com','310-555-0102','Looking for Classic package pricing for a July wedding.','2025-01-18',2,'Converted'),
('Sofia Reyes','sofia.reyes@example.com','323-555-0103','Can you cater a 90-guest reception in late May?','2025-01-30',3,'Converted'),
('Noah Patel','noah.patel@example.com','323-555-0104','Requesting a tasting for the Luxe package.','2025-02-10',4,'Converted'),
('Emma Johansson','emma.johansson@example.com','818-555-0105','Do you offer vegetarian-forward menus?','2025-02-25',5,'Converted'),
('Priya Desai','priya.desai@example.com','424-555-0401','What is your availability for April 2027?','2025-06-01',NULL,'New'),
('Ryan Foster','ryan.foster@example.com','424-555-0402','Requesting pricing for a 200-guest wedding.','2025-06-04',NULL,'Contacted'),
('Kayla Simmons','kayla.simmons@example.com','424-555-0403','Do you have gluten-free dessert options?','2025-06-09',NULL,'New'),
('Owen Walsh','owen.walsh@example.com','424-555-0404','Interested in the Essentials package for a small wedding.','2025-06-15',NULL,'Contacted'),
('Mateo Alvarez','mateo.alvarez@example.com','818-555-0106','Would like to book the Old Mill Barn with Essentials.','2025-02-01',6,'Converted'),
('Ethan Brooks','ethan.brooks@example.com','562-555-0108','Confirming headcount for our May event.','2025-02-20',8,'Converted'),
('Zoe Martin','zoe.martin@example.com','424-555-0405','Asking about bar service add-ons.','2025-06-20',NULL,'New'),
('Isaiah Turner','isaiah.turner@example.com','424-555-0406','Following up on quote sent last week.','2025-06-25',NULL,'Closed');
