### UNRAR ###
_build_unrar() {
local VERSION="5.3.4"
local FOLDER="unrar"
local FILE="unrarsrc-${VERSION}.tar.gz"
local URL="http://www.rarlab.com/rar/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd target/"${FOLDER}"
mv makefile Makefile
make CXX="${CXX}" CXXFLAGS="${CFLAGS} -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE" STRIP="${STRIP}" LDFLAGS="${LDFLAGS} -pthread"
make install DESTDIR="${DEST}"
mkdir -p "${DEST}/libexec"
mv "${DEST}/bin/unrar" "${DEST}/libexec/"
popd
}

### PAR2 ###
_build_par2() {
local VERSION="0.4"
local FOLDER="par2cmdline-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://sourceforge.net/projects/parchive/files/par2cmdline/${VERSION}/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
patch "target/${FOLDER}/reedsolomon.cpp" src/reedsolomon.cpp.patch
pushd "target/${FOLDER}"
./configure --host="${HOST}" --prefix="${DEST}"
make
make install
mkdir -p "${DEST}/libexec"
mv "${DEST}/bin/par2"* "${DEST}/libexec/"
popd
}

### python2 module ###
# Build a python2 module from source
__build_module() {
local VERSION="${2}"
local FOLDER="${1}-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="https://pypi.python.org/packages/source/$(echo ${1} | cut -c 1)/${1}/${FILE}"
local HPYTHON="${DROBOAPPS}/python2"
local XPYTHON="${HOME}/xtools/python2/${DROBO}"
export QEMU_LD_PREFIX="${TOOLCHAIN}/${HOST}/libc"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
sed -e "s/from distutils.core import setup/from setuptools import setup/g" \
    -i setup.py
PKG_CONFIG_PATH="${XPYTHON}/lib/pkgconfig" \
  LDFLAGS="${LDFLAGS} -Wl,-rpath,${HPYTHON}/lib -L${XPYTHON}/lib" \
  PYTHONPATH="${DEST}/lib/python2.7/site-packages" \
  "${XPYTHON}/bin/python" setup.py \
    build_ext --include-dirs="${XPYTHON}/include" --library-dirs="${XPYTHON}/lib" --force \
    build --force \
    build_scripts --executable="${HPYTHON}/bin/python" --force \
    install --prefix="${DEST}"
popd
}

### YENC ###
_build_yenc() {
local VERSION="0.4.0"
local FILE="yenc-${VERSION}-py2.7-linux-armv7l.egg"
local URL="https://github.com/droboports/python-yenc/releases/download/v${VERSION}/${FILE}"
local XPYTHON="${HOME}/xtools/python2/${DROBO}"
export QEMU_LD_PREFIX="${TOOLCHAIN}/${HOST}/libc"

_download_file "${FILE}" "${URL}"
mkdir -p "${DEST}/lib/python2.7/site-packages"
PYTHONPATH="${DEST}/lib/python2.7/site-packages" \
  "${XPYTHON}/bin/easy_install" --prefix="${DEST}" --always-copy "download/${FILE}"
}

### DEPENDENCIES ###
_build_modules() {
  #__build_module yenc 0.4.0
  _build_yenc
      __build_module pycparser 2.14
    __build_module cffi 1.1.2
      __build_module Markdown 2.6.2
    __build_module Cheetah 2.4.4
      __build_module ipaddress 1.0.14
      __build_module enum34 1.0.4
      __build_module six 1.9.0
      __build_module pyasn1 0.1.8
      __build_module idna 2.0
      __build_module setuptools 18.0.1
    __build_module cryptography 0.9.1
  __build_module pyOpenSSL 0.15.1

  rm -vf "${DEST}/bin/cheetah"* "${DEST}/bin/easy_install"* "${DEST}/bin/markdown_py"
}

### SABNZBD ###
_build_sabnzbd() {
local VERSION="0.7.20"
local FOLDER="sabnzbd-${VERSION}"
local FILE="${VERSION}.tar.gz"
local URL="https://github.com/sabnzbd/sabnzbd/archive/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
rm -fr "target/${FOLDER}/win" "target/${FOLDER}/osx"
sed -e "s/0.7.x/0.7.20/g" \
    -e "s/unknown/1df2943d05d64915a166e2c97e1eef86f72e3ff3/g" \
    -i "target/${FOLDER}/sabnzbd/version.py"
mkdir -p "${DEST}/app"
cp -avR "target/${FOLDER}"/* "${DEST}/app/"
}

### BUILD ###
_build() {
  _build_unrar
  _build_par2
  _build_modules
  _build_sabnzbd
  _package
}
