FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
               file://nginx-override.conf \
               file://nginx.path \
               file://default_server_dev.site \
               file://default_server_prod.site"

RDEPENDS:${PN} += "rpi-device-certs"

SYSTEMD_SERVICE:${PN} += "nginx.path"

NGINX_USERNAME ?= "rpi"
# Use a pre-generated password hash with openssl:
# openssl passwd -apr1 123456
NGINX_HASHED_PASSWORD ?= "$apr1$HD03o7ue$eoWU8IGTC/DRPwSKf5Zf1."

do_install:append() {

    echo "${NGINX_USERNAME}:"'${NGINX_HASHED_PASSWORD}' > ${D}${sysconfdir}/nginx/.htpasswd
    chmod 0644 ${D}${sysconfdir}/nginx/.htpasswd

    install -d ${D}${systemd_unitdir}/system/nginx.service.d
    install -m 0644 ${UNPACKDIR}/nginx-override.conf ${D}${systemd_unitdir}/system/nginx.service.d/
    install -m 0644 ${UNPACKDIR}/nginx.path ${D}${systemd_unitdir}/system/

    if [ "${RPI_SECURITY_PROFILE}" = "dev" ]; then
        install -m 0644 ${UNPACKDIR}/default_server_dev.site ${D}${sysconfdir}/nginx/sites-available/default_server
    else
        install -m 0644 ${UNPACKDIR}/default_server_prod.site ${D}${sysconfdir}/nginx/sites-available/default_server
    fi

}

FILES:${PN} += "${sysconfdir}/nginx/.htpasswd \
                ${systemd_unitdir}/system/nginx.service.d \
                ${systemd_unitdir}/system/nginx.path"
