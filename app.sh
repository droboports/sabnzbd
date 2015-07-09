### UNRAR ###
_build_unrar() {
local VERSION="5.2.7"
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

### CHEETAH ###
_build_cheetah() {
# also installs Markdown
local VERSION="2.4.4"
local FILE="Cheetah-${VERSION}-py2.7-linux-armv7l.egg"
local URL="https://github.com/droboports/python-cheetah/releases/download/v${VERSION}/${FILE}"
local XPYTHON="${HOME}/xtools/python2/${DROBO}"
export QEMU_LD_PREFIX="${TOOLCHAIN}/${HOST}/libc"

_download_file "${FILE}" "${URL}"
mkdir -p "${DEST}/lib/python2.7/site-packages"
PYTHONPATH="${DEST}/lib/python2.7/site-packages" \
  "${XPYTHON}/bin/easy_install" --prefix="${DEST}" --always-copy "download/${FILE}"
}

### CFFI ###
_build_cffi() {
# also installs pycparser
local VERSION="1.1.2"
local FILE="cffi-${VERSION}-py2.7-linux-armv7l.egg"
local URL="https://github.com/droboports/python-cffi/releases/download/v${VERSION}/${FILE}"
local XPYTHON="${HOME}/xtools/python2/${DROBO}"
export QEMU_LD_PREFIX="${TOOLCHAIN}/${HOST}/libc"

_download_file "${FILE}" "${URL}"
mkdir -p "${DEST}/lib/python2.7/site-packages"
PYTHONPATH="${DEST}/lib/python2.7/site-packages" \
  "${XPYTHON}/bin/easy_install" --prefix="${DEST}" --always-copy "download/${FILE}"
}

### CRYPTOGRAPHY ###
_build_cryptography() {
# also installs ipaddress enum34 six pyasn1 idna
# depends on cffi
local VERSION="0.9.1"
local FILE="cryptography-${VERSION}-py2.7-linux-armv7l.egg"
local URL="https://github.com/droboports/python-cryptography/releases/download/v${VERSION}/${FILE}"
local XPYTHON="${HOME}/xtools/python2/${DROBO}"
export QEMU_LD_PREFIX="${TOOLCHAIN}/${HOST}/libc"

_download_file "${FILE}" "${URL}"
mkdir -p "${DEST}/lib/python2.7/site-packages"
PYTHONPATH="${DEST}/lib/python2.7/site-packages" \
  "${XPYTHON}/bin/easy_install" --prefix="${DEST}" --always-copy "download/${FILE}"
}

### PYOPENSSL ###
_build_pyopenssl() {
# depends on cryptography
local VERSION="0.15.1"
local FILE="pyOpenSSL-${VERSION}-py2.7.egg"
local URL="https://github.com/droboports/python-pyopenssl/releases/download/v${VERSION}/${FILE}"
local XPYTHON="${HOME}/xtools/python2/${DROBO}"
export QEMU_LD_PREFIX="${TOOLCHAIN}/${HOST}/libc"

_download_file "${FILE}" "${URL}"
mkdir -p "${DEST}/lib/python2.7/site-packages"
PYTHONPATH="${DEST}/lib/python2.7/site-packages" \
  "${XPYTHON}/bin/easy_install" --prefix="${DEST}" --always-copy "download/${FILE}"
}

### SABNZBD ###
_build_sabnzbd() {
local VERSION="0.7.20"
local FOLDER="sabnzbd-${VERSION}"
local FILE="${VERSION}.tar.gz"
local URL="https://github.com/sabnzbd/sabnzbd/archive/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
rm -fr "target/${FOLDER}/win" "target/${FOLDER}/osx"
mkdir -p "${DEST}/app"
cp -avR "target/${FOLDER}"/* "${DEST}/app/"
}

### BUILD ###
_build() {
  _build_unrar
  _build_par2
  _build_yenc
  _build_cheetah
  _build_cffi
  _build_cryptography
  _build_pyopenssl
  _build_sabnzbd
  _package
}
