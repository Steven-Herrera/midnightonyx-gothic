# MidnightOnyx Gothic Project Structure

## Purpose

This document defines the repository architecture, documentation layout,
and information boundaries for MidnightOnyx Gothic.

MidnightOnyx Gothic is intended to become a generic, distributable
theming project. This repository contains reusable source assets,
implementation code, software architecture documentation, visual-design
specifications, build tooling, tests, and packaging required to
distribute the project.

This repository must remain independent of any one workstation or
installation.

## Repository scope

This repository may contain:

-   Canonical visual-language documentation.
-   Canonical color-palette documentation.
-   KDE color schemes.
-   Plasma Styles.
-   Global Themes.
-   Wallpaper packages and wallpaper plugins.
-   Icon themes.
-   Cursor themes.
-   Window decorations.
-   Union styles.
-   Terminal and application themes.
-   Plasma Login Manager integration.
-   Lock-screen integration.
-   Plymouth themes.
-   Bootloader themes.
-   Sound themes.
-   Generic installation and removal tooling.
-   Distribution packaging.
-   Automated tests and validation tooling.
-   Compatibility documentation.
-   Generic software architecture and development documentation.

Not every possible component needs to exist. Directories and
implementation layers should be added when the corresponding component
is actually developed.

## Repository boundary

This repository must not contain information specific to an individual
installation.

Examples of information that does not belong here include:

-   Personal workstation usernames.
-   Hostnames.
-   Home-directory paths containing a workstation username.
-   Hardware serial numbers.
-   Display EDIDs.
-   Machine-specific display identifiers.
-   Local snapshot numbers.
-   Private network information.
-   Machine-specific service state.
-   Personal wallpaper paths.
-   Local filesystem state.
-   Secrets, credentials, tokens, or private keys.
-   Recovery procedures that only apply to one machine.

A public project identity or author identity is not considered
machine-specific state.

Generic examples may use neutral placeholders where necessary.

## Environment-specific documentation

Machine-specific deployment and recovery documentation belongs outside
this repository.

For a particular installation, separate private or environment-specific
documentation should record:

-   Which MidnightOnyx Gothic release is installed.
-   Which components are enabled.
-   Local configuration overrides.
-   Machine-specific Plasma Login Manager state.
-   Display-specific configuration.
-   Snapshot and rollback checkpoints.
-   Verification results.
-   Local compatibility problems.
-   Recovery procedures.

The generic project should document how a component works and how it is
normally installed. Environment-specific documentation should record
what actually happened on a particular machine.

## Source of truth

The canonical source of MidnightOnyx Gothic is this project repository.

Installed copies of theme assets are deployment artifacts and must not
become the source of truth.

For example:

``` text
Repository source
assets/color-schemes/VictorianGothic.colors
        |
        `-- deployed copy
            ~/.local/share/color-schemes/VictorianGothic.colors
```

Changes should be made in the repository and then deployed for testing.

Do not make an installed copy the only location containing a
customization.

## Documentation architecture

Project documentation is divided by responsibility.

``` text
docs/
|-- architecture/
|   |-- architecture-overview.md
|   |-- project-structure.md
|   `-- decisions/
|-- components/
`-- design/
```

### `docs/architecture/`

System-level software architecture documentation.

This area describes:

-   Repository and system boundaries.
-   Architectural constraints.
-   Top-level building blocks and dependencies.
-   Deployment architecture.
-   Cross-cutting technical concepts.
-   Architecture decisions.
-   Compatibility and evolution strategy.

Important architecture decisions that benefit from an explicit decision
record belong under:

``` text
docs/architecture/decisions/
```

### `docs/components/`

Software architecture and implementation documentation for individual
MidnightOnyx Gothic components.

Component documentation should focus on technically relevant information
such as:

-   Responsibilities and boundaries.
-   External interfaces and dependencies.
-   Internal building blocks.
-   Runtime behavior.
-   Deployment and installation model.
-   Configuration.
-   Compatibility constraints.
-   Security considerations.
-   Quality requirements.
-   Testing strategy.
-   Known risks and technical debt.

Component documents may use an arc42-inspired structure where useful,
but should include only sections that add meaningful architectural
information.

### `docs/design/`

Visual-design specifications.

The canonical palette is documented in:

``` text
docs/design/color-palette.md
```

The canonical visual language is documented in:

``` text
docs/design/visual-language.md
```

These documents define artistic and visual intent. They are not software
architecture documents.

Toolkit-specific visual assets consume these specifications and must not
silently redefine the canonical visual language.

### Documentation history

Architecture and component documents describe the current intended
system rather than maintaining independent per-document changelogs.

Repository history and release changes are tracked through structured
commits and the project changelog generated by Commitizen.

## Current directory structure

``` text
midnightonyx-gothic/
|-- assets/
|   |-- color-schemes/
|   `-- wallpapers/
|-- components/
|   |-- plasma-login-manager/
|   `-- wallpaper/
|       `-- manor/
|-- docs/
|   |-- architecture/
|   |   `-- decisions/
|   |-- components/
|   `-- design/
|-- packaging/
|   `-- arch/
`-- tests/
```

This structure should grow incrementally. Directories should represent
implemented components or established architectural responsibilities
rather than speculative future structure.

## Component architecture

Components should be modular whenever practical.

A user should eventually be able to install appropriate subsets of
MidnightOnyx Gothic without being forced to modify unrelated parts of
the system.

A likely high-level distinction is:

``` text
User theme components
    |
    |-- colors
    |-- Plasma appearance
    |-- icons
    |-- cursors
    |-- wallpapers
    `-- application styling

Optional system integration
    |
    |-- Plasma Login Manager
    |-- Plymouth
    `-- bootloader integration
```

Privileged system integration should not be required merely to use
ordinary desktop theme components.

## Upstream-first policy

Prefer supported upstream theming, configuration, and extension
interfaces.

The preferred implementation order is:

1.  Supported configuration.
2.  Standard theme or asset format.
3.  Supported plugin or extension interface.
4.  Standalone project component.
5.  Upstream enhancement when an appropriate extension point does not
    exist.

Core project functionality must not require a maintained downstream
patch to KDE Plasma, KScreenLocker, Plasma Login Manager, or similar
platform software.

An upstream restriction must not be bypassed merely because internal
implementation details make a bypass technically possible.

Direct modification of package-owned files is not an acceptable
distribution strategy.

## Compatibility policy

The project primarily targets current supported versions of its
underlying platforms at release time.

Backward compatibility with older CachyOS, Arch Linux, KDE Plasma, or
other platform releases is not a strict project requirement.

If a release works on older versions without additional maintenance,
that compatibility is welcome.

Development effort should instead prioritize:

-   Current platform compatibility.
-   Forward maintainability.
-   Stable upstream interfaces.
-   Low-maintenance migration to future releases.

Version history may still be studied to identify which upstream
interfaces are stable enough to depend upon.

## Distribution goals

Potential distribution channels include:

-   GitHub releases.
-   KDE Store / Get New Stuff for compatible KDE assets.
-   Arch User Repository packaging for Arch Linux and CachyOS
    integration.
-   Direct source installation for development and unsupported
    platforms.

Distribution mechanisms should consume the same canonical project assets
rather than maintaining divergent copies.

## Versioning and changelog policy

The project uses Semantic Versioning for project releases.

During early development, releases may remain in the `0.x.y` series
while interfaces, assets, and packaging are still evolving.

Structured commit messages should describe the affected component or
project area so release history remains understandable as the repository
grows.

Commitizen is the project mechanism for structured commits, versioning,
and generated changelog history.

Individual architecture, component, and visual-design documents do not
maintain separate changelog sections.

## Security and recovery

Components that affect authentication, login, boot, or privileged system
configuration require additional care.

Such components should provide:

-   Explicit installation behavior.
-   Explicit removal behavior.
-   Recovery documentation where appropriate.
-   Compatibility requirements.
-   Minimal modification of system-owned configuration.
-   Clear separation from ordinary user-level theme assets.

Visual customization must not unnecessarily weaken authentication,
accessibility, boot reliability, or system recovery.
