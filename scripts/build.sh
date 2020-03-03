#!/usr/bin/env bash
##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : build.sh                                                      ##
##  Project   : metaballs                                                     ##
##  Date      : Mar 03, 2020                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt 2020                                                  ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##---------------------------------------------------------------------------~##

##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
source /usr/local/src/stdmatt/shellscript_utils/main.sh


##----------------------------------------------------------------------------##
## Variables                                                                  ##
##----------------------------------------------------------------------------##
SCRIPT_DIR="$(pw_get_script_dir)";
ROOT_DIR="$(pw_abspath "${SCRIPT_DIR}/..")";
BUILD_DIR="${ROOT_DIR}/build";
DIST_DIR="${ROOT_DIR}/dist";
TO_COPY="libs/ src/ index.html";


##----------------------------------------------------------------------------##
## Script                                                                     ##
##----------------------------------------------------------------------------##
#
# Build
echo "Cleaning build directory";
rm    -rf "$BUILD_DIR";
mkdir -p  "$BUILD_DIR";


echo "Copying files to build directory";
for ITEM in $TO_COPY; do
    cp -R "${ROOT_DIR}/${ITEM}" "${BUILD_DIR}";
done;

find ${BUILD_DIR} -iname ".git*" -exec rm -rf {} \;


##
## Dist
test -z "$(pw_getopt_exists "--dist" "$@")" && exit;
echo "Creating the distribution artifact!!!";

## Parse the version.
##   Not very efficient but I mean...
##   is a such simple file and some many things to do yet...
VERSION_FILENAME="${ROOT_DIR}/src/Version.js";

MAJOR=$(cat "$VERSION_FILENAME" | grep "const .*_MAJOR" | tac -s" " | head -1);
MINOR=$(cat "$VERSION_FILENAME" | grep "const .*_MINOR" | tac -s" " | head -1);
BABY=$( cat "$VERSION_FILENAME" | grep "const .*_BABY"  | tac -s" " | head -1);

## The components came with the trailing ; from the js code, so we replace
## them by - and remove the trailing one :D
FINAL_VERSION="$(pw_string_replace "${MAJOR}${MINOR}${BABY}" ";" "-")";
FINAL_VERSION="$(pw_substr "$FINAL_VERSION" 0 -1)";

echo "Cleaning dist directory";
rm    -rf "$DIST_DIR";
mkdir -p  "$DIST_DIR";

echo "Creating zip file";
ZIP_FILENAME="metaballs_v${FINAL_VERSION}.zip";
zip -rj "${DIST_DIR}/${ZIP_FILENAME}" "${BUILD_DIR}";
