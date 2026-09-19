# ADR 0001: Use Supported Upstream Extension Points

## Status

Accepted.

## Context

MidnightOnyx Gothic integrates with KDE Plasma and other system
components whose behavior and internal implementation evolve over time.

Some desired customizations can be achieved either through supported
configuration and plugin interfaces or through downstream modification
of upstream software.

Maintaining patched copies of KDE or Plasma components would increase
compatibility work, complicate distribution, expand the
security-sensitive code owned by the project, and make upgrades
dependent on internal upstream implementation details.

Investigation of Plasma Login Manager 6.7.4 demonstrated this
distinction directly.

PLM's wallpaper runtime uses the generic `Plasma/Wallpaper` KPackage
infrastructure, but its configuration layer intentionally exposes only
an explicit allowlist of wallpaper plugins for the login environment.

The MidnightOnyx Manor wallpaper is a valid `Plasma/Wallpaper` plugin
and is supported by Plasma desktop and KScreenLocker, but it is not
currently included in PLM's wallpaper allowlist.

## Decision

Core MidnightOnyx Gothic functionality will use supported upstream
configuration, asset formats, plugin interfaces, and extension
mechanisms.

The project will not require patched KDE Plasma, KScreenLocker, Plasma
Login Manager, or similar platform packages for core functionality.

An upstream restriction will not be bypassed merely because internal
implementation details make a bypass technically possible.

When a desired capability lacks an appropriate supported extension
point, the project may:

1.  Provide the feature only on supported targets.
2.  Seek or contribute an upstream extension point.
3.  Defer the feature.

## Alternatives Considered

### Maintain downstream platform patches

Rejected for core functionality because it increases upgrade cost,
security-sensitive maintenance, packaging complexity, and coupling to
upstream internals.

### Modify package-owned files after installation

Rejected because package upgrades can overwrite changes and the
resulting state is difficult to distribute, verify, remove, and support.

### Write unsupported configuration directly

Rejected when the configuration bypasses an explicit upstream
restriction or safety boundary.

## Consequences

### Positive

-   Lower maintenance burden across upstream releases.
-   Cleaner distribution and removal.
-   Smaller security-sensitive maintenance surface.
-   Better compatibility with distribution packages.
-   Clearer ownership boundary between MidnightOnyx and upstream
    software.
-   Easier diagnosis of failures.

### Negative

-   Some visual features may not be available on every target.
-   Feature availability may depend on upstream acceptance or API
    evolution.
-   Some desired integrations may need to be deferred.

## Current Application

`org.midnightonyx.manor` is supported as a Plasma desktop and
KScreenLocker wallpaper.

The project does not bypass Plasma Login Manager's wallpaper-plugin
allowlist to force the component onto the login screen.

Future supported PLM integration may be adopted if upstream exposes or
approves an appropriate mechanism.
