# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib unpacker

DESCRIPTION="ACE Stream multimedia plugin for web browsers"
HOMEPAGE="http://torrentstream.org/"
MY_PN="acestream-mozilla-plugin"
SRC_URI=" x86? ( http://repo.acestream.org/ubuntu/pool/main/a/${MY_PN}/${MY_PN}_${PV}-1raring2_i386.deb
				 https://github.com/megabaks/test/raw/master/distfiles/${MY_PN}_${PV}-1raring2_i386.deb )
		amd64? ( http://repo.acestream.org/ubuntu/pool/main/a/${MY_PN}/${MY_PN}_${PV}-1raring2_amd64.deb
				 https://github.com/megabaks/test/raw/master/distfiles/${MY_PN}_${PV}-1raring2_amd64.deb )"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="~media-video/acestream-player-data-${PV}
		net-p2p/acestream-engine"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install(){
	mv usr/lib/mozilla usr/lib/nsbrowser
	rm -rf usr/lib/xulrunner-addons usr/lib/mozilla-firefox
	cp -R usr "${D}"
}
