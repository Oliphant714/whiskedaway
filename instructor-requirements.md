# WhiskedAway Website Implementation Instructions

Use these instructions to build the WhiskedAway catering website so it matches the instructor feedback from the transcript.

## Brand and layout
- Build the site as a professional wedding catering website with a polished, elegant look.
- Use a simplified logo mark that can scale well as a favicon.
- Do not duplicate the brand name in both the logo and the page heading.
- Place the website name in a clear H1 for accessibility and searchability.
- Use the color palette specified in the course template or a wedding-appropriate palette that feels refined and consistent.
- Keep the design responsive so it works well on desktop and mobile.

## Core content to create
- Add actual site content, not placeholder descriptions.
- Include real images for menu items, catering packages, and contact-related sections.
- Show contact information on the site, including the business phone number, email address, and a contact form or request form.
- Include pricing information that can be displayed clearly to users.

## Data structure requirements
- Store food items in a separate JSON data source or equivalent module that can be imported into the site.
- Model food items as objects with at least these fields: image, title or name, price, category, and package membership.
- Model catering packages as objects with at least these fields: image, title or name, price or pricing summary, and a list of food items included in the package.
- Keep food items and catering packages organized so the UI can build package views from the food item data.

## Food gallery behavior
- Create a food gallery that displays food cards with images and names.
- Add category filtering so clicking a food category shows only the matching food cards.
- Use food categories such as savory, sweet, appetizers, main dishes, desserts, or similar groups if those match the available data.
- Make sure the gallery supports both individual food item browsing and package browsing.

## Pricing behavior
- Add a pricing display that can update when the guest count changes.
- Use food item prices and package pricing to calculate or estimate the displayed cost.
- Keep the pricing logic simple and understandable so it can be demonstrated clearly.

## Contact behavior
- Add a contact section with useful business contact details.
- Include a form that submits without refreshing the page.
- Show a friendly confirmation message after form submission.

## Content and media guidance
- Use food photos for individual food item views.
- Use package photos for catering package views.
- Keep the visual content organized so the user can easily tell the difference between food items and full catering packages.

## Required images and outside resources
- Logo image or logo mark that can be simplified for a favicon.
- Hero image for the top of the homepage, preferably a wedding or catering photo.
- Individual food item photos for each menu card.
- Catering package photos for each package card.
- Contact-related image or decorative image if the contact section uses one.
- A consistent set of brand colors or a template palette to match the instructor requirements.
- A font pairing or web font source if the current design needs typography beyond the default system fonts.
- Business contact details: phone number, email address, and any contact form destination or handling instructions.
- Final pricing details for food items and catering packages.
- Any written descriptions for packages, menus, and service offerings that should appear on the site.

## Implementation notes
- Use simple JavaScript objects, arrays, or imported JSON data to hold the content.
- Keep the code beginner-friendly and structured so it is easy to expand later.
- Make sure the homepage presents the heading, food gallery, pricing list, and contact information clearly on load.
- Prioritize a clean, professional presentation over complex effects.