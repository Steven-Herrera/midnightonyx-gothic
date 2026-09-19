# MidnightOnyx Gothic Architecture

## 1. Introduction and Goals

MidnightOnyx Gothic is a modular theming system for KDE Plasma and
related Linux desktop components.

The repository contains reusable visual assets, executable theming
components, integration code, packaging, tests, and architecture
documentation required to build and distribute the project.

The architecture is intentionally independent of any particular
workstation.

### Quality goals

The primary architecture goals are:

1.  Use supported upstream extension and configuration interfaces.
2.  Remain maintainable across future KDE Plasma releases.
3.  Keep components independently installable where practical.
4.  Separate unprivileged theme assets from privileged system
    integration.
5.  Make installation, upgrade, removal, and recovery explicit.
6.  Keep canonical source assets in the repository rather than installed
    locations.
7.  Support distribution without embedding machine-specific assumptions.
8.  Avoid weakening authentication, locking, session startup, or boot
    reliability.

## 2. Architecture Constraints

### Supported upstream interfaces

Core functionality must use supported upstream interfaces where
practical.

Direct modification of package-owned files is not a distribution
mechanism.

A downstream patch to KDE Plasma, KScreenLocker, Plasma Login Manager,
or another platform component must not be required for core
functionality.

### Platform targeting

Releases primarily target current supported versions of KDE Plasma and
the relevant Arch Linux/CachyOS ecosystem at release time.

Backward compatibility is desirable when obtained without substantial
maintenance burden but is not a primary architecture goal.

### Repository independence

The public repository must not depend on machine-specific usernames,
paths, display identifiers, snapshots, service state, or other
installation-specific information.

### Security boundaries

Authentication, login, screen locking, boot, and privileged
configuration are security-sensitive integration boundaries.

Visual customization must not weaken authentication or require
unnecessary privilege.

## 3. Context and Scope

MidnightOnyx Gothic integrates with existing platform components rather
than replacing them.

``` text
                    MidnightOnyx Gothic
                           |
          +----------------+----------------+
          |                |                |
          v                v                v
     KDE Frameworks    KDE Plasma       Qt / Qt Quick
          |                |                |
          +----------------+----------------+
                           |
              +------------+------------+
              |                         |
              v                         v
        KScreenLocker           Plasma Login Manager
```

Additional components may integrate with Plymouth, bootloaders, terminal
applications, icon systems, window decorations, or other supported
theming interfaces.

The project owns its theme assets, plugin code, integration helpers,
tests, and packaging. It does not own the lifecycle or security behavior
of upstream KDE components.

## 4. Solution Strategy

MidnightOnyx Gothic is decomposed into standard platform-native theme
assets and narrowly scoped integration components.

The preferred implementation hierarchy is:

1.  Standard configuration.
2.  Standard theme or asset format.
3.  Supported plugin or extension.
4.  Standalone integration component.
5.  Upstream enhancement when an appropriate supported extension point
    does not exist.

Maintained downstream platform patches are intentionally excluded from
the core architecture.

## 5. Building Block View

### Visual assets

Canonical platform-consumable assets such as KDE color schemes, icons,
cursors, wallpapers, and related resources.

### Executable Plasma components

QML/KPackage components that execute within supported Plasma extension
points, such as `Plasma/Wallpaper`.

### Platform integration

Components that connect project assets to KDE Plasma, KScreenLocker,
Plasma Login Manager, or other supported platform facilities.

### Packaging

Distribution-specific installation and removal mechanisms.

Packaging consumes canonical repository artifacts rather than
maintaining independent copies.

### Tests

Validation for package structure, metadata, installation behavior,
compatibility, runtime behavior, and project invariants.

### Documentation

Architecture, component, and visual-design specifications maintained
alongside implementation.

## 6. Runtime View

Runtime behavior is component-specific.

The common pattern is:

``` text
repository artifact
        |
        v
installed package or asset
        |
        v
upstream KDE/Plasma extension point
        |
        v
upstream runtime
```

MidnightOnyx components must not assume ownership of upstream
authentication, session, or screen-locking state unless a documented
public interface explicitly provides it.

## 7. Deployment View

User-level components should prefer XDG user locations when system-wide
installation is unnecessary.

System-wide installation is used only where the target subsystem
requires assets to be available outside an individual user session or
where distribution packaging intentionally provides the component
globally.

Installed artifacts are deployment copies. Repository files remain
canonical.

Development deployments should be easy to replace or remove without
editing package-owned upstream files.

## 8. Cross-Cutting Concepts

### Component modularity

Components should be independently installable where practical.

### Upgradeability

Integration should minimize assumptions about internal implementation
details of upstream software.

### Reversibility

Installation mechanisms should provide corresponding removal behavior.

### Provenance

Release assets must have redistribution rights compatible with project
distribution.

### Configuration ownership

MidnightOnyx Gothic should modify only configuration and assets required
for the selected component.

### Observability

Development and integration testing should use upstream logs, package
inspection tools, and deterministic validation where available.

## 9. Architecture Decisions

Significant decisions are recorded under:

``` text
docs/architecture/decisions/
```

Architecture decision records document context, decision, alternatives
where relevant, and consequences.

## 10. Quality Requirements

### Maintainability

An upstream platform upgrade should normally require adapting a bounded
integration component rather than redesigning unrelated project
components.

### Modularity

Users should be able to install relevant subsets of the project without
enabling unrelated system integrations.

### Reliability

Wallpaper and appearance components must not interfere with
authentication, unlocking, session startup, or system boot.

### Performance

Continuously running visual components must avoid disproportionate CPU,
GPU, and memory consumption.

### Portability

Generic project components must not encode workstation-specific paths or
identifiers.

### Recoverability

Privileged integrations must have an explicit removal or recovery path
appropriate to their risk.

## 11. Risks and Technical Debt

Current architectural risks include:

-   Upstream KDE interfaces may evolve between Plasma releases.
-   Some desired appearance surfaces may not expose supported extension
    points.
-   Security-sensitive components may deliberately restrict third-party
    customization.
-   Animated visual components may introduce unnecessary resource
    consumption if not profiled.
-   Distribution across multiple KDE asset systems may require
    component-specific packaging and compatibility handling.
-   Early development currently relies on prototype artwork that is
    intentionally excluded from release artifacts.

## 12. Glossary

  -----------------------------------------------------------------------
  Term                                Definition
  ----------------------------------- -----------------------------------
  KPackage                            KDE package infrastructure used by
                                      multiple Plasma extension types.

  `Plasma/Wallpaper`                  KPackage type used for Plasma
                                      wallpaper plugins.

  KScreenLocker                       KDE Plasma screen-locking
                                      subsystem.

  PLM                                 Plasma Login Manager.

  Deployment artifact                 Installed copy of a canonical
                                      repository asset or package.

  Upstream extension point            Supported configuration, package,
                                      plugin, or API surface provided by
                                      the platform.
  -----------------------------------------------------------------------
