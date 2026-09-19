# MidnightOnyx Gothic Project Structure

## Purpose

This document defines the repository architecture and information boundaries for MidnightOnyx Gothic.

MidnightOnyx Gothic is intended to become a generic, distributable Victorian Gothic theming project. This repository contains reusable source assets, implementation code, architecture documentation, build tooling, tests, and packaging required to distribute the theme.

This repository must remain independent of any one workstation or installation.

## Repository scope

This repository may contain:

- Canonical visual-language documentation.
- Canonical color-palette documentation.
- KDE color schemes.
- Plasma Styles.
- Global Themes.
- Wallpaper packages and wallpaper plugins.
- Icon themes.
- Cursor themes.
- Window decorations.
- Union styles.
- Terminal and application themes.
- Plasma Login Manager integration.
- Lock-screen integration.
- Plymouth themes.
- Bootloader themes.
- Sound themes.
- Generic installation and removal tooling.
- Distribution packaging.
- Automated tests and validation tooling.
- Compatibility documentation.
- Generic architecture and development documentation.

Not every possible component needs to exist. Directories and implementation layers should be added when the corresponding component is actually developed.

## Repository boundary

This repository must not contain information specific to an individual installation.

Examples of information that does not belong here include:

- Personal usernames.
- Hostnames.
- Home-directory paths containing a username.
- Hardware serial numbers.
- Display EDIDs.
- Machine-specific display identifiers.
- Local snapshot numbers.
- Private network information.
- Machine-specific service state.
- Personal wallpaper paths.
- Local filesystem state.
- Secrets, credentials, tokens, or private keys.
- Recovery procedures that only apply to one machine.

Generic examples may use neutral placeholders where necessary.

## Environment-specific documentation

Machine-specific deployment and recovery documentation belongs outside this repository.

For a particular installation, separate private or environment-specific documentation should record:

- Which MidnightOnyx Gothic release is installed.
- Which components are enabled.
- Local configuration overrides.
- Machine-specific Plasma Login Manager state.
- Display-specific configuration.
- Snapshot and rollback checkpoints.
- Verification results.
- Local compatibility problems.
- Recovery procedures.

The generic project should document how a component works and how it is normally installed. Environment-specific documentation should record what actually happened on a particular machine.

## Source of truth

The canonical source of MidnightOnyx Gothic is this project repository.

Installed copies of theme assets are deployment artifacts and must not become the source of truth.

For example:

```text
Repository source
assets/color-schemes/VictorianGothic.colors
        │
        └── deployed copy
            ~/.local/share/color-schemes/VictorianGothic.colors
```

Changes should be made in the repository and then deployed for testing.

Do not make an installed copy the only location containing a customization.

## Canonical design sources

Human-readable design intent is defined under:

```text
docs/design/
```

The canonical palette is documented in:

```text
docs/design/color-palette.md
```

The canonical visual language is documented in:

```text
docs/design/visual-language.md
```

Toolkit-specific assets are consumers of those specifications.

A KDE `.colors` file, Union stylesheet, wallpaper, icon theme, or other implementation must not silently redefine the canonical visual language.

## Initial directory structure

```text
midnightonyx-gothic/
├── assets/
│   ├── color-schemes/
│   └── wallpapers/
├── components/
│   └── plasma-login-manager/
├── docs/
│   ├── architecture/
│   └── design/
├── packaging/
│   └── arch/
└── tests/
```

This structure should grow incrementally.

## Component architecture

Components should be modular whenever practical.

A user should eventually be able to install appropriate subsets of MidnightOnyx Gothic without being forced to modify unrelated parts of the system.

A likely high-level distinction is:

```text
User theme components
    │
    ├── colors
    ├── Plasma appearance
    ├── icons
    ├── cursors
    ├── wallpapers
    └── application styling

Optional system integration
    │
    ├── Plasma Login Manager
    ├── Plymouth
    └── bootloader integration
```

Privileged system integration should not be required merely to use ordinary desktop theme components.

## Upstream-first policy

Prefer supported upstream theming and configuration interfaces.

The preferred implementation order is:

1. Supported configuration.
2. Standard theme or asset format.
3. Supported plugin or extension interface.
4. Standalone project component.
5. Maintained downstream patch only when the desired result cannot reasonably be achieved otherwise.

Direct modification of package-owned files is not an acceptable distribution strategy.

## Compatibility policy

The project primarily targets current supported versions of its underlying platforms at release time.

Backward compatibility with older CachyOS, Arch Linux, KDE Plasma, or other platform releases is not a strict project requirement.

If a release works on older versions without additional maintenance, that compatibility is welcome.

Development effort should instead prioritize:

- Current platform compatibility.
- Forward maintainability.
- Stable upstream interfaces.
- Low-maintenance migration to future releases.

Version history may still be studied to identify which upstream interfaces are stable enough to depend upon.

## Distribution goals

Potential distribution channels include:

- GitHub releases.
- KDE Store / Get New Stuff for compatible KDE assets.
- Arch User Repository packaging for Arch Linux and CachyOS integration.
- Direct source installation for development and unsupported platforms.

Distribution mechanisms should consume the same canonical project assets rather than maintaining divergent copies.

## Versioning and changelog policy

The project uses Semantic Versioning for project releases.

During early development, releases may remain in the `0.x.y` series while interfaces, assets, and packaging are still evolving.

Structured commit messages should describe the affected component or project area so release history remains understandable as the repository grows.

Automated changelog and release tooling may be used as long as it does not impose language- or toolkit-specific architecture on the project.

## Security and recovery

Components that affect authentication, login, boot, or privileged system configuration require additional care.

Such components should provide:

- Explicit installation behavior.
- Explicit removal behavior.
- Recovery documentation.
- Compatibility requirements.
- Minimal modification of system-owned configuration.
- Clear separation from ordinary user-level theme assets.

Visual customization must not unnecessarily weaken authentication, accessibility, boot reliability, or system recovery.
