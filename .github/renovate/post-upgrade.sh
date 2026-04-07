#!/usr/bin/env bash
set -euo pipefail

# Post-upgrade script for Renovate: updates MD5 checksums in MavenEmbeddedResourcesTest.java
# after Renovate bumps dependency versions in pom.xml.

POM="pom.xml"
TEST_FILE="src/test/java/com/gradle/develocity/bamboo/MavenEmbeddedResourcesTest.java"

dv_version=$(grep -oP '(?<=<develocity.maven.extension.version>)[^<]+' "$POM")
ccud_version=$(grep -oP '(?<=<ccud.maven.extension.version>)[^<]+' "$POM")

dv_checksum=$(curl -sf "https://repo1.maven.org/maven2/com/gradle/develocity-maven-extension/${dv_version}/develocity-maven-extension-${dv_version}.jar.md5")
ccud_checksum=$(curl -sf "https://repo1.maven.org/maven2/com/gradle/common-custom-user-data-maven-extension/${ccud_version}/common-custom-user-data-maven-extension-${ccud_version}.jar.md5")

# Replace the checksums in the test file
sed -i "s|DEVELOCITY_EXTENSION, [a-f0-9]\{32\}|DEVELOCITY_EXTENSION, ${dv_checksum}|" "$TEST_FILE"
sed -i "s|CCUD_EXTENSION, [a-f0-9]\{32\}|CCUD_EXTENSION, ${ccud_checksum}|" "$TEST_FILE"
