# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Software for XRF data analysis"
HOMEPAGE="https://xraypy.github.io/xraylarch"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc python"

RDEPEND="
	>=dev-python/numpy-1.15[${PYTHON_USEDEP}]
	>=sci-libs/scipy-1.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.9[${PYTHON_USEDEP}]
	>=dev-python/h5py-2.8[${PYTHON_USEDEP}]
	>=sci-libs/scikits_learn-0.18[${PYTHON_USEDEP}]
	>=dev-python/pillow-3.4[${PYTHON_USEDEP}]
	>=dev-python/PeakUtils-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.1[${PYTHON_USEDEP}]
	>=sci-libs/lmfit-3.4
	>=dev-python/uncertainties-3.0.3[${PYTHON_USEDEP}]
	>=dev-python/asteval-0.9.13[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	dev-python/wxpython:*[${PYTHON_USEDEP}]
	dev-python/wxmplot[${PYTHON_USEDEP}]
	dev-python/wxutils[${PYTHON_USEDEP}]
	sci-libs/scikits_image[${PYTHON_USEDEP}]
	dev-python/silx[${PYTHON_USEDEP}]
	dev-python/pyFAI[${PYTHON_USEDEP}]
	dev-python/fabio[${PYTHON_USEDEP}]
	sci-libs/pycifrw[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/xraydb[${PYTHON_USEDEP}]
	dev-python/pyshortcuts[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.0[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
"
#	dev-python/pyepics
#	dev-python/tomopy
#for EPICS pyepics, psycopg2, epicsscan

PATCHES=(
	"${FILESDIR}"/conf.patch
	"${FILESDIR}"/py.patch
)

python_compile() {
	INSTALL_DIR="${D}"
	distutils-r1_python_compile
}

python_compile_all() {
	use doc && setup.py build
}

python_test() {
	setup.py test
}

python_install_all() {
	distutils-r1_python_install_all
}