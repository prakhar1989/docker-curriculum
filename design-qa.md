# Design QA — Docker Curriculum redesign

## Comparison target

- Source visual truth: `/var/folders/_6/7xbwtxyj075bv9md85kvdby40000gn/T/codex-clipboard-72177c9b-f863-4f5d-98b6-7425af9d0239.png` (Herdr theme-picker reference, 1134 × 1694 px).
- Combined comparison: [`design-qa-comparison.png`](./design-qa-comparison.png) places the source and rendered picker side by side after proportional normalization.
- Implementation: `http://localhost:4321/` in the in-app browser.

## Evidence

| State | Screenshot | CSS viewport | Raster dimensions | Density |
| --- | --- | --- | --- | --- |
| Homepage, Deep Ocean | [`design-qa-home.png`](./design-qa-home.png) | 1280 × 720 | 1272 × 1595 (full page) | devicePixelRatio 2; browser capture crop |
| Theme picker open | [`design-qa-theme-dialog.png`](./design-qa-theme-dialog.png) | 1280 × 720 | 1272 × 716 | devicePixelRatio 2; browser capture crop |
| Chapter page | [`design-qa-chapter.png`](./design-qa-chapter.png) | 1280 × 720 | 1272 × 1595 (full page) | devicePixelRatio 2; browser capture crop |
| Chapter page, Blueprint heading pass | [`design-qa-chapter-blueprint.png`](./design-qa-chapter-blueprint.png) | 1280 × 720 | 1272 × 716 | devicePixelRatio 2; browser capture crop |
| Homepage header, Blueprint | [`design-qa-header.png`](./design-qa-header.png) | 1280 × 720 | 1272 × 716 | devicePixelRatio 2; browser capture crop |
| Homepage footer social links | [`design-qa-footer-view.png`](./design-qa-footer-view.png) | 1280 × 720 | 1272 × 716 | devicePixelRatio 2; browser capture crop |
| Tutorial page without right TOC | [`design-qa-no-toc.png`](./design-qa-no-toc.png) | 1280 × 720 | 1272 × 716 | devicePixelRatio 2; browser capture crop |

The source is an interaction/style reference rather than a pixel target: the implementation intentionally uses Docker-specific palette names, copy, controls, and six selectable palettes while preserving the reference's focused modal, grouped options, selected state, and keyboard affordances. The combined comparison normalized both images to a 900 px content height before review.

## Review

### Full-view comparison

The implementation establishes a dark, low-glare documentation canvas, a full-width homepage rail, a strong hero hierarchy, and a focused theme modal with a dimmed/blurred page behind it. Header, hero, chapter navigation, code surfaces, and cards share the same semantic palette tokens. The desktop page remains readable at the tested viewport, and the chapter view retains active navigation plus a right-hand table of contents.

### Focused region comparison

The theme-picker region was reviewed at full readable scale. Both versions use a centered bordered panel, grouped dark/light choices, a clear selected row, and an explicit apply/close footer. The Docker Curriculum version adds descriptions and swatches to make six palettes scannable; this is an intentional adaptation, not a fidelity defect.

## Findings

- No actionable P0, P1, or P2 findings remain.
- P3 / intentional variation: the picker is more compact and descriptive than the taller Herdr list. This keeps the control usable on documentation viewports and gives each Docker palette a recognizable purpose.

## Interaction and runtime checks

- Opened the desktop theme trigger and verified the custom dialog renders with only the active dialog visible.
- Previewed `Deep Ocean`, verified `data-theme="dark"`, `data-palette="deep-ocean"`, and the selected state update.
- Applied the theme and reloaded the homepage; the selected palette and trigger label persisted.
- Navigated to `/introduction/00-docker/` and verified the redesigned chapter layout.
- Checked browser console output after the interaction pass: no errors or warnings.
- Manually checked the responsive layout at a 390 × 844 viewport during the browser pass; hero content stacks before the illustration and controls remain reachable.

## Comparison history

1. Initial implementation review exposed a duplicate Starlight homepage title and an over-stretched logo. Removed the duplicate title and restored intrinsic logo sizing; recaptured the homepage evidence.
2. Initial picker review exposed closed dialogs inheriting `display:flex`, which left an invisible dialog in the layout. Added the closed-state rule and flex/scroll layout; recaptured the open-dialog evidence.
3. The homepage rail was inheriting Starlight's narrow content max-width. Removed that cap and recaptured the full-width homepage evidence.
4. Chapter h1 headings were still inheriting the legacy blue gradient. Matched the homepage hero's Plus Jakarta Sans weight, tracking, and theme foreground color; recaptured the Blueprint chapter evidence.
5. The header site title was still inheriting the legacy gradient. Reset the gradient/text-fill styling and matched the hero typography; recaptured the Blueprint homepage header evidence.
6. Added GitHub and LinkedIn footer links using the Starlight icon set; verified both hrefs, accessible labels, and rendered SVG icons.
7. Disabled the global tutorial table of contents so the “On this page” rail no longer renders; recaptured the introduction page.
8. Final comparison found no remaining P0/P1/P2 differences.

## Implementation checklist

- [x] Semantic palette tokens cover dark and light modes.
- [x] Homepage content uses the full available documentation rail instead of a narrow Starlight max-width.
- [x] Chapter headings use the hero typography and palette-aware foreground color.
- [x] Header title uses the same solid, palette-aware hero treatment.
- [x] Footer exposes GitHub and LinkedIn links with accessible labels and icons.
- [x] Tutorial pages no longer render the right-hand “On this page” table of contents.
- [x] Named theme picker supports system preference, preview, apply, cancel, and persistence.
- [x] Homepage, chapter navigation, code blocks, cards, and quizzes share the visual system.
- [x] Desktop, chapter, and responsive states were browser-checked.
- [x] Production build and browser console checks are complete.

final result: passed
