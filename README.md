# WhiskedAway — First Iteration

A single-page wedding catering marketing site: hero, menu gallery, catering
packages (including four regional/ethnic menus), a client-side pricing
estimator, and a database-backed "Request a Consultation" form. Built from
the plan in `app-plan.html` / `styles/site-plan.css` — same palette
(cream/espresso/terracotta), same type pairing (Cormorant Garamond +
Open Sans), same section order as the wireframe (hero → gallery →
pricing → contact).

## What's here

```
index.html                   Single-page site
styles/main.css               Mobile-first stylesheet (extends site-plan.css tokens)
js/data.js                    Food items + packages as objects/arrays (content source)
js/app.js                     Gallery filtering, packages, pricing estimator, nav, contact form
php/contact-handler.php       Validates + inserts consultation requests
php/db-config.php             Reads DB credentials from environment variables
.env.example                  Template for local DB credentials
sql/00_public_site_schema.sql The ONLY database the live site touches
sql/01_schema.sql             Internal back-office schema (reference only — see note below)
sql/02_seed_data.sql          Sample data for the back-office schema
sql/03_crud_operations.sql    CRUD examples against the back-office schema
sql/04_business_cases.sql     Reporting queries/views against the back-office schema
images/                       Empty — see "Images you need to add" below
```

## Why two databases

The instructor's full schema (`sql/01_schema.sql` – `04_business_cases.sql`)
models the whole business: bookings, invoices, and payments. That's real
financial data, and the live public site's only job is to **advertise the
business and capture consultation requests** — so it should never read or
write pricing/payment tables.

To keep that boundary solid, `contact-handler.php` only ever connects to
`whiskedaway_public` / `contact_inquiries` (`sql/00_public_site_schema.sql`).
The original four files stay in the repo as the internal operations
database a staff-only back office would eventually use — they're just not
wired into anything a website visitor can reach.

## Local setup

1. Create the public database and table:
   ```
   mysql -u root -p < sql/00_public_site_schema.sql
   ```
2. Copy `.env.example` to `.env` and fill in real credentials (or set the
   same variables in your host's environment settings). Create a
   least-privilege MySQL user that can only `INSERT`/`SELECT` on
   `whiskedaway_public.contact_inquiries`.
3. Serve the project root with PHP (e.g. `php -S localhost:8000`) so
   `index.html` and `php/contact-handler.php` are reachable from the same
   origin.
4. Open `http://localhost:8000/`.

For hosting: any shared host or VPS with PHP 8+ and MySQL/MariaDB works
(the requirement is just "hosted on the web" — e.g. a student hosting
account, Render, Railway, or a LAMP VPS all work fine).

## Requirements checklist (how this iteration meets the brief)

- **Content matches audience** — plain-language copy aimed at engaged
  couples/planners; no jargon.
- **At least one image** — hero image + food/package photo grid (see image
  list below — you'll drop in real files).
- **Matches the wireframe** — hero, then Food Gallery / Pricing / Contact,
  same section order as `app-plan.html`.
- **Mobile-first, responsive** — `styles/main.css` starts unstyled-for-mobile
  and layers on `min-width` media queries at 640px / 760px / 980px, same
  pattern as `site-plan.css`.
- **Valid HTML/CSS, accessible** — semantic landmarks, skip link, visible
  focus states, labeled form fields, `aria-live` status regions,
  `prefers-reduced-motion` respected. Run it through the W3C validator and
  Lighthouse once real images are in place (image `alt` text and file
  size are the two things most likely to move your Lighthouse score).
- **JavaScript**
  - Organization: split across `data.js` (content) and `app.js` (five
    labeled feature groups, each with its own functions).
  - DOM interaction: `querySelector`, `.innerHTML` rendering, `addEventListener`
    for click/change/input/submit.
  - Conditional branching: category "all" vs. filtered, guest count
    validation, below-minimum-guest-count messaging, form validation,
    honeypot check.
  - Objects/Arrays/array methods: `FOOD_ITEMS`/`PACKAGES` arrays of
    objects; `.filter()` (category filtering), `.map()` (rendering cards,
    building option lists), `.forEach()` (nav links, category buttons),
    `.reduce()` (average package price), `.find()` (package lookup by id).

## Images you need to add

I didn't generate any images — drop real photos into these exact paths
(filenames already match what `index.html` / `data.js` reference):

**Site-wide**
- `images/site/logo-mark.png` — simplified logo mark, square, works as a
  small circle/favicon at 40×40
- `images/site/favicon.png` — 32×32 or 64×64 favicon version of the mark
- `images/site/hero-tablescape.jpg` — wide wedding/catering hero photo
  (place setting, plated dish, or reception tablescape), ~1280×960 or larger

**Food photos** (`images/food/`) — one photo per dish, ~800×600, landscape:
- `caprese-skewers.jpg`, `bacon-wrapped-dates.jpg`, `smoked-salmon-crostini.jpg`
- `herb-roasted-chicken.jpg`, `grilled-filet-mignon.jpg`, `wild-mushroom-risotto.jpg`, `pan-seared-salmon.jpg`
- `garlic-herb-potatoes.jpg`, `grilled-seasonal-vegetables.jpg`, `truffle-mac-and-cheese.jpg`
- `classic-vanilla-bean-cake.jpg`, `chocolate-ganache-torte.jpg`, `mini-fruit-tarts.jpg`
- `signature-lemonade-bar.jpg`, `espresso-coffee-station.jpg`
- `chicken-tikka-masala.jpg`, `saffron-vegetable-biryani.jpg` (Indian)
- `osso-buco-alla-milanese.jpg`, `handmade-cheese-tortellini.jpg` (Italian)
- `carne-asada-chimichurri.jpg`, `enchiladas-verdes.jpg` (Mexican)
- `lamb-moussaka.jpg`, `falafel-hummus-platter.jpg` (Mediterranean/Greek)

**Package photos** (`images/packages/`) — one hero-style photo per package,
~800×600:
- `essentials.jpg`, `classic.jpg`, `signature.jpg`, `luxe.jpg`
- `italian-trattoria.jpg`, `mexican-fiesta.jpg`, `indian-spice-route.jpg`, `mediterranean-table.jpg`

**Other assets to gather**
- Real business phone number, email address, and service area (placeholders
  are in `index.html`: `(310) 555-0199`, `hello@whiskedaway.example`)
- A short list of written blurbs if you want package descriptions to reflect
  the actual chef/menu rather than the drafted copy in `js/data.js`
- Optional: real logo files in vector form (SVG) if you have brand assets,
  which will look sharper than a raster PNG at small sizes

## Notes / things to revisit in the next iteration

- Swap in real images, then re-run Lighthouse — compressed, correctly
  sized JPGs/WebP are the biggest lever on the Performance score.
- Consider adding `width`/`height`-matched `srcset` once real photos exist,
  to further help Core Web Vitals (CLS/LCP).
- The estimator is intentionally informational only — no guest count or
  price ever gets written to the database, only the optional fields on
  the consultation form (name/email/message/etc.).
