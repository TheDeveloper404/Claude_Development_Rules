# UI/UX Rules — Visual Quality & User Experience Standards

This document defines **constraints** for UI quality.
It does NOT prescribe exact values (spacing, colors, fonts) — those are design decisions made per project.
It prevents the common failures: inconsistency, visual noise, dead UX, and amateur aesthetics.

**Authority:** This document wins on all UI/UX decisions. Engineering rules from `SW_PRINCIPLES.md` still apply to code quality.

---

## 0. The Core Rule

> Every screen must look like **one person designed it**.

If two sections of the same app look like they were built by different teams with different design systems, the UI has failed — regardless of how clean the code is.

---

## 1. Consistency (Non-Negotiable)

These rules exist because inconsistency is the #1 AI-generated UI failure.

### Typography

- **Maximum 2 font families per project.** One for headings, one for body. Using one for both is also valid.
- **Define a type scale and use only those sizes.** A scale has 5-7 steps (e.g. xs, sm, base, lg, xl, 2xl, 3xl). No arbitrary font sizes outside the scale.
- **One weight for body text, one for emphasis, one for headings.** Three weights maximum in regular UI (e.g. 400, 500, 700). Not every component invents its own weight.
- **Line-height is not optional.** Body text: 1.5–1.75. Headings: 1.1–1.3. Dense UI (tables, labels): 1.3–1.5.
- **Heading hierarchy must be visually obvious.** h1 > h2 > h3 must have clear size AND/OR weight differences. If you squint and can't tell h2 from h3, the scale is broken.

### Colors

- **Define a palette before writing UI code.** The palette includes: 1 primary color, 1-2 accent colors, a neutral scale (5-7 shades from near-white to near-black), and semantic colors (success, warning, error, info).
- **Every color in the UI must come from the palette.** No random hex values. If a new color is needed, it's added to the palette intentionally.
- **Semantic colors are not decoration.** Green = success/positive. Red = error/destructive. Yellow/amber = warning/attention. Blue = info/neutral action. Don't use red for a non-destructive primary button. Don't use green for navigation.
- **Contrast ratios matter.** Text on any background must be readable. Don't put light gray text on white. Don't put medium-blue text on dark-blue background. When in doubt, increase contrast.
- **Dark mode, if implemented, is a full palette swap** — not "invert colors" or "make background black." Every shade must be intentionally chosen for dark context.

### Spacing

- **Use a spacing scale.** Spacing values come from a defined set (e.g. 4, 8, 12, 16, 24, 32, 48, 64). No arbitrary padding/margin values.
- **Consistent internal padding.** All cards use the same padding. All sections use the same padding. All modals use the same padding. Not "some cards have 16px and some have 24px and one has 20px."
- **Spacing creates hierarchy.** Space between sections > space between groups > space between elements. This must be visually obvious and consistent across all pages.
- **Related things are close. Unrelated things are far.** A label must be closer to its input than to the previous field's input. A section heading must be closer to its content than to the previous section's content.

### Border Radius

- **Pick a radius language for the project and stick to it.**
  - Sharp (0–2px): technical, dense, data-heavy
  - Soft (6–12px): modern SaaS, friendly
  - Round (16px+): playful, consumer, mobile-first
- **Don't mix sharp buttons with round cards with pill-shaped inputs.** The radius family must be consistent.

### Icons

- **One icon set per project.** Don't mix Heroicons with Font Awesome with custom SVGs with emoji. Pick one source.
- **Consistent icon sizes.** Define 2-3 icon sizes (e.g. 16px inline, 20px buttons, 24px navigation) and use only those.
- **Icons support meaning, they don't replace it.** Every icon that conveys meaning must have an accessible label. Decorative icons are fine without.

---

## 2. Layout Anti-Patterns (Things That Must NOT Happen)

### The "Lonely Card" Problem
- **A page must never be just a single centered container floating in empty space.** If the content is short, the page must still feel intentional — anchor it with proper vertical alignment, supporting text, or a sidebar/contextual element.
- **Exception:** Auth pages (login, signup, reset password) can be a centered card, but must include branding and feel like a designed experience, not a default.

### The "Everything Is a Card" Problem
- **Not every piece of content needs a card wrapper.** Cards imply bounded, self-contained content. A page description is NOT a card. A section heading is NOT a card. A simple list doesn't need to be wrapped in a card.
- **Cards within cards is almost always wrong.** If you need nested containment, use spacing, dividers, or subtle background shifts — not card inception.
- **Rule of thumb:** If removing the card border/shadow would make the content just as clear, the card is unnecessary.

### The "Wall of Content" Problem
- **Long pages must be broken into scannable sections** with clear visual breaks (headings, whitespace, dividers, background alternation).
- **No text walls.** Paragraphs over 4-5 lines in UI context (not articles) need to be broken up or restructured.
- **Dense data needs structure.** Tables, not paragraphs. Key-value pairs, not prose. Lists with visual rhythm, not comma-separated sentences.

### The "Overloaded Landing Page" Problem
- **Hero sections have ONE message and ONE call-to-action.** Not three headings, two paragraphs, four buttons, and an image.
- **Feature sections show 3-4 features maximum per visible group.** 8 features in a grid is visual noise. Group them, paginate them, or prioritize.
- **Every section must earn its space.** If you can't articulate what decision/action a section helps the user make, remove it.
- **Testimonials, logos, stats — pick one or two trust signals,** not all of them stacked on top of each other.

### The "Flat Page" Problem
- **Visual hierarchy is mandatory.** Every page needs a clear primary element (main heading, primary CTA, key data point) that the eye hits first.
- **Size, weight, color, and whitespace create hierarchy.** If everything is the same size and weight, nothing is important.
- **Page scanning pattern must work.** Users scan in F-pattern (content pages) or Z-pattern (landing pages). Place important elements along these natural eye paths.

---

## 3. Component Behavior Standards

These apply to every interactive component in every project.

### Buttons

- **Exactly one primary button style per visible context.** Two primary-styled buttons next to each other = design failure. Use primary + secondary/ghost.
- **Button text is an action verb.** "Save", "Create account", "Send message" — not "OK", "Yes", "Submit" (unless the form context makes it obvious).
- **Destructive actions look destructive.** Red/danger styling. Not the same style as "Save."
- **Disabled buttons must look obviously disabled** — reduced opacity + no pointer cursor + no hover effect.
- **Button sizes are consistent across the app.** If the form buttons are 40px tall, the modal buttons are 40px tall.

### Forms

- **Labels above inputs. Always.** Not floating, not inline, not placeholder-as-label (placeholder text disappears on focus and is an accessibility failure).
- **Placeholder text is a hint, not a label.** "e.g. john@email.com" is a placeholder. "Email address" is a label.
- **Error messages appear below the field they relate to,** in the semantic error color, immediately after validation triggers. Not in a toast. Not at the top of the form for field-specific errors.
- **Required fields must be obvious.** Either mark required fields or mark optional fields — pick one approach per project.
- **Form width must be constrained.** Full-width inputs on a 1400px screen are unreadable. Forms have a max-width (typically 400–600px for single-column forms).
- **Field spacing must be consistent** — same gap between every field group.
- **Group related fields visually.** First name + last name are a logical pair. Address fields are a group. Don't space them the same as unrelated fields.

### Tables

- **Right-align numbers, left-align text.** Always.
- **Header row is visually distinct** — different weight, background, or border. Not identical to data rows.
- **Row height is comfortable.** Dense tables: 36-40px. Regular: 48-56px. Not 28px (cramped) or 72px (wasteful).
- **Horizontal scrolling is the mobile strategy, not row stacking** — unless each row is a simple key-value pair.
- **Empty table state is required.** Never show an empty table shell with just headers and no content. Show an empty state with a message and (if applicable) a CTA to create the first item.

### Modals

- **Modals are for focused decisions, not for content display.** If the user needs to scroll inside a modal, it should probably be a page.
- **One primary action + one cancel/close.** Not three buttons in a modal footer.
- **Modal overlay must dim the background** and clicking the overlay closes the modal (unless it's a destructive confirmation).
- **Modal max-width: small (400px) for confirmations, medium (560px) for forms, large (720px) for complex content.** Never full-width.

### Navigation

- **Active state is mandatory and visually clear.** The user must always know where they are.
- **Navigation structure matches information architecture.** Not more than 5-7 top-level items. Deep nesting = bad IA, not a nav design problem.
- **Mobile navigation is planned, not improvised.** Hamburger menu, bottom tabs, or drawer — decided at project start, not bolted on later.

---

## 4. Empty States, Loading, and Edge Cases

These are the screens users see most often in new products. They must be designed, not forgotten.

### Empty States

- **Every list, table, dashboard, and content area must have a designed empty state.**
- **Empty state formula:** Illustration or icon (optional but helps) + heading that acknowledges emptiness + description that explains what will appear here + CTA to create/add the first item (when applicable).
- **Empty states must NOT feel like errors.** No red icons, no "0 results found" as the only text. Frame positively: "No projects yet — create your first one."
- **Search with no results is different from empty.** Show: "No results for [query]" + suggestion to broaden search or clear filters. Don't show the same empty state.

### Loading States

- **Skeleton screens for content areas.** Match the shape of the actual content that will appear.
- **Spinner for actions (button clicks, form submissions).** Inside the button, replacing the text/icon.
- **Never show a blank page while loading.** The user must see structure immediately, content fills in.
- **Progress indicators for long operations** (file upload, data export). Not just a spinner with no context.
- **Loading must not shift layout.** Content appearing must not push existing content around (Cumulative Layout Shift = bad UX and bad Core Web Vitals).

### Error States

- **Field-level errors: inline, below the field, in error color.**
- **Page-level errors: banner or message at the top of the relevant section.**
- **Full-page errors (500, 404, offline):** designed pages with navigation intact (don't trap users), a human-readable message, and a clear recovery action (go home, try again, contact support).
- **Network errors: non-blocking toast/banner** with retry option. Don't redirect to an error page for a failed API call.

---

## 5. Responsive Behavior

- **Mobile-first is the strategy.** Design the mobile view first, then expand for tablet and desktop. Don't design desktop and then "make it work on mobile."
- **Content priority changes per breakpoint.** What's in the sidebar on desktop might be behind a tab or accordion on mobile. Don't just stack everything vertically.
- **Touch targets: minimum 44x44px on mobile.** No tiny icons, no close-packed links.
- **Font sizes don't scale below readability.** Minimum body text: 14px on mobile. Minimum interactive label: 12px.
- **Test the breakpoint transitions.** The layout between 768 and 1024 (tablet) is where most designs break. Don't only check phone and desktop.

---

## 6. Micro-UX Rules

Small things that compound into "this app feels good" or "this app feels off."

### Feedback

- **Every user action gets immediate visual feedback.** Button click → visual change (loading, disabled, success). Form submit → something happens. Toggle → state changes visually.
- **Hover states on every clickable element.** No cursor:pointer without a visual hover change.
- **Transitions are subtle and fast.** 150-250ms for hover/state changes. 300-500ms for content appearing/disappearing. Nothing over 500ms for UI state transitions.
- **Don't animate things that don't need animation.** Page transitions, content reveals, and hover states benefit from animation. Static content rendering does not.

### Copy & Microcopy

- **Button and label text is user-centric.** "Your projects" not "Projects list". "Save changes" not "Submit." "Go to dashboard" not "Continue."
- **Error messages explain what went wrong AND what to do.** "Email format is invalid — use format: name@domain.com" not "Invalid input."
- **Success confirmations are specific.** "Profile updated" not "Success!" "Email sent to john@example.com" not "Operation completed."
- **Empty states guide, not just inform.** "Create your first project to get started" not "No data."

### Scrolling and Overflow

- **Prevent horizontal scroll on all breakpoints.** If content overflows, it's in a scrollable container with proper styling.
- **Sticky headers/navigation: only if the page is long enough to justify it.** A 2-screen page doesn't need a sticky nav.
- **Scroll position: preserve it during page updates.** Don't jump to top after a list item is edited or deleted.

---

## 7. Page-Type Patterns

When building these page types, follow the established patterns below. Claude can improve on them — but the baseline structure must be respected.

### Dashboard

- **Key metrics first** (top of page). 3-4 cards maximum at the top. Not 8 metric cards.
- **Actionable data below metrics.** Recent activity, tasks, alerts — things the user acts on.
- **Don't show data without context.** "124 users" means nothing. "124 users (↑ 12% this week)" has context.
- **Each dashboard element links to its detail view.** Dashboards are navigation, not destinations.

### Settings Page

- **Grouped by category** with clear section headings. Not one long form.
- **Save per section, not one global save** (for large settings pages). Or auto-save with confirmation.
- **Dangerous settings at the bottom** (delete account, reset data) with visual separation (danger zone).
- **Current values always visible** before editing. Don't make users click "edit" to see what the current setting is.

### List/Table Page (CRUD Index)

- **Structure: filters/search → table/list → pagination.**
- **Bulk actions visible when items are selected.** Not in a hidden dropdown.
- **Quick actions per row** (edit, delete) — visible on hover or always visible if space allows.
- **Filter state reflected in URL** for shareable/bookmarkable views.

### Detail Page

- **Key identity at the top** (name, status, primary actions). Not buried in a tab.
- **Secondary information in tabs or sections below.** Not everything on one scrollable page.
- **Actions (edit, delete, status change) accessible from the header area.** Don't make users scroll to find actions.

### Auth Pages (Login, Signup, Reset)

- **Centered card layout is acceptable here.** But the card must include branding (logo, app name).
- **Social login buttons ABOVE the form divider** (if used). "Or continue with email" pattern.
- **Password visibility toggle is mandatory.**
- **Links between auth pages are clear:** Login → "Don't have an account? Sign up" / Signup → "Already have an account? Log in."

---

## 8. Accessibility (Non-Negotiable Minimum)

These are not optional enhancements. They are required.

- **Color is never the sole indicator of state.** Error = red + icon + text. Success = green + icon + text. Not just color.
- **All interactive elements are keyboard accessible.** Tab through the entire page — everything clickable must be reachable and activatable.
- **Focus indicators are visible.** Never `outline: none` without a custom replacement. The focus ring can be styled but must exist.
- **Labels on all form inputs.** Connected via `for`/`id` or wrapping `<label>`. Not just placeholder text.
- **Semantic HTML first, ARIA second.** Use `<button>` not `<div onclick>`. Use `<nav>`, `<main>`, `<section>`. ARIA is for cases where semantic HTML isn't sufficient.
- **alt text on meaningful images.** Decorative images get `alt=""`.
- **Contrast: WCAG AA minimum** (4.5:1 for normal text, 3:1 for large text).

---

## 9. Anti-Pattern Checklist (Quick Reference)

Before delivering any UI, verify none of these are present:

| Anti-pattern | What to check |
|---|---|
| Font soup | Count distinct font families. Must be ≤ 2. |
| Size chaos | Count distinct font sizes. Must fit a defined scale. |
| Orphan card | Single card floating on a large page with no context. |
| Card inception | Cards nested inside cards. |
| Rainbow palette | Too many unrelated colors. Every color in the palette? |
| Disabled mystery | Buttons that look disabled but are clickable, or vice versa. |
| Phantom click | Elements with cursor:pointer but no visible hover/active state. |
| Empty void | Lists, tables, or content areas with no empty state. |
| Error silence | Actions that can fail but have no error handling UI. |
| Layout jump | Content that shifts position after loading. |
| Giant desert | Large empty spaces between content with no purpose. |
| Wall of sameness | Page sections that all look identical — no visual hierarchy. |
| Scroll trap | Areas that capture scroll unexpectedly (nested scroll). |
| Mobile afterthought | Desktop layout crammed into mobile with no adaptation. |

---

## 10. Working With This Document

- **Precedence:** If `Frontend.md` (feature spec) conflicts with this document on visual/UX decisions, this document wins.
- **Per-project overrides:** Specific projects can override tokens (colors, spacing values, fonts) but NOT behavioral rules (empty states, loading states, accessibility).
- **Claude's design freedom:** This document defines constraints, not prescriptions. Claude is free (and encouraged) to make creative design decisions within these constraints. A beautiful, unexpected design that respects these rules is better than a safe, generic one that also respects them.

---

## Document Hierarchy Update

When adding this file, update the README table:

| File | Purpose |
|---|---|
| `UI_UX_RULES.md` | UI/UX quality standards — visual consistency, component behavior, page patterns |

**Conflict resolution:** `Audit_checklist.md` > `UI_UX_RULES.md` > `SW_PRINCIPLES.md` on decisions that cross boundaries. Security beats UX (e.g., no autofill for sensitive fields even if UX is worse). UX beats code elegance (e.g., add the extra loading state even if it adds complexity).
