# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libappindicator/libappindicator-12.10.0.ebuild,v 1.2 2012/07/27 16:34:15 ssuominen Exp $

EAPI=5
inherit eutils

AYATANA_VALA_VERSION=0.16

DESCRIPTION="A library to allow applications to export a menu into the Unity Menu bar"
HOMEPAGE="http://launchpad.net/libappindicator"
MY_PN="${PN#acestream-}"
SRC_URI="x86? ( mirror://ubuntu/pool/main/liba/libappindicator/${MY_PN}_${PV}-0ubuntu1_i386.deb )
		amd64? ( mirror://ubuntu/pool/main/liba/libappindicator/${MY_PN}_${PV}-0ubuntu1_amd64.deb )"
LICENSE="LGPL-2.1 LGPL-3"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.26
	>=dev-libs/libdbusmenu-12.10.2-r2:3[gtk2]
	dev-libs/acestream-libappindicator
	>=x11-libs/gtk+-2.24.12:2"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare(){
	unpack ${A}
	unpack ./data.tar.gz
	mv usr/lib/python2.7/dist-packages usr/lib/python2.7/site-packages
}

src_install() {
	cp -R usr/ "${D}"
}