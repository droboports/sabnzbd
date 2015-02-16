### UNRAR ###
_build_unrar() {
local VERSION="5.1.7"
local FOLDER="unrar"
local FILE="unrar.tgz"
local URL="https://github.com/droboports/unrar/releases/download/v${VERSION}/${FILE}"

_download_app "${FILE}" "${URL}" "${FOLDER}"
mkdir -p "${DEST}/libexec"
cp -v "target/${FOLDER}/bin"/* "${DEST}/libexec/"
}

### PAR2CMDLINE ###
_build_par2() {
local VERSION="0.4"
local FOLDER="par2"
local FILE="par2.tgz"
local URL="https://github.com/droboports/par2cmdline/releases/download/v${VERSION}/${FILE}"

_download_app "${FILE}" "${URL}" "${FOLDER}"
mkdir -p "${DEST}/libexec"
cp -v "target/${FOLDER}/bin"/* "${DEST}/libexec/"
}

### CHEETAH ###
_build_cheetah() {
local VERSION="2.4.4"
local FILE="Cheetah-${VERSION}-py2.7-linux-armv7l.egg"
local URL="https://github.com/droboports/python-cheetah/releases/download/v${VERSION}/${FILE}"
local XPYTHON=~/xtools/python2/${DROBO}

_download_file "${FILE}" "${URL}"
mkdir -p "${DEST}/lib/python2.7/site-packages"
_PYTHON_HOST_PLATFORM="linux-armv7l" PYTHONPATH="${DEST}/lib/python2.7/site-packages" ${XPYTHON}/bin/easy_install --prefix="${DEST}" --always-copy "download/${FILE}"
}

### PYOPENSSL ###
_build_pyopenssl() {
local VERSION="0.13"
local FILE="pyOpenSSL-${VERSION}-py2.7-linux-armv7l.egg"
local URL="https://github.com/droboports/python-pyopenssl/releases/download/v${VERSION}/${FILE}"
local XPYTHON=~/xtools/python2/${DROBO}

_download_file "${FILE}" "${URL}"
mkdir -p "${DEST}/lib/python2.7/site-packages"
_PYTHON_HOST_PLATFORM="linux-armv7l" PYTHONPATH="${DEST}/lib/python2.7/site-packages" ${XPYTHON}/bin/easy_install --prefix="${DEST}" --always-copy "download/${FILE}"
}

### YENC ###
_build_yenc() {
local VERSION="0.4.0"
local FILE="yenc-${VERSION}-py2.7-linux-armv7l.egg"
local URL="https://github.com/droboports/python-yenc/releases/download/v${VERSION}/${FILE}"
local XPYTHON=~/xtools/python2/${DROBO}

_download_file "${FILE}" "${URL}"
mkdir -p "${DEST}/lib/python2.7/site-packages"
_PYTHON_HOST_PLATFORM="linux-armv7l" PYTHONPATH="${DEST}/lib/python2.7/site-packages" ${XPYTHON}/bin/easy_install --prefix="${DEST}" --always-copy "download/${FILE}"
}

### SABNZBD ###
_build_sabnzbd() {
local BRANCH="0.7.x"
local FOLDER="app"
local URL="https://github.com/sabnzbd/sabnzbd.git"

_download_git "${BRANCH}" "${FOLDER}" "${URL}"
rm -fr "target/${FOLDER}/win" "target/${FOLDER}/osx"
mkdir -p "${DEST}/app"
cp -avR "target/${FOLDER}"/* "${DEST}/app/"

#local VERSION="0.7.18"
#local FOLDER="SABnzbd-${VERSION}"
#local FILE="${FOLDER}-src.tar.gz"
#local URL="http://sourceforge.net/projects/sabnzbdplus/files/sabnzbdplus/${VERSION}/${FILE}"

#_download_tgz "${FILE}" "${URL}" "${FOLDER}"
#mkdir -p "${DEST}/app"
#cp -avR "target/${FOLDER}"/* "${DEST}/app/"
}

### BUILD ###
_build() {
  _build_unrar
  _build_par2
  _build_cheetah
  _build_pyopenssl
  _build_yenc
  _build_sabnzbd
  _package
}
