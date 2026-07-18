/**
 * WhiskedAway — site behavior
 * -----------------------------------------------------------------
 * Organized into small, single-purpose functions grouped by feature:
 *   1. Navigation (mobile menu toggle)
 *   2. Food gallery (render + category filter)
 *   3. Packages (render signature/regional cards)
 *   4. Pricing estimate (guest count x package, informational only)
 *   5. Contact form (fetch POST to php/contact-handler.php)
 *
 * Uses: objects (FOOD_ITEMS / PACKAGES entries), arrays (FOOD_ITEMS,
 * PACKAGES, CATEGORIES), and array methods (filter, map, forEach,
 * reduce, find).
 */

document.addEventListener("DOMContentLoaded", () => {
  initNav();
  initFoodGallery();
  initPackages();
  initPricingEstimator();
  initContactForm();
  setYear();
});

/* ------------------------------------------------------------------
 * 1. Navigation
 * ------------------------------------------------------------------ */
function initNav() {
  const toggle = document.querySelector(".nav__toggle");
  const menu = document.querySelector(".nav__menu");

  if (!toggle || !menu) return;

  toggle.addEventListener("click", () => {
    const isOpen = menu.classList.toggle("is-open");
    // Conditional branching: aria-expanded reflects actual state
    toggle.setAttribute("aria-expanded", isOpen ? "true" : "false");
  });

  // Close the mobile menu whenever a link inside it is used
  menu.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", () => {
      if (menu.classList.contains("is-open")) {
        menu.classList.remove("is-open");
        toggle.setAttribute("aria-expanded", "false");
      }
    });
  });
}

/* ------------------------------------------------------------------
 * 2. Food gallery
 * ------------------------------------------------------------------ */
function initFoodGallery() {
  const filterBar = document.querySelector(".gallery__filters");
  const grid = document.querySelector(".gallery__grid");
  if (!filterBar || !grid) return;

  renderCategoryButtons(filterBar);
  renderFoodCards(grid, FOOD_ITEMS);

  filterBar.addEventListener("click", (event) => {
    const button = event.target.closest("button[data-category]");
    if (!button) return;

    filterBar
      .querySelectorAll("button")
      .forEach((btn) => btn.classList.remove("is-active"));
    button.classList.add("is-active");

    const category = button.dataset.category;
    // Conditional branching: "all" bypasses the filter method
    const filtered =
      category === "all"
        ? FOOD_ITEMS
        : FOOD_ITEMS.filter((item) => item.category === category);

    renderFoodCards(grid, filtered);
  });
}

function renderCategoryButtons(container) {
  container.innerHTML = CATEGORIES.map(
    (cat, index) => `
      <button type="button" data-category="${cat.id}" class="${index === 0 ? "is-active" : ""}">
        ${cat.label}
      </button>`
  ).join("");
}

function renderFoodCards(container, items) {
  if (items.length === 0) {
    container.innerHTML = `<p class="gallery__empty">No dishes in this category yet — ask us at your consultation.</p>`;
    return;
  }

  container.innerHTML = items
    .map(
      (item) => `
      <article class="food-card">
        <img src="${item.image}" alt="${item.name}" loading="lazy" width="800" height="533">
        <div class="food-card__body">
          <h3>${item.name}${item.origin ? `<span class="food-card__origin">${item.origin}</span>` : ""}</h3>
          <p>${item.description}</p>
          <p class="food-card__price">$${item.price.toFixed(2)} <span>per guest</span></p>
        </div>
      </article>`
    )
    .join("");
}

/* ------------------------------------------------------------------
 * 3. Packages
 * ------------------------------------------------------------------ */
function initPackages() {
  const grid = document.querySelector(".packages__grid");
  if (!grid) return;
  renderPackageCards(grid, PACKAGES);
}

function renderPackageCards(container, packages) {
  container.innerHTML = packages
    .map((pkg) => {
      // Look up included item names via .map + .find
      const includedNames = pkg.items
        .map((id) => FOOD_ITEMS.find((food) => food.id === id))
        .filter(Boolean)
        .map((food) => food.name)
        .join(", ");

      const badge = pkg.tag === "regional" ? "Regional Menu" : "Signature Menu";

      return `
        <article class="package-card">
          <img src="${pkg.image}" alt="${pkg.name} catering package" loading="lazy" width="900" height="600">
          <div class="package-card__body">
            <span class="package-card__badge">${badge}</span>
            <h3>${pkg.name}</h3>
            <p>${pkg.description}</p>
            <p class="package-card__meta">Includes: ${includedNames}</p>
            <p class="package-card__price">Starting at $${pkg.pricePerGuest.toFixed(2)} <span>/ guest</span></p>
            <p class="package-card__min">Minimum ${pkg.minGuests} guests</p>
          </div>
        </article>`;
    })
    .join("");
}

/* ------------------------------------------------------------------
 * 4. Pricing estimator (informational only — no data is stored)
 * ------------------------------------------------------------------ */
function initPricingEstimator() {
  const select = document.querySelector("#estimate-package");
  const guestInput = document.querySelector("#estimate-guests");
  const result = document.querySelector(".estimator__result");
  const averageNote = document.querySelector(".estimator__average");
  if (!select || !guestInput || !result) return;

  // Populate the package dropdown from the PACKAGES array
  select.innerHTML = PACKAGES.map(
    (pkg) => `<option value="${pkg.id}">${pkg.name} — $${pkg.pricePerGuest}/guest</option>`
  ).join("");

  // Array method: reduce -> average starting price across all packages
  if (averageNote) {
    const average =
      PACKAGES.reduce((sum, pkg) => sum + pkg.pricePerGuest, 0) / PACKAGES.length;
    averageNote.textContent = `Our packages average around $${average.toFixed(0)} per guest, with menus for every guest count and budget.`;
  }

  const updateEstimate = () => calculateEstimate(select, guestInput, result);

  select.addEventListener("change", updateEstimate);
  guestInput.addEventListener("input", updateEstimate);

  updateEstimate();
}

function calculateEstimate(select, guestInput, result) {
  const pkg = PACKAGES.find((p) => p.id === select.value);
  const guests = parseInt(guestInput.value, 10);

  if (!pkg) {
    result.textContent = "Choose a package to see a starting estimate.";
    return;
  }

  // Conditional branching around invalid / below-minimum guest counts
  if (!guests || guests <= 0) {
    result.textContent = "Enter a guest count to see a starting estimate.";
    return;
  }

  if (guests < pkg.minGuests) {
    result.innerHTML = `The ${pkg.name} package requires a minimum of ${pkg.minGuests} guests. Reach out and we'll help you find the right fit.`;
    return;
  }

  const estimate = guests * pkg.pricePerGuest;
  result.innerHTML = `
    Estimated starting cost for <strong>${pkg.name}</strong> at ${guests} guests:
    <strong>$${estimate.toLocaleString(undefined, { maximumFractionDigits: 0 })}</strong>.
    <span class="estimator__disclaimer">This is a starting estimate — your final quote is confirmed during a consultation.</span>`;
}

/* ------------------------------------------------------------------
 * 5. Contact form
 * ------------------------------------------------------------------ */
function initContactForm() {
  const form = document.querySelector("#contact-form");
  const statusBox = document.querySelector(".form__status");
  if (!form || !statusBox) return;

  // Fill the "which package are you interested in" select from data
  const packageSelect = form.querySelector("#contact-package");
  if (packageSelect) {
    const options = ["<option value=\"\">Not sure yet</option>"].concat(
      PACKAGES.map((pkg) => `<option value="${pkg.name}">${pkg.name}</option>`)
    );
    packageSelect.innerHTML = options.join("");
  }

  form.addEventListener("submit", (event) => {
    event.preventDefault();
    handleContactSubmit(form, statusBox);
  });
}

async function handleContactSubmit(form, statusBox) {
  const submitButton = form.querySelector("button[type='submit']");
  const formData = new FormData(form);

  // Honeypot spam check: if this hidden field was filled, silently bail
  if (formData.get("website")) return;

  const payload = Object.fromEntries(formData.entries());

  if (!validateContactPayload(payload, statusBox)) {
    return;
  }

  setFormBusy(submitButton, true);
  showStatus(statusBox, "Sending your message…", "info");

  try {
    const response = await fetch("php/contact-handler.php", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    });

    const data = await response.json();

    if (response.ok && data.success) {
      showStatus(
        statusBox,
        "Thank you! Your message is on its way to our team — we'll be in touch within 1–2 business days to schedule your consultation.",
        "success"
      );
      form.reset();
    } else {
      showStatus(statusBox, data.message || "Something went wrong. Please try again or call us directly.", "error");
    }
  } catch (error) {
    showStatus(statusBox, "We couldn't reach the server. Please try again or call us directly.", "error");
  } finally {
    setFormBusy(submitButton, false);
  }
}

function validateContactPayload(payload, statusBox) {
  if (!payload.name || !payload.email || !payload.message) {
    showStatus(statusBox, "Please fill in your name, email, and message.", "error");
    return false;
  }

  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailPattern.test(payload.email)) {
    showStatus(statusBox, "Please enter a valid email address.", "error");
    return false;
  }

  return true;
}

function setFormBusy(button, isBusy) {
  if (!button) return;
  button.disabled = isBusy;
  button.textContent = isBusy ? "Sending…" : "Send Message";
}

function showStatus(box, message, type) {
  box.textContent = message;
  box.className = `form__status form__status--${type}`;
  box.setAttribute("role", type === "error" ? "alert" : "status");
}

/* ------------------------------------------------------------------
 * Misc
 * ------------------------------------------------------------------ */
function setYear() {
  const el = document.querySelector("#current-year");
  if (el) el.textContent = new Date().getFullYear();
}
