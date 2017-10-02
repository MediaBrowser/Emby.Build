#!/usr/bin/env bash

## Makes debuggers' life easier - Unofficial Bash Strict Mode
## BASHDOC: Shell Builtin Commands - Modifying Shell Behavior - The Set Builtin
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

if [[ -v "BASH_SOURCE[0]" ]]; then
  RUNTIME_EXECUTABLE_PATH="$(realpath --strip "${BASH_SOURCE[0]}")"
  RUNTIME_EXECUTABLE_FILENAME="$(basename "${RUNTIME_EXECUTABLE_PATH}")"
  RUNTIME_EXECUTABLE_NAME="${RUNTIME_EXECUTABLE_FILENAME%.*}"
  RUNTIME_EXECUTABLE_DIRECTORY="$(dirname "${RUNTIME_EXECUTABLE_PATH}")"
  RUNTIME_COMMANDLINE_BASECOMMAND="${0}"
  # Keep these partially unused variables declared
  # shellcheck disable=SC2034
  declare -r\
    RUNTIME_EXECUTABLE_PATH\
    RUNTIME_EXECUTABLE_FILENAME\
    RUNTIME_EXECUTABLE_NAME\
    RUNTIME_EXECUTABLE_DIRECTORY\
    RUNTIME_COMMANDLINE_BASECOMMAND
fi

# Test environment variable
: "${DOCKER_BUILD_SRC_PATH:?Need to set DOCKER_BUILD_SRC_PATH}"

declare -ar RUNTIME_COMMANDLINE_PARAMETERS=("${@}")
declare -r ARCH="${RUNTIME_COMMANDLINE_PARAMETERS[0]}"
declare -r DOCKER_IMG_REPO="emby"
declare -r DOCKER_IMG_NAME="emby-base"
declare -r BUILDDIR="/var/tmp/${DOCKER_IMG_REPO}_${DOCKER_IMG_NAME}_${ARCH}"
declare -r DOCKER_ROOTFS_REPO="http://download.opensuse.org/repositories/home:/emby:/docker/images/"
declare -r QEMU_REPO="http://download.opensuse.org/tumbleweed/repo/oss/suse/x86_64/"

function clean() {
  rm -rf "$BUILDDIR"
}; declare -fr clean

function init_build() {
  echo "Building Docker image:  $DOCKER_IMG_REPO/$DOCKER_IMG_NAME:$ARCH"
  if  [[ -d "$BUILDDIR" ]]; then
    clean
  fi
  mkdir -p "$BUILDDIR"
}; declare -fr init_build

function prep_qemu_binfmt() {
  mkdir -p "$BUILDDIR/usr/bin"
  if [[ "$ARCH" ==  "armv7" ]]; then
    rpm2cpio "$BUILDDIR/qemu-linux-user.rpm" | cpio -D "$BUILDDIR" -idmv "*qemu-arm" "*qemu-arm-*"
    if [[ ! -e "/proc/sys/fs/binfmt_misc/qemu-arm" ]]; then
      docker run --rm --privileged emby/qemu-register:latest
    fi
  fi
  if [[ "$ARCH" ==  "aarch64" ]]; then
    rpm2cpio "$BUILDDIR/qemu-linux-user.rpm" | cpio -D "$BUILDDIR" -idmv "*qemu-aarch*"
    if [[ ! -e "/proc/sys/fs/binfmt_misc/qemu-aarch64" ]]; then
      docker run --rm --privileged emby/qemu-register:latest
    fi
  fi
}; declare -fr prep_qemu_binfmt

function prep_rootfs() {
  if [[ "$tar_is_native_docker_img" == "1"  ]]; then
    tar -C "$BUILDDIR" -xvf "$BUILDDIR/temp.tar.xz"
    rm "$BUILDDIR/temp.tar.xz"
    find "$BUILDDIR" -maxdepth 1 -type f -size -10M -delete
    find "$BUILDDIR" -maxdepth 1 -type f -size +40M -print0 | xargs -0 -I {} mv {} "$BUILDDIR/rootfs.tar.xz"
  else
    mv "$BUILDDIR/temp.tar.xz" "$BUILDDIR/rootfs.tar.xz"
  fi
}; declare -fr prep_rootfs

function copy_docker_src_files() {
  cp "$DOCKER_BUILD_SRC_PATH/Dockerfile" "$BUILDDIR"
  cp -r "$DOCKER_BUILD_SRC_PATH/overlay-$ARCH" "$BUILDDIR/overlay-$ARCH"
  cp -r "$DOCKER_BUILD_SRC_PATH/overlay-common" "$BUILDDIR/overlay-common"
}; declare -fr copy_docker_src_files

function get_ffmpeg() {
  if [[ "$ARCH" ==  "x86_64" ]]; then \
    curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz -o "$BUILDDIR/ffmpeg.tar.xz"
  else
    curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-armhf-32bit-static.tar.xz -o "$BUILDDIR/ffmpeg.tar.xz"
  fi
  tar -C "$BUILDDIR/usr/bin" -xf "$BUILDDIR/ffmpeg.tar.xz" --wildcards "*/ffmpeg" --strip-components=1
  tar -C "$BUILDDIR/usr/bin" -xf "$BUILDDIR/ffmpeg.tar.xz" --wildcards "*/ffprobe" --strip-components=1
}; declare -fr get_ffmpeg

function prep_build() {
  declare docker_rootfs_txz\
    tar_is_native_docker_img\
    qemu_rpm

  docker_rootfs_txz=$( \
    curl -s "$DOCKER_ROOTFS_REPO" --list-only | \
    sed -n "s%.*>\(emby-base.*${ARCH}.*-.*tar.xz\)</a>.*%\1%p" | \
    sort -i | \
    head -1
  )
  curl --silent -L "$DOCKER_ROOTFS_REPO/$docker_rootfs_txz" -o "$BUILDDIR/temp.tar.xz"

  tar_is_native_docker_img=$( \
    tar tvf "$BUILDDIR/temp.tar.xz" | \
    awk 'BEGIN{ cnt=0; } { if ( $6 == "manifest.json" ) cnt=1; } END{ print cnt }'
  )

  qemu_rpm=$( \
    curl -s "$QEMU_REPO" --list-only | \
    grep qemu-linux | \
    sed -n "s%.*>\(qemu-linux-.*rpm\)</a>.*%\1%p" | \
    tail -1
  )
  curl --silent -L "$QEMU_REPO/$qemu_rpm" -o "$BUILDDIR/qemu-linux-user.rpm"

  prep_qemu_binfmt
  prep_rootfs
  copy_docker_src_files
}; declare -fr prep_build

function build_and_tag() {
  cd "$BUILDDIR" && \
    docker build --build-arg ARCH="$ARCH" --rm=true "--tag=$DOCKER_IMG_REPO/$DOCKER_IMG_NAME:$ARCH" .
  if [[ "$ARCH" ==  "x86_64" ]]; then \
    docker tag "$DOCKER_IMG_REPO/$DOCKER_IMG_NAME:$ARCH" "$DOCKER_IMG_REPO/$DOCKER_IMG_NAME:latest"
  fi
  clean
}; declare -fr build_and_tag

init_build
prep_build
get_ffmpeg
build_and_tag
