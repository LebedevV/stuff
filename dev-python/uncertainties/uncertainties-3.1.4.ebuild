# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8})

inherit distutils-r1

DESCRIPTION="Python module for calculations with uncertainties"
HOMEPAGE="https://pythonhosted.org/uncertainties/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

ppython_compile_all() {
	if use doc; then
		PYTHONPATH="${BUILD_DIR}"/lib esetup.py build_sphinx
	fi
}

python_compile_all() {
	use doc && "${PYTHON}" setup.py build_sphinx
}

python_test() {
	esetup.py nosetests -sv || die
}

python_install_all() {
	use doc && local HTML_DOCS=( build/sphinx/html/. )
	distutils-r1_python_install_all
}
