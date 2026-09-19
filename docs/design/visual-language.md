# MidnightOnyx Gothic Visual Language

## Purpose

This document defines the canonical visual language for MidnightOnyx Gothic.

MidnightOnyx Gothic is a Victorian Gothic computing environment conceived as an elegant, subtly haunted manor. The design should be immediately recognizable as gothic while remaining luxurious, serious, readable, believable, and suitable for everyday use.

The project is intended to become a distributable theme composed from reusable KDE and Linux theming components. Individual implementations should derive their appearance from this visual language rather than inventing independent aesthetics.

## Core concept

The operating system is metaphorically an elegant Victorian Gothic manor.

The metaphor provides a common design vocabulary for otherwise independent system components. It does not require every interface to literally resemble a room or physical object.

Possible conceptual relationships include:

| System component | Manor metaphor |
|---|---|
| Bootloader | Approaching the estate |
| Boot splash | Passing through the grounds |
| Login screen | Front entrance |
| Login transition | Entering the manor |
| Desktop | Grand hall or common area |
| Application launcher | Directory or foyer index |
| File manager | Library or archives |
| Terminal | Study, laboratory, or hidden workshop |
| System settings | Machinery and service rooms |
| Lock screen | Manor doors closed |
| Logout | Leaving the manor |
| Shutdown | Manor going dark |
| Suspend | Manor sleeping |
| Notifications | Letters, bells, calling cards, or notices |

These relationships are conceptual guidance rather than strict implementation requirements.

## Historical influence

The primary historical and artistic influence is Victorian Gothic.

The visual language may draw from:

- Victorian Gothic and Gothic Revival architecture.
- Elegant nineteenth-century interiors and estates.
- Pointed arches and restrained Gothic architectural geometry.
- Dark polished materials and ornate metalwork.
- Gothic literature and atmospheric supernatural fiction.
- Genuine historical typography where it remains readable.

Historical references should feel plausible and deliberate rather than theatrical or costume-like.

## Mood

The desired mood is gothic elegance.

The environment should feel:

- Elegant.
- Mysterious.
- Luxurious.
- Nocturnal.
- Slightly haunted.
- Atmospheric.
- Serious.
- Old without appearing broken or neglected.

The supernatural should normally be implied rather than explicitly depicted.

The user should feel that something unusual may inhabit the environment without the system becoming a horror-themed novelty.

## Material language

The primary material vocabulary is:

- Onyx.
- Obsidian.
- Black stone.
- Silver.
- Iron and pewter.
- Bone.
- Dark wood.
- Dark glass.
- Candlelight.
- Moonlight.

Surfaces should suggest physical depth rather than generic flat black.

True black should normally be reserved for deep shadow. Ordinary surfaces should use subtly differentiated near-black colors so hierarchy remains visible.

## Lighting

Two environmental light sources define much of the atmosphere.

### Moonlight

Moonlight is cool, desaturated, distant, and silver-blue.

It may illuminate architecture, fog, exterior scenes, and selected environmental details.

### Candlelight

Candlelight is warm, restrained, localized, and antique.

It may appear in windows, interiors, atmospheric highlights, and selected semantic states.

The contrast between cold moonlight and warm candlelight should help make the environment feel physical and inhabited.

## Geometry

Pointed Gothic arches are the initial signature architectural motif.

They should be used selectively.

Large compositions, framing devices, wallpaper architecture, and major decorative structures are better candidates than ordinary buttons or every UI container.

Functional controls should remain usable and visually disciplined.

Additional Gothic geometry may be introduced later when it reinforces the visual language without creating ornamental noise.

## Ornamentation

Ornament should be deliberate and restrained.

Appropriate possibilities include:

- Fine silver borders.
- Subtle metal engraving.
- Architectural tracery.
- Restrained Victorian filigree.
- Pointed-arch framing.
- Historically plausible decorative motifs.

Ornament must not interfere with readability or make ordinary controls visually exhausting.

Large decorative corner flourishes should generally be avoided unless a particular composition clearly benefits from them.

## Interaction language

The central interaction rule is:

> Silver means interactive. Crimson means consequential.

Silver and related metals should communicate ordinary hover, focus, structure, and affordance.

Crimson should be comparatively rare so that it retains dramatic significance.

Wine may support selected states and larger accent surfaces where full Crimson would be too aggressive.

Blood should be used sparingly, primarily where danger or failure warrants stronger emphasis.

## Typography philosophy

Typography should use multiple voices rather than forcing one decorative typeface across the entire system.

### Display voice

A historically influenced serif or readable Gothic-derived typeface may be used for large titles, clocks, splash screens, and other display elements.

### Functional voice

Ordinary interface text must remain highly readable. A restrained serif or sans-serif may be used where decorative historical typography would impair usability.

### Monospace voice

Terminal and code typography must prioritize legibility while remaining visually compatible with the wider theme.

Unreadable faux-medieval typography is explicitly excluded.

Genuine historical or historically informed typography is acceptable when it remains practical to read.

## Motion language

Motion should be atmospheric rather than technological.

Preferred motion includes:

- Slow fog.
- Subtle candle flicker.
- Drifting dust.
- Slow cloud movement.
- Shifting moonlight.
- Very restrained environmental particles.

Interface chrome should generally remain composed and stable.

Avoid constant glowing borders, pulsing controls, neon trails, excessive bouncing, or other motion associated with gamer or cyberpunk interfaces.

## Image language

Imagery should favor photorealism or convincing realism.

The environment should appear physically plausible even when supernatural atmosphere is present.

For the initial login-screen concept, the user faces an elegant Victorian Gothic manor or mansion under a full moon. The building should appear maintained, imposing, wealthy, beautiful, and subtly haunted rather than ruined or grotesque.

Potential environmental elements include:

- Full moon.
- Low fog.
- Wet stone.
- Dark trees.
- Dimly illuminated windows.
- Warm candlelight behind selected windows.
- Silver architectural highlights.
- Deep shadows.
- Restrained Victorian landscaping.

Logging in conceptually represents unlocking the front entrance and entering the manor.

## Accessibility and usability

The gothic aesthetic must not require poor usability.

Requirements include:

- High readability for primary text.
- Clear distinction between surfaces.
- Recognizable focus and hover states.
- Semantic states that remain distinguishable.
- Authentication interfaces that remain easy to understand.
- Decorative typography restricted to contexts where it remains readable.
- Atmospheric imagery that does not obscure functional controls.

Darkness should come from the palette and composition, not from making information difficult to see.

## Explicit exclusions

MidnightOnyx Gothic should not use:

- Halloween aesthetics.
- Cartoon skulls.
- Generic black-and-red gamer styling.
- Cyberpunk or neon styling.
- Cheesy vampire imagery.
- Faux-medieval unreadable typography.
- Decorative clutter without architectural purpose.

Pentagrams are not categorically excluded, but they should only appear where they fit the composition and should not become a repetitive theme symbol.

## Design principle

The interface is constructed from onyx, stone, and iron. Its ornament is silver. Its writing is bone. Its blood is crimson.

This principle should remain recognizable across future components even when individual implementations differ.

## Distribution principle

MidnightOnyx Gothic is intended to become distributable.

New components should therefore prefer standard KDE, freedesktop.org, Linux, and application-specific theming mechanisms over machine-specific modifications.

Components should remain modular so users can adopt part or all of the visual environment without requiring unrelated system modifications.
