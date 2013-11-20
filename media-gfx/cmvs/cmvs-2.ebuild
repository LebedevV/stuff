# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/cmvs/cmvs-2.ebuild,v 0.2 2013/11/19 09:30:12 Micky53 Exp $

EAPI=5

inherit eutils

DESCRIPTION="Clustering Views for Multi-view Stereo"
HOMEPAGE="http://www.di.ens.fr/cmvs/"
SRC_URI="http://www.di.ens.fr/cmvs/cmvs-fix2.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	sci-libs/clapack
	dev-libs/libf2c"
RDEPEND="${DEPEND}"

S="${WORKDIR}/cmvs/program/main/"

src_prepare() {
	rm *.so.*
	cd ${WORKDIR}
	rm rm cmvs/program/base/pmvs/filter.cc
	#patch by Micky53 micky53@mail.ru
	epatch "${FILESDIR}"/fix_from_Micky53-v3.patch
}

src_compile() {
	emake YOURINCLUDEPATH="${CXXFLAGS}" YOURLDLIBPATH="${LDFLAGS}" depend
        emake YOURINCLUDEPATH="${CXXFLAGS}" YOURLDLIBPATH="${LDFLAGS}"
}

src_install() {
	dobin ${WORKDIR}/cmvs/program/main/pmvs2 ${WORKDIR}/cmvs/program/main/cmvs ${WORKDIR}/cmvs/program/main/genOption
}
