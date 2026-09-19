# MidnightOnyx Gothic Color Palette

## Purpose

This document defines the canonical MidnightOnyx Gothic color vocabulary.

The palette is implementation-independent. KDE color schemes, Plasma Styles, Union styles, wallpapers, icons, terminal schemes, boot themes, and other components should derive their colors from this specification rather than treating any one generated theme file as the canonical source.

## Design philosophy

The palette represents an elegant Victorian Gothic manor constructed from near-black stone and onyx, decorated with silver, written in bone, and punctuated by restrained crimson.

Environmental lighting introduces cool moonlight and warm candlelight.

The primary interaction rule is:

> Silver means interactive. Crimson means consequential.

Crimson should remain relatively rare. Large amounts of bright red risk turning the design into a generic black-and-red gamer theme.

## Core surfaces

| Name | Hex | RGB | Intended role |
|---|---|---|---|
| Void | `#080709` | `8,7,9` | Deepest background and shadow |
| Onyx | `#100E12` | `16,14,18` | Primary deep surface |
| Obsidian | `#18151B` | `24,21,27` | Main UI surface |
| Black Stone | `#211D23` | `33,29,35` | Elevated and raised surfaces |
| Ash | `#302B31` | `48,43,49` | Borders and secondary structure |

The core surfaces deliberately avoid pure neutral black. Their subtle warm-violet character provides depth while remaining visually near-black.

## Typography

| Name | Hex | RGB | Intended role |
|---|---|---|---|
| Bone | `#E7DFD1` | `231,223,209` | Primary text |
| Old Silver | `#B9B2B3` | `185,178,179` | Secondary and inactive text |
| Tarnished Silver | `#817A80` | `129,122,128` | Disabled and subdued text |

Bone is the principal foreground rather than pure white.

This provides strong contrast against the dark surfaces while avoiding the visually harsh quality of bright digital white.

## Metal accents

| Name | Hex | RGB | Intended role |
|---|---|---|---|
| Iron | `#48434B` | `72,67,75` | Quiet structure and low-emphasis borders |
| Pewter | `#716C74` | `113,108,116` | Ordinary borders and secondary metal |
| Sterling | `#A7A2AA` | `167,162,170` | Focus and active structural accents |
| Moon Silver | `#D0CDD2` | `208,205,210` | Bright hover and metallic highlights |

Silver is the ordinary interactive language of the theme.

Controls should normally become brighter or more metallic as interaction emphasis increases.

## Crimson family

| Name | Hex | RGB | Intended role |
|---|---|---|---|
| Wine | `#54202C` | `84,32,44` | Selection and subdued crimson surfaces |
| Crimson | `#8E2638` | `142,38,56` | Dramatic active emphasis |
| Blood | `#B63848` | `182,56,72` | Danger, failure, and rare strong emphasis |

Wine and Crimson are the preferred members of this family.

Blood should be used sparingly.

## Environmental light

| Name | Hex | RGB | Intended role |
|---|---|---|---|
| Moonlight | `#9CAFC5` | `156,175,197` | Cool environmental illumination |
| Candlelight | `#D2A45F` | `210,164,95` | Warm environmental illumination |

Environmental colors should generally support imagery and atmosphere rather than dominate ordinary interface chrome.

## Semantic states

| State | Name | Hex | RGB |
|---|---|---|---|
| Success | Ivy | `#63806A` | `99,128,106` |
| Warning | Antique Amber | `#C4934D` | `196,147,77` |
| Information | Moon Blue | `#7894B0` | `120,148,176` |
| Danger | Blood | `#B63848` | `182,56,72` |

Semantic colors remain distinct instead of forcing every system state into the crimson family.

Ivy should resemble subdued vegetation against wet stone rather than bright status-indicator green.

Warning should resemble antique warm light rather than saturated yellow.

Information should relate to moonlight without duplicating the brighter environmental Moonlight color.

## Excluded colors

The following colors were considered and intentionally excluded from the approved baseline:

| Name | Hex | Reason |
|---|---|---|
| Ivory | `#F5F0E6` | Too bright and visually harsh against the approved dark surfaces |
| Rose Ash | `#C27A83` | Unnecessary lighter crimson; weakens the preferred Wine/Crimson hierarchy |

Excluded colors should not be reintroduced casually. If a future component requires one, document the design reason first.

## Interaction hierarchy

The initial interaction hierarchy is:

```text
Normal foreground    Bone
Inactive foreground  Old Silver
Disabled foreground  Tarnished Silver

Quiet structure      Iron
Border               Pewter
Focus                Sterling
Hover                Moon Silver

Selection            Wine
Active emphasis      Crimson
Danger               Blood
```

This hierarchy should be treated as a starting rule rather than a requirement to force identical behavior onto every toolkit.

## Surface hierarchy

The initial surface hierarchy is:

```text
Void
  ↓
Onyx
  ↓
Obsidian
  ↓
Black Stone
  ↓
Ash
```

Increasing brightness generally represents increasing elevation or structural visibility.

## KDE color-scheme mapping

The first KDE implementation is:

```text
assets/color-schemes/VictorianGothic.colors
```

The KDE asset is a consumer of this palette, not its canonical definition.

The initial mapping uses:

| KDE concept | Palette role |
|---|---|
| Deep view/complementary background | Onyx |
| Window background | Obsidian |
| Raised/button background | Black Stone |
| Normal foreground | Bone |
| Inactive foreground | Old Silver |
| Disabled foreground | Tarnished Silver |
| Focus decoration | Sterling |
| Hover decoration | Moon Silver |
| Selection background | Wine |
| Active emphasis | Crimson |
| Negative state | Blood |
| Positive state | Ivy |
| Neutral/warning state | Antique Amber |
| Link/information state | Moon Blue |

The first KDE color-scheme implementation has been visually tested in Plasma and accepted as the initial baseline.

## Accessibility

Primary text must maintain strong contrast against normal surfaces.

Secondary text should remain clearly readable and must not be confused with disabled text.

Interactive state changes should not rely solely on crimson.

Semantic states should remain distinguishable by context and presentation in addition to color where the target toolkit permits it.

Future palette revisions should include automated contrast checks for important foreground/background combinations.

## Versioning

The approved palette should evolve deliberately.

When a canonical color changes:

1. Update this document.
2. Update downstream theme assets.
3. Test affected components.
4. Record the reason in the project changelog or commit history.

Component-specific deviations are permitted when required by toolkit semantics, but they should be documented rather than silently redefining the canonical palette.
