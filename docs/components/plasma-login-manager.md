# Plasma Login Manager Integration Architecture

## 1. Purpose and Scope

This document defines the MidnightOnyx Gothic integration boundary with
Plasma Login Manager (PLM).

It documents supported configuration and theming surfaces relevant to
the project and records constraints discovered through source inspection
and runtime validation.

MidnightOnyx does not own PLM authentication, session management,
greeter lifecycle, or upstream Breeze components.

## 2. Architecture Constraints

MidnightOnyx PLM integration must:

-   Use supported PLM, KDE, and Plasma configuration mechanisms.
-   Avoid direct modification of package-owned PLM files.
-   Avoid replacing PLM's embedded greeter QML.
-   Avoid maintaining a downstream PLM fork for core project
    functionality.
-   Respect upstream plugin allowlists and other security boundaries.
-   Keep authentication behavior independent of visual customization.
-   Provide explicit recovery for any privileged configuration changes.

## 3. Technical Context

PLM 6.7.4 separates the greeter and wallpaper into distinct runtime
concerns.

``` text
Plasma Login Manager
        |
        +---------------------+
        |                     |
        v                     v
greeter QML              wallpaper process
        |                     |
        v                     v
Breeze/Kirigami          Plasma/Wallpaper
components               KPackage
        |                     |
        v                     v
authentication UI        background surface
```

The greeter is rendered over the wallpaper.

## 4. Greeter Building Blocks

Source inspection of PLM 6.7.4 established that the greeter QML
explicitly imports Breeze components.

Relevant upstream building blocks include:

-   PLM `Main.qml`
-   PLM `Login.qml`
-   Breeze `SessionManagementScreen`
-   Breeze `UserList`
-   Breeze `UserDelegate`
-   Breeze `ActionButton`
-   Breeze `Clock`
-   Plasma/Kirigami controls

The overall login composition and major control geometry are therefore
upstream implementation details rather than MidnightOnyx extension
points.

## 5. Color Integration

PLM's KDE configuration can consume a standard KDE color scheme.

MidnightOnyx uses `VictorianGothic.colors` as the canonical color asset
rather than maintaining a separate PLM-specific palette.

Applying the scheme changes semantic color roles consumed by
KDE/Kirigami/Breeze.

It does not replace the Breeze component geometry or PLM's embedded
login composition.

## 6. Wallpaper Integration

PLM 6.7.4 contains a dedicated wallpaper process.

The runtime:

1.  Loads a `Plasma/Wallpaper` KPackage.
2.  Selects the package identified by PLM's configured wallpaper plugin
    ID.
3.  Loads the package mainscript.
4.  Creates the QML component.
5.  Inserts the resulting `QQuickItem` into the wallpaper container.
6.  Sizes the item to the target screen.
7.  Presents the wallpaper on a Wayland background layer.

This runtime architecture is generic.

### Selection constraint

PLM's settings implementation does not expose every installed
`Plasma/Wallpaper` package.

PLM 6.7.4 uses an explicit allowlist because not all wallpaper plugins
are considered suitable for the login screen due to file-access
concerns.

The tested allowlist includes KDE wallpaper plugins and selected
third-party plugin IDs.

`org.midnightonyx.manor` is not included.

MidnightOnyx therefore does not force the plugin into PLM configuration
despite the generic runtime being technically capable of attempting to
load it.

## 7. Look-and-Feel and Breeze Boundary

PLM's greeter QML explicitly imports `org.kde.breeze.components`.

Look-and-Feel packages that contain similarly named components do not
automatically replace the components imported by the PLM greeter.

A MidnightOnyx Look-and-Feel package must therefore not be treated as a
supported mechanism for replacing PLM's login form geometry unless
upstream PLM changes that contract.

## 8. Supported MidnightOnyx PLM Scope

Current supported integration may include:

-   Standard PLM configuration.
-   Standard KDE color-scheme integration.
-   Supported wallpaper mechanisms exposed by PLM.
-   Fonts, icons, avatars, and other settings only where upstream
    exposes supported configuration for them.

Current core integration excludes:

-   Patched PLM binaries.
-   Rebuilt greeter QML solely for theming.
-   Modified package-owned QML.
-   Bypassing wallpaper-plugin allowlists.
-   Authentication-success hooks implemented through private PLM
    internals.

## 9. Deployment and Recovery

PLM configuration is system-level state and should be treated as
privileged integration.

Development changes should:

-   Preserve existing configuration before modification.
-   Keep ownership and permissions appropriate to the `plasmalogin`
    account.
-   Prefer KDE/PLM tooling over manually reproducing internal
    transformations.
-   Be reversible without replacing upstream packages.

Machine-specific backups, snapshot identifiers, and recovery checkpoints
belong in environment-specific documentation outside this public
repository.

## 10. Compatibility Strategy

PLM is a comparatively new and evolving upstream component.

The project targets current supported PLM behavior at release time
rather than promising compatibility with historical PLM versions.

Source inspection should be repeated when targeted PLM releases change
materially, especially around:

-   greeter QML imports,
-   wallpaper plugin selection,
-   configuration schemas,
-   wallpaper process architecture,
-   KCM behavior.

## 11. Testing Strategy

PLM integration testing should include:

-   Configuration discovery.
-   Asset discovery under the `plasmalogin` account.
-   Ownership and permission verification.
-   Reboot persistence.
-   Successful authentication.
-   Session startup.
-   Journal inspection for greeter or wallpaper failures.
-   Removal or restoration testing for privileged changes.

## 12. Risks and Open Issues

-   PLM interfaces and implementation may change between Plasma
    releases.
-   Breeze component geometry is not a MidnightOnyx extension point.
-   PLM may restrict additional third-party plugin types for security
    reasons.
-   Supported wallpaper-plugin selection does not currently include
    MidnightOnyx Manor.
-   Visual changes must not interfere with authentication or session
    startup.
