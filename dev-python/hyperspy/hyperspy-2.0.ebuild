# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 flag-o-matic virtualx pypi

DESCRIPTION="Interactive analysis of multidimensional datasets tools"
HOMEPAGE="https://hyperspy.org/"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}")"
S=${WORKDIR}/${P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="mrcz tests"
IUSE="cuda python doc +learning +gui-jupyter speed +gui-traitsui mrcz test"

RDEPEND="
	dev-python/rosettasciio[${PYTHON_USEDEP}]
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/pooch[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.17.1[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.5[${PYTHON_USEDEP}]
	dev-python/natsort[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.1[${PYTHON_USEDEP}]
	>=dev-python/traits-4.5.0[${PYTHON_USEDEP}]
	>=dev-python/pyface-7.4.1[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/tqdm-0.4.9[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	dev-python/dill[${PYTHON_USEDEP}]
	>=dev-python/h5py-2.3[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.5.0[${PYTHON_USEDEP}]
	dev-python/ipyparallel[${PYTHON_USEDEP}]
	>=dev-python/dask-0.18[${PYTHON_USEDEP}]
	>=dev-python/scikit-image-0.15[${PYTHON_USEDEP}]
	>=dev-python/Pint-0.10[${PYTHON_USEDEP}]
	dev-python/statsmodels[${PYTHON_USEDEP}]
	dev-python/numexpr[${PYTHON_USEDEP}]
	dev-python/sparse[${PYTHON_USEDEP}]
	dev-python/imageio[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/zarr[${PYTHON_USEDEP}]
	dev-python/prettytable[${PYTHON_USEDEP}]
	dev-python/matplotlib_scalebar[${PYTHON_USEDEP}]
	!dev-python/PTable
	>=dev-python/tifffile-2019.12.3[${PYTHON_USEDEP}]
	>=dev-python/importlib-metadata-3.6[${PYTHON_USEDEP}]
	doc? ( >=app-misc/sphinx-1.7 dev-python/sphinx_rtd_theme )
	learning? ( dev-python/scikit-learn[${PYTHON_USEDEP}] )
	speed? ( dev-python/numba[${PYTHON_USEDEP}] dev-python/cython[${PYTHON_USEDEP}] )
	cuda? ( dev-python/cupy[${PYTHON_USEDEP}] )
"
	##
	##mrcz? ( >=dev-python/blosc-1.5 >=dev-python/mrcz-0.3.6 )
	#	<dev-python/matplotlib-3.5[${PYTHON_USEDEP}]

DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	test? ( >=dev-python/pytest-3.6[${PYTHON_USEDEP}]
		dev-python/pytest-mpl[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP},-test]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP},-test]
	)
"

PDEPEND="
	gui-jupyter? ( >=dev-python/hyperspy-gui-ipywidgets-2.0 )
	gui-traitsui? ( >=dev-python/hyperspy-gui-traitsui-2.0 )
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

python_compile() {
	distutils-r1_python_compile
}

python_compile_all() {
	use doc && setup.py build
}

python_test() {
	virtx epytest
}

python_install_all() {
	distutils-r1_python_install_all
}
