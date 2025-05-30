# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..12} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 llvm git-r3

DESCRIPTION="Python wrapper around the llvm C++ library"
HOMEPAGE="https://llvmlite.pydata.org/"
EGIT_REPO_URI="https://github.com/numba/llvmlite.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86 ~amd64-linux ~x86-linux"
IUSE="examples"

LLVM_MAX_SLOT=15

RDEPEND="
	llvm-core/llvm:${LLVM_MAX_SLOT}
	sys-libs/zlib:0=
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	sed -i -e '/max_python/s:3\.10:3.11:' setup.py || die
	distutils-r1_src_prepare
}

python_configure_all() {
	# upstream's build system is just horrible, and they ignored the PR
	# fixing it, so let's build the shared lib properly using implicit
	# make rules

	export LDLIBS=$(llvm-config --libs all)
	export CXXFLAGS="$(llvm-config --cxxflags) -fPIC ${CXXFLAGS}"
	export LDFLAGS="$(llvm-config --ldflags) ${LDFLAGS}"

	local files=( ffi/*.cpp )
	emake -f - <<EOF
ffi/libllvmlite.so: ${files[*]/.cpp/.o}
	\$(CXX) -shared \$(CXXFLAGS) \$(LDFLAGS) -o \$@ \$^ \$(LDLIBS)
EOF

	export LLVMLITE_SKIP_LLVM_VERSION_CHECK=1
}

python_test() {
	"${EPYTHON}" runtests.py -v || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
