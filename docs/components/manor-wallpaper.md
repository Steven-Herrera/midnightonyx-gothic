# MidnightOnyx Manor Wallpaper Architecture

## 1. Purpose and Scope

`org.midnightonyx.manor` is a Plasma Wallpaper plugin that provides the
wallpaper runtime for MidnightOnyx Gothic.

The component renders project wallpaper assets and executes supported Qt
Quick animation. It is not responsible for authentication, screen
locking, session management, or desktop-shell lifecycle.

## 2. Architecture Constraints

The component must:

-   Use the standard `Plasma/Wallpaper` KPackage interface.
-   Run without patching Plasma or KScreenLocker.
-   Use package-relative release assets.
-   Avoid machine-specific filesystem paths.
-   Remain usable when animation is absent or disabled.
-   Avoid requiring privileged execution at runtime.
-   Keep scene-specific tuning separate from reusable effect mechanics
    where practical.

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
              +--------+--------+
              |                 |
              v                 v
       base scene Image    FogLayer.qml
              |                 |
              +--------+--------+
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

The wallpaper is a standard Plasma Wallpaper package. The root QML
object is `WallpaperItem`. Artwork is loaded with package-relative URLs.

The base scene uses `Image.PreserveAspectCrop`. Animation is implemented
with ordinary Qt Quick/QML components.

`main.qml` owns scene composition and scene-specific tuning. Effect
components such as `FogLayer.qml` own reusable rendering and animation
mechanics and provide default values.

## 5. Building Block View

### Package structure

``` text
components/wallpaper/manor/
|-- metadata.json
`-- contents/
    |-- images/
    |   |-- midnight-manor.png
    |   `-- midnight-fog.png
    `-- ui/
        |-- FogLayer.qml
        `-- main.qml
```

Local files whose names contain `-prototype` are development-only assets
and are excluded from Git.

### `metadata.json`

Declares a `Plasma/Wallpaper` KPackage with plugin ID
`org.midnightonyx.manor`.

### `main.qml`

`main.qml` is the QML entry point and scene-composition layer. It loads
the manor artwork, instantiates effects, and supplies scene-specific
effect parameters.

The currently accepted fog configuration is:

``` qml
fogOpacity: 0.30
fogScale: 0.40
verticalPosition: 0.67
driftDuration: 89000
```

These are visual configuration values, not part of the renderer's
algorithmic contract.

### `midnight-manor.png`

Current release base-scene asset:

-   PNG
-   1672 x 941
-   sRGB
-   RGB without alpha

It is rendered with `Image.PreserveAspectCrop`.

### `midnight-fog.png`

Current release fog texture:

-   PNG
-   2000 x 667
-   sRGB
-   RGBA with alpha

The texture is horizontally seam-compatible for continuous repetition.

### `FogLayer.qml`

`FogLayer.qml` implements one logical continuously drifting fog field.

Its public tuning properties are:

``` qml
property url source
property real fogOpacity
property real fogScale
property real verticalPosition
property int driftDuration
```

For the current asset, rendered geometry is derived from the 2000:667
source ratio:

``` qml
readonly property real tileAspectRatio: 2000 / 667
readonly property real tileHeight: root.height * root.fogScale
readonly property real tileWidth: tileHeight * root.tileAspectRatio
```

This preserves the source aspect ratio while uniformly resampling the
texture.

### Three-tile renderer

One logical fog field is implemented with three adjacent `Image`
instances:

``` text
+----------+----------+----------+
|  fog A   |  fog B   |  fog C   |
+----------+----------+----------+
```

These are rendering tiles, not three independent fog layers.

The tile group translates by exactly one tile width:

``` qml
from: -root.tileWidth / 2
to: -(root.tileWidth * 1.5)
```

Because the source texture is horizontally seam-compatible, the infinite
reset occurs at a visually equivalent texture position.

The half-tile initial offset deliberately keeps neighboring texture
content intersecting the active rendering region.

### Image readiness gate

Animation begins only after all three tiles report `Image.Ready`:

``` qml
readonly property bool imagesReady:
    fogA.status === Image.Ready &&
    fogB.status === Image.Ready &&
    fogC.status === Image.Ready
```

The animation binds `running` to `imagesReady`.

This provides deterministic startup. The three-tile viewport arrangement
separately addresses the observed off-screen realization issue.

### Removed diagnostic component

`AtmosphereLayer.qml` was used temporarily to validate child-component
rendering and continuous animation. It was removed and is not part of
the architecture.

## 6. Runtime View

### Plasma desktop

``` text
plasmashell
    |
    v
KPackage resolves org.midnightonyx.manor
    |
    v
main.qml
    |
    +--> midnight-manor.png
    `--> FogLayer.qml
             |
             `--> three fog rendering tiles
    |
    v
WallpaperItem renders into desktop containment
```

Static rendering, alpha compositing, and continuous fog animation are
validated.

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
main.qml
    |
    +--> base manor scene
    `--> continuously animated fog field
    |
    v
WallpaperItem renders behind lock-screen UI
```

Static rendering, aspect-ratio preservation, normal unlocking, custom
child QML, continuous animation, alpha-composited fog, and continuous
fog drift have been experimentally validated.

### Fog animation lifecycle

``` text
FogLayer instantiated
        |
        v
three Image objects resolve the package-relative fog asset
        |
        v
fogA, fogB, and fogC reach Image.Ready
        |
        v
imagesReady becomes true
        |
        v
linear x animation begins
        |
        v
three-tile field translates one tile width
        |
        v
animation repeats at a visually equivalent texture position
```

### Off-screen tile realization finding

An earlier two-tile implementation positioned the upcoming tile
completely outside the initial viewport.

Both tiles reported `Image.Ready`, including with asynchronous loading
disabled, but the leading edge of the upcoming tile could remain
visually absent briefly when it first entered the viewport. A readiness
gate alone did not remove the artifact.

The validated workaround is the current three-tile renderer with a
half-tile initial offset. This keeps neighboring texture content
intersecting the active rendering region while preserving continuous
one-tile translation.

The exact upstream scene-graph behavior causing the two-tile artifact
has not been established, so this is documented as an empirically
validated rendering constraint rather than a confirmed Qt defect.

### Plasma Login Manager

PLM 6.7.4 uses `Plasma/Wallpaper` KPackage infrastructure internally,
but its settings layer exposes only an explicit allowlist of wallpaper
plugins.

`org.midnightonyx.manor` is not currently allowlisted. The project
therefore does not force PLM to use the plugin.

## 7. Deployment View

### Per-user development installation

Install:

``` fish
kpackagetool6 \
    --type=Plasma/Wallpaper \
    --install "$PWD/components/wallpaper/manor"
```

Upgrade and refresh:

``` fish
kpackagetool6 \
    --type=Plasma/Wallpaper \
    --upgrade "$PWD/components/wallpaper/manor"; and \
systemctl --user restart plasma-plasmashell.service
```

Using `and` prevents the Plasma restart if package upgrade fails.

### System-wide installation

``` fish
sudo kpackagetool6 \
    --type=Plasma/Wallpaper \
    --global \
    --install "$PWD/components/wallpaper/manor"
```

System-wide deployment is intended for packaging or integration
requiring availability outside one user's package search path.

### Source and deployment copies

The repository component is canonical. Installed copies are deployment
artifacts.

## 8. Cross-Cutting Concepts

### Asset provenance

Prototype artwork is excluded from Git. Release artwork must have
redistribution rights appropriate for project distribution.

### Fog asset contract

The current continuous-drift renderer expects its fog asset to:

-   Provide usable alpha transparency.
-   Be horizontally seam-compatible when repeated.
-   Preserve acceptable quality when uniformly resampled.
-   Be available package-relative at runtime.

An asset that violates these assumptions may require a different
rendering strategy.

### Scene configuration versus renderer mechanics

Scene-specific visual values belong in `main.qml`. Reusable fog
mechanics and defaults belong in `FogLayer.qml`.

### Configuration isolation

The wallpaper plugin does not own authentication, lock-screen, or
session configuration.

### Graceful degradation

The base manor image remains valid independently of fog animation.

### Performance

The animation transforms already-loaded scene elements. The fog renderer
uses three QML `Image` instances referencing one source texture to
maintain continuous viewport coverage.

Resource use must be profiled before release.

## 9. Architecture Decisions

The component follows ADR 0001 and does not patch KScreenLocker or PLM.

The fog implementation uses deterministic continuous one-way translation
rather than oscillating motion.

The three-tile renderer is retained because it eliminates the observed
late-render artifact associated with an upcoming tile beginning entirely
outside the active viewport.

## 10. Quality Requirements

### Reliability

Wallpaper failure must not interfere with unlocking or session
operation.

### Visual continuity

Continuous fog animation must not expose tile seams, blank regions, or
obvious reset discontinuities.

### Performance

Animation must be profiled before release for CPU, GPU, and memory cost.

### Maintainability

The implementation should depend on public Plasma wallpaper APIs.
Rendering mechanics should remain isolated from scene-specific tuning.

### Portability

Runtime assets must be package-relative and machine-independent.

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

  Aspect-ratio-preserving base-scene  Validated
  crop                                

  KScreenLocker discovery             Validated

  Static lock-screen rendering        Validated

  Normal unlock with custom wallpaper Validated

  Custom child QML component          Validated
  rendering                           

  Continuous QML animation on desktop Validated

  Continuous QML animation on lock    Validated
  screen                              

  RGBA fog compositing                Validated

  Continuous one-way fog drift        Validated

  Horizontally seamless fog           Validated with current asset
  repetition                          

  Three-tile late-render workaround   Validated

  PLM selection                       Not supported for this plugin under
                                      the tested PLM allowlist
  -----------------------------------------------------------------------

## 12. Testing Strategy

Tests should eventually cover:

-   Metadata validity.
-   Required package files.
-   Package installation, upgrade, and removal.
-   QML loadability.
-   Missing-asset behavior.
-   Aspect-ratio behavior.
-   Fog alpha-channel requirements.
-   Fog tile geometry.
-   Fog readiness gating.
-   Continuous tile coverage.
-   Desktop and KScreenLocker runtime.
-   Normal unlocking.
-   Animation resource consumption.
-   Compatibility with targeted Plasma releases.

Manual visual validation remains necessary for seam visibility and scene
composition until appropriate visual-regression testing exists.

## 13. Risks and Open Issues

-   Plasma wallpaper APIs may evolve.
-   KScreenLocker behavior may change between Plasma releases.
-   Long-running animation may impose unacceptable resource cost.
-   `tileAspectRatio` is currently tied to the 2000 x 667 release fog
    asset.
-   Replacement fog artwork with different dimensions requires updating
    that assumption or generalizing dimension handling.
-   The three-tile workaround was validated empirically; the exact
    upstream scene-graph behavior behind the two-tile artifact has not
    been established.
-   Final performance profiling has not yet been completed.
-   PLM currently restricts selectable wallpaper plugins through an
    upstream allowlist.
