SUMMARY = "Apache logging framework for C++"
DESCRIPTION = "Apache logging framework for C++ library"
SECTION = "libs"
HOMEPAGE = "http://logging.apache.org/log4cxx/"

DEPENDS = "apr apr-util expat gdbm"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"

SRC_URI = "git://git-wip-us.apache.org/repos/asf/logging-log4cxx.git;protocol=https;branch=master"
SRCREV = "b63993f82346e0db103ef7d210d95478e729cfc0"

inherit autotools-brokensep pkgconfig

BBCLASSEXTEND += "native"
