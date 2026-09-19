# MidnightOnyx Manor Wallpaper Architecture

## 1. Purpose and Scope

`org.midnightonyx.manor` is a Plasma Wallpaper plugin that provides the
wallpaper runtime for MidnightOnyx Gothic.

The component is responsible for rendering project wallpaper assets and
for executing supported Qt Quick animation used by the wallpaper.

It is not responsible for authentication, screen locking, session
management, or desktop-shell lifecycle.

## 2. Architecture Constraints

The component must:

-   Use the standard `Plasma/Wallpaper` KPackage interface.
-   Run without patching Plasma or KScreenLocker.
-   Use package-relative release assets.
-   Avoid dependencies on machine-specific filesystem paths.
-   Remain usable when animation is absent or disabled.
-   Avoid requiring privileged execution at runtime.

Plasma Login Manager integration must respect PLM's supported
wallpaper-plugin selection policy.

## 3. Technical Context

``` text
                    KPackage
                       |
                       v
             org.midnightonyx.manor
                       |
                 metadata.json
                       |
                       v
              contents/ui/main.qml
                       |
                       v
                  WallpaperItem
                       |
                       v
               Qt Quick scene graph
                    +--+--+
                    |     |
                    v     v
             plasmashell  KScreenLocker
```

The same package may be installed for an individual user or system-wide.

## 4. Solution Strategy

The wallpaper is implemented as a standard Plasma Wallpaper package.

The root QML object is `WallpaperItem`. Artwork is loaded using
package-relative URLs. The base implementation uses
`Image.PreserveAspectCrop` to fill the target surface without stretching
source artwork.

Animation is implemented through ordinary Qt Quick/QML components inside
the wallpaper scene graph.

Major effects should be isolated into focused QML components rather than
accumulating unrelated behavior in `main.qml`.

## 5. Building Block View

### Package structure

Current source structure:

``` text
components/wallpaper/manor/
|-- metadata.json
`-- contents/
    |-- images/
    |   `-- manor-prototype.png
    `-- ui/
        `-- main.qml
```

`manor-prototype.png` is a development-only asset and is excluded from
Git.

Release artwork will replace development prototype assets before
distribution.

### `metadata.json`

Declares the component as a `Plasma/Wallpaper` KPackage with plugin ID:

``` text
org.midnightonyx.manor
```

The plugin ID is the stable package identity used by KPackage and Plasma
configuration.

### `main.qml`

The QML entry point.

Responsibilities:

-   Establish the wallpaper scene.
-   Load package-relative artwork.
-   Preserve source aspect ratio.
-   Fill the available surface without stretching.
-   Compose visual-effect components.

### Image assets

Image assets are loaded relative to the package.

Release assets must not depend on paths under a particular user's home
directory.

### Effect components

Animation should be decomposed into focused QML components.

The exact component decomposition is not yet a stable interface.

A diagnostic `AtmosphereLayer.qml` was used during development to prove
child-component rendering and continuous animation. It was intentionally
removed after validation and is not part of the component architecture.

## 6. Runtime View

### Plasma desktop

``` text
plasmashell
    |
    v
KPackage resolves org.midnightonyx.manor
    |
    v
main.qml instantiated
    |
    v
WallpaperItem renders into desktop containment
```

This runtime path has been validated.

### KScreenLocker

``` text
KScreenLocker
    |
    v
configured wallpaper type
    |
    v
KPackage resolves org.midnightonyx.manor
    |
    v
main.qml instantiated
    |
    v
WallpaperItem renders behind lock-screen UI
```

Static rendering, aspect-ratio preservation, normal unlocking, custom
QML child rendering, and continuous QML property animation have been
experimentally validated.

### Plasma Login Manager

PLM 6.7.4 uses the `Plasma/Wallpaper` KPackage infrastructure internally
and can instantiate its selected wallpaper package.

However, its settings layer filters available wallpaper plugins through
an explicit allowlist because not all wallpaper plugins are considered
suitable for the login environment.

`org.midnightonyx.manor` is not currently included in that allowlist.

The project therefore does not configure PLM to use this plugin unless a
supported upstream mechanism makes the plugin available.

## 7. Deployment View

### Per-user development installation

Install:

``` fish
kpackagetool6 \
    --type=Plasma/Wallpaper \
    --install components/wallpaper/manor
```

Upgrade:

``` fish
kpackagetool6 \
    --type=Plasma/Wallpaper \
    --upgrade components/wallpaper/manor
```

The resulting package is installed beneath the user's Plasma wallpaper
package directory.

Development should prefer per-user installation unless system-wide
behavior is specifically under test.

### System-wide installation

Install:

``` fish
sudo kpackagetool6 \
    --type=Plasma/Wallpaper \
    --global \
    --install components/wallpaper/manor
```

Upgrade:

``` fish
sudo kpackagetool6 \
    --type=Plasma/Wallpaper \
    --global \
    --upgrade components/wallpaper/manor
```

System-wide deployment is intended for distribution packaging or
integration requiring availability outside a single user's package
search path.

### Source and deployment copies

The repository component is canonical.

Installed user and system copies are deployment artifacts and should be
replaced from repository source during development.

## 8. Cross-Cutting Concepts

### Asset provenance

Prototype artwork is excluded from Git. Release artwork must have
documented redistribution rights.

### Configuration isolation

The wallpaper plugin does not own authentication, lock-screen, or
session configuration.

### Graceful degradation

The base wallpaper must remain valid if optional animation components
are absent.

### Performance

Animation should transform already-loaded scene elements where practical
rather than relying on expensive repeated media decoding.

## 9. Architecture Decisions

The component follows ADR 0001: supported upstream extension points are
preferred and upstream restrictions are not bypassed.

The component does not patch KScreenLocker or PLM.

## 10. Quality Requirements

### Reliability

Wallpaper failure must not interfere with unlocking or session
operation.

### Performance

Animation must be profiled before release for CPU, GPU, and memory cost.

### Maintainability

The implementation should depend on public Plasma wallpaper APIs rather
than implementation details of plasmashell or KScreenLocker.

### Portability

Runtime assets must be package-relative and independent of
machine-specific paths.

### Graceful degradation

The wallpaper should remain valid if optional animation components are
absent.

## 11. Validated Behavior

  -----------------------------------------------------------------------
  Capability                          Status
  ----------------------------------- -----------------------------------
  KPackage recognizes package         Validated

  Package appears as Plasma wallpaper Validated
  type                                

  Static desktop rendering            Validated

  Aspect-ratio-preserving crop        Validated

  KScreenLocker discovery             Validated

  Static lock-screen rendering        Validated

  Normal unlock with custom wallpaper Validated

  Custom child QML component          Validated
  rendering                           

  Continuous QML animation on desktop Validated

  Continuous QML animation on lock    Validated
  screen                              

  PLM selection                       Not supported for this plugin under
                                      the tested PLM allowlist
  -----------------------------------------------------------------------

## 12. Testing Strategy

Tests should eventually cover:

-   Metadata validity.
-   Required package files.
-   Package installation.
-   Package upgrade.
-   Package removal.
-   QML loadability.
-   Missing-asset behavior.
-   Aspect-ratio behavior.
-   Desktop runtime.
-   KScreenLocker runtime.
-   Animation resource consumption.
-   Compatibility with targeted Plasma releases.

## 13. Risks and Open Issues

-   Plasma wallpaper APIs may evolve.
-   KScreenLocker behavior may change between Plasma releases.
-   Long-running animation may impose unacceptable resource cost.
-   Final artwork format and resource requirements are not yet fixed.
-   PLM currently restricts selectable wallpaper plugins through an
    upstream allowlist.
