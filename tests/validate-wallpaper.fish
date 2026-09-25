#!/usr/bin/env fish

# SPDX-FileCopyrightText: 2026 midnightonyx
# SPDX-License-Identifier: GPL-3.0-or-later

set -g failures 0
set -g warnings 0
set -g passes 0

set -g require_kde false

for arg in $argv
    switch "$arg"
        case --require-kde
            set -g require_kde true

        case --help -h
            printf '%s\n' \
                'Usage: tests/validate-wallpaper.fish [--require-kde]' \
                '' \
                'Options:' \
                '  --require-kde  Fail validation when KDE KPackage tooling is unavailable.' \
                '  -h, --help     Show this help message.'
            exit 0

        case '*'
            printf 'ERROR: Unknown argument: %s\n' "$arg" >&2
            printf 'Run %s --help for usage.\n' (status filename) >&2
            exit 2
    end
end

set script_dir (path resolve (dirname (status filename)))
set repo_root (path resolve "$script_dir/..")

set package_dir "$repo_root/components/wallpaper/manor"
set metadata "$package_dir/metadata.json"
set main_qml "$package_dir/contents/ui/main.qml"
set fog_qml "$package_dir/contents/ui/FogLayer.qml"
set manor_image "$package_dir/contents/images/midnight-manor.png"
set fog_image "$package_dir/contents/images/midnight-fog.png"

function pass
    set -g passes (math $passes + 1)
    printf 'PASS  %s\n' "$argv"
end

function fail
    set -g failures (math $failures + 1)
    printf 'FAIL  %s\n' "$argv" >&2
end

function warn
    set -g warnings (math $warnings + 1)
    printf 'WARN  %s\n' "$argv" >&2
end

function require_file
    set file "$argv[1]"
    set description "$argv[2]"

    if test -f "$file"
        pass "$description"
    else
        fail "$description"
    end
end

function json_value
    set file "$argv[1]"
    set expression "$argv[2]"

    python -c '
import json
import sys

path = sys.argv[1]
expression = sys.argv[2]

with open(path, "r", encoding="utf-8") as handle:
    value = json.load(handle)

for key in expression.split("."):
    value = value[key]

if isinstance(value, bool):
    print("true" if value else "false")
elif isinstance(value, (dict, list)):
    print(json.dumps(value, separators=(",", ":")))
else:
    print(value)
' "$file" "$expression"
end

function require_json_value
    set file "$argv[1]"
    set expression "$argv[2]"
    set expected "$argv[3]"
    set description "$argv[4]"

    set actual (json_value "$file" "$expression" 2>/dev/null)

    if test $status -ne 0
        fail "$description"
        return
    end

    if test "$actual" = "$expected"
        pass "$description"
    else
        fail "$description (expected '$expected', got '$actual')"
    end
end

function require_command
    set command_name "$argv[1]"
    set description "$argv[2]"

    if command -q "$command_name"
        pass "$description"
        return 0
    end

    fail "$description"
    return 1
end

if $require_kde
    set validation_mode 'repository + required KDE tooling'
else
    set validation_mode 'repository + optional KDE tooling'
end

printf '%s\n' \
    'MidnightOnyx Gothic wallpaper validator' \
    "Repository: $repo_root" \
    "Mode: $validation_mode" \
    ''

echo '=== Required files ==='

require_file \
    "$metadata" \
    'metadata.json exists'

require_file \
    "$main_qml" \
    'main.qml exists'

require_file \
    "$fog_qml" \
    'FogLayer.qml exists'

require_file \
    "$manor_image" \
    'midnight-manor.png exists'

require_file \
    "$fog_image" \
    'midnight-fog.png exists'

echo
echo '=== Required tools ==='

require_command \
    python \
    'Python is available'

require_command \
    git \
    'Git is available'

require_command \
    identify \
    'ImageMagick identify is available'

if test $failures -gt 0
    echo
    echo 'Required tools or files are missing; continuing with checks that remain possible.'
end

echo
echo '=== Metadata ==='

if python -m json.tool "$metadata" >/dev/null 2>&1
    pass 'metadata.json is valid JSON'
else
    fail 'metadata.json is valid JSON'
end

require_json_value \
    "$metadata" \
    'KPackageStructure' \
    'Plasma/Wallpaper' \
    'KPackage structure is Plasma/Wallpaper'

require_json_value \
    "$metadata" \
    'KPlugin.Id' \
    'org.midnightonyx.manor' \
    'Plugin ID is org.midnightonyx.manor'

require_json_value \
    "$metadata" \
    'X-Plasma-API-Minimum-Version' \
    '6.0' \
    'Minimum Plasma API version is 6.0'

set package_version (json_value "$metadata" 'KPlugin.Version' 2>/dev/null)

if test $status -eq 0; and string match -rq '^[0-9]+\.[0-9]+\.[0-9]+([+-][0-9A-Za-z.-]+)?$' -- "$package_version"
    pass "Package version is present and SemVer-like ($package_version)"
else
    fail 'Package version is present and SemVer-like'
end

echo
echo '=== Release images ==='

if command -q identify
    set manor_geometry (
        identify \
            -format '%wx%h' \
            "$manor_image" \
            2>/dev/null
    )

    if test "$manor_geometry" = '1672x941'
        pass 'Manor image geometry is 1672x941'
    else
        fail "Manor image geometry is 1672x941 (got '$manor_geometry')"
    end

    set fog_geometry (
        identify \
            -format '%wx%h' \
            "$fog_image" \
            2>/dev/null
    )

    if test "$fog_geometry" = '2000x667'
        pass 'Fog image geometry is 2000x667'
    else
        fail "Fog image geometry is 2000x667 (got '$fog_geometry')"
    end

    set fog_channels (
        identify \
            -format '%[channels]' \
            "$fog_image" \
            2>/dev/null
    )

    if string match -rq 'a' -- "$fog_channels"
        pass "Fog image contains an alpha channel ($fog_channels)"
    else
        fail "Fog image contains an alpha channel (got '$fog_channels')"
    end
end

echo
echo '=== QML invariants ==='

if grep -Fq 'midnight-manor.png' "$main_qml"
    pass 'main.qml references release manor image'
else
    fail 'main.qml references release manor image'
end

if grep -Fq 'midnight-fog.png' "$main_qml"
    pass 'main.qml references release fog image'
else
    fail 'main.qml references release fog image'
end

if grep -Fq 'FogLayer {' "$main_qml"
    pass 'main.qml instantiates FogLayer'
else
    fail 'main.qml instantiates FogLayer'
end

if grep -Fq 'fogA.status === Image.Ready' "$fog_qml"; and \
        grep -Fq 'fogB.status === Image.Ready' "$fog_qml"; and \
        grep -Fq 'fogC.status === Image.Ready' "$fog_qml"
    pass 'FogLayer gates animation on all three image tiles'
else
    fail 'FogLayer gates animation on all three image tiles'
end

if grep -Fq 'width: root.tileWidth * 3' "$fog_qml"
    pass 'FogLayer uses three-tile coverage'
else
    fail 'FogLayer uses three-tile coverage'
end

echo
echo '=== Git hygiene ==='

if command -q git
    set tracked_prototypes (
        git \
            -C "$repo_root" \
            ls-files \
            | grep -E '(^|/).*prototype.*$'
    )

    if test -z "$tracked_prototypes"
        pass 'No prototype artwork is tracked by Git'
    else
        fail 'No prototype artwork is tracked by Git'

        for file in $tracked_prototypes
            printf '      tracked: %s\n' "$file" >&2
        end
    end

    set release_assets (
        git \
            -C "$repo_root" \
            ls-files \
            components/wallpaper/manor/contents/images/midnight-manor.png \
            components/wallpaper/manor/contents/images/midnight-fog.png
    )

    if string match -q '*midnight-manor.png*' -- "$release_assets"; and \
            string match -q '*midnight-fog.png*' -- "$release_assets"
        pass 'Release artwork is tracked by Git'
    else
        fail 'Release artwork is tracked by Git'
    end
end

echo
echo '=== KDE package tooling ==='

if command -q kpackagetool6
    pass 'kpackagetool6 is available'

    set package_hash (
        kpackagetool6 \
            --type=Plasma/Wallpaper \
            --hash "$package_dir" \
            2>/dev/null
    )

    if test $status -eq 0; and test -n "$package_hash"
        pass 'KPackage accepts the wallpaper package'
    else
        fail 'KPackage accepts the wallpaper package'
    end
else if $require_kde
    fail 'kpackagetool6 is required but unavailable'
else
    warn 'kpackagetool6 is unavailable; KDE-aware package validation skipped'
end

echo
echo '=== Result ==='

printf 'PASS: %d\n' "$passes"
printf 'WARN: %d\n' "$warnings"
printf 'FAIL: %d\n' "$failures"

if test $failures -gt 0
    echo
    echo 'Wallpaper validation FAILED.'
    exit 1
end

echo
echo 'Wallpaper validation PASSED.'
exit 0
