# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="A GPU Implementation of SIFT"
HOMEPAGE="http://cs.unc.edu/~ccwu/siftgpu/"
SRC_URI="http://wwwx.cs.unc.edu/~ccwu/cgi-bin/siftgpu.cgi -> SiftGPU-V400.zip"

LICENSE="UNC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cuda"

DEPEND="media-libs/glew
		media-libs/devil
		cuda? ( dev-util/nvidia-cuda-toolkit )"
RDEPEND="${DEPEND}"

MAKEOPTS="-j1"

S="${WORKDIR}/SiftGPU"

src_prepare() {
	if use cuda ; then
		epatch "${FILESDIR}"/with-cuda.patch
	else
		epatch "${FILESDIR}"/no-cuda.patch
	fi
}

src_install() {
	dobin "${S}"/bin/MultiThreadSIFT "${S}"/bin/SimpleSIFT "${S}"/bin/speed "${S}"/bin/TestWinGlut
	dolib "${S}"/bin/libsiftgpu.so
	insinto /usr/include
	doins "${S}"/bin/libsiftgpu.a
	dodoc -r doc data demos
}
