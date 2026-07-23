DESCRIPTION = "packagegroup for application libraries"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

PACKAGES = "${PN}"

SUMMARY:packagegroup-apps = "Application libraries support"

RDEPENDS:packagegroup-apps = " \
    apr \
    apr-util \
    boost \
    curl \
    expat \
    log4cxx \
    ppp \
    ppp-dialin \
    libxerces-c \
    rapidjson \
    nlohmann-json \
    nlohmann-fifo \
    "