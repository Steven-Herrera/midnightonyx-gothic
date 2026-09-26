#!/usr/bin/env fish

# SPDX-FileCopyrightText: 2026 midnightonyx
# SPDX-License-Identifier: GPL-3.0-or-later

set -g failures 0

set script_dir (path resolve (dirname (status filename)))
set repo_root (path resolve "$script_dir/../..")

set package_rel components/wallpaper/manor
set package_dir "$repo_root/$package_rel"
set metadata "$package_dir/metadata.json"
set validator "$repo_root/tests/validate-wallpaper.fish"
set dist_dir "$repo_root/dist"

function fail
    printf 'ERROR: %s\n' "$argv" >&2
    exit 1
end

function require_command
    set command_name "$argv[1]"

    if not command -q "$command_name"
        fail "Required command is unavailable: $command_name"
    end
end

printf '%s\n' \
    'MidnightOnyx Manor KDE Store release builder' \
    "Repository: $repo_root" \
    ''

echo '=== Required tools ==='

for command_name in \
        git \
        fish \
        python \
        zip \
        sha256sum \
        kpackagetool6

    require_command "$command_name"
    echo "FOUND  $command_name"
end

echo
echo '=== Repository ==='

if not git -C "$repo_root" rev-parse --is-inside-work-tree >/dev/null 2>&1
    fail 'Repository root is not inside a Git working tree'
end

set commit (
    git \
        -C "$repo_root" \
        rev-parse HEAD
)

if test $status -ne 0; or test -z "$commit"
    fail 'Unable to resolve Git HEAD'
end

echo "HEAD   $commit"

set working_tree_changes (
    git \
        -C "$repo_root" \
        status \
        --porcelain
)

if test $status -ne 0
    fail 'Unable to inspect Git working tree'
end

if test -n "$working_tree_changes"
    echo "$working_tree_changes" >&2
    fail 'Working tree is not clean; commit or stash changes before building a release'
end

echo 'PASS   Git working tree is clean'

echo
echo '=== Source validation ==='

"$validator" --require-kde

if test $status -ne 0
    fail 'Source wallpaper validation failed'
end

echo
echo '=== Release version ==='

set package_version (
    python -c '
import json
import sys

with open(sys.argv[1], "r", encoding="utf-8") as handle:
    metadata = json.load(handle)

print(metadata["KPlugin"]["Version"])
' "$metadata"
)

if test $status -ne 0; or test -z "$package_version"
    fail 'Unable to read KPlugin.Version from metadata.json'
end

if not string match -rq \
        '^[0-9]+\.[0-9]+\.[0-9]+([+-][0-9A-Za-z.-]+)?$' \
        -- "$package_version"

    fail "Package version is not SemVer-like: $package_version"
end

echo "VERSION  $package_version"

set artifact_name "midnightonyx-manor-$package_version.zip"

set checksum_name "$artifact_name.sha256"

echo
echo '=== Staging ==='

set stage_root (mktemp -d)

if test $status -ne 0; or test -z "$stage_root"
    fail 'Unable to create temporary staging directory'
end

function cleanup --on-event fish_exit
    if test -n "$stage_root"; and test -d "$stage_root"
        rm -rf -- "$stage_root"
    end
end

set stage_package "$stage_root/package"

mkdir -p "$stage_package"; or \
    fail 'Unable to create staging package directory'

git \
    -C "$repo_root" \
    archive \
    --format=tar \
    HEAD \
    "$package_rel" \
    | tar \
        -xf - \
        -C "$stage_root"

set archive_status $pipestatus

if test (count $archive_status) -ne 2
    fail 'Unable to determine Git archive pipeline status'
end

if test $archive_status[1] -ne 0
    fail "git archive failed with status $archive_status[1]"
end

if test $archive_status[2] -ne 0
    fail "tar extraction failed with status $archive_status[2]"
end

set exported_package "$stage_root/$package_rel"

if not test -d "$exported_package"
    fail 'Git export did not produce the wallpaper package'
end

cp -a \
    "$exported_package/." \
    "$stage_package/"; or \
    fail 'Unable to populate release staging package'

echo "STAGE  $stage_package"

echo
echo '=== Staged package contents ==='

find "$stage_package" \
    -type f \
    -printf '%P\n' \
    | sort

set staged_file_count (
    find "$stage_package" \
        -type f \
        | wc -l \
        | string trim
)

if test "$staged_file_count" != '5'
    fail "Expected 5 staged package files, found $staged_file_count"
end

echo "PASS   staged package contains exactly 5 files"

set staged_prototypes (
    find "$stage_package" \
        -type f \
        -iname '*prototype*' \
        -print
)

if test -n "$staged_prototypes"
    printf '%s\n' $staged_prototypes >&2
    fail 'Prototype files entered release staging'
end

echo 'PASS   staged package contains no prototype files'

echo
echo '=== Staged KPackage validation ==='

set package_hash (
    kpackagetool6 \
        --type=Plasma/Wallpaper \
        --hash "$stage_package" \
        2>/dev/null
)

if test $status -ne 0; or test -z "$package_hash"
    fail 'KPackage rejected staged wallpaper package'
end

echo "PASS   KPackage accepts staged package"
echo "HASH   $package_hash"

echo
echo '=== Artifact creation ==='

mkdir -p "$dist_dir"; or \
    fail 'Unable to create dist directory'

set artifact "$dist_dir/$artifact_name"
set checksum "$dist_dir/$checksum_name"

rm -f -- \
    "$artifact" \
    "$checksum"

pushd "$stage_package" >/dev/null; or \
    fail 'Unable to enter staging package'

set staged_files (
    find . \
        -type f \
        -printf '%P\n' \
        | sort
)

zip \
    -X \
    -q \
    "$artifact" \
    $staged_files

set zip_status $status

popd >/dev/null

if test $zip_status -ne 0
    fail 'Unable to create release archive'
end

if not test -s "$artifact"
    fail 'Release archive is empty or missing'
end

pushd "$dist_dir" >/dev/null; or \
    fail 'Unable to enter dist directory'

sha256sum "$artifact_name" \
    > "$checksum_name"

set checksum_status $status

popd >/dev/null

if test $checksum_status -ne 0
    fail 'Unable to create SHA-256 checksum'
end

echo
echo '=== Release artifact ==='

ls -lh \
    "$artifact" \
    "$checksum"

echo
echo '=== SHA-256 ==='

cat "$checksum"

echo
echo 'KDE Store release build PASSED.'