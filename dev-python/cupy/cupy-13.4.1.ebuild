# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
ROCM_VERSION=5.1.3
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 prefix pypi rocm cuda

DESCRIPTION="CuPy: A NumPy-compatible array library accelerated by CUDA"
SRC_URI="$(pypi_sdist_url "${PN^}" "${PV}")"
HOMEPAGE="https://cupy.dev/"

IUSE="rocm +cuda cudnn"
REQUIRED_USE="
	^^ ( cuda rocm )
	cudnn? ( cuda )
	rocm? ( ${ROCM_REQUIRED_USE} )
	"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
DEPEND="
	>=dev-python/cython-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
	cuda? ( <dev-util/nvidia-cuda-toolkit-12.9.0[profiler]
		<dev-libs/cudnn-9.0.9 )
	cudnn? ( dev-libs/cudnn )
	rocm? ( >=dev-util/hip-${ROCM_VERSION}
		>=dev-util/roctracer-${ROCM_VERSION}
		>=sci-libs/hipBLAS-${ROCM_VERSION}[${ROCM_USEDEP}]
		>=sci-libs/hipCUB-${ROCM_VERSION}[${ROCM_USEDEP}]
		>=sci-libs/hipFFT-${ROCM_VERSION}[${ROCM_USEDEP}]
		>=sci-libs/hipRAND-${ROCM_VERSION}[${ROCM_USEDEP}]
		>=sci-libs/rocThrust-${ROCM_VERSION}[${ROCM_USEDEP}]
		>=sci-libs/hipSPARSE-${ROCM_VERSION}[${ROCM_USEDEP}] )
		"
#dev-libs/cusparselt 
RDEPEND=">=dev-python/fastrlock-0.8.1
	${DEPEND}"

distutils_enable_tests pytest

#PATCHES=( "${FILESDIR}"/${PN}-11.6-add_dir.patch )

src_prepare ()
{
	#sed -i -e 's:_from_dict(CUDA_nccl,:#_from_dict(CUDA_nccl,:' install/cupy_builder/_features.py || die
	#sed -i -e 's:_from_dict(CUDA_cutensor,:#_from_dict(CUDA_cutensor,:' install/cupy_builder/_features.py || die
	#sed -i -e 's:_from_dict(CUDA_cusparselt:#_from_dict(CUDA_cusparselt:' install/cupy_builder/_features.py || die
	#sed -i -e 's:cuda/cupy_cutensor.h:#stub/cupy_cutensor.h:' cupy_backends/cupy_cutensor.h || die
	default
	eprefixify cupy/cuda/compiler.py
	use cuda && cuda_src_prepare
}

src_compile() {
	if use rocm; then
		addpredict /dev/kfd
		addpredict /dev/dri/
		export CUPY_INSTALL_USE_HIP=1
		export ROCM_HOME="${EPREFIX}/usr"
		local AMDGPU_FLAGS=$(get_amdgpu_flags)
		export HCC_AMDGPU_TARGET=${AMDGPU_FLAGS//;/,}
	elif use cuda; then
		# specify instructions to emit
		local target
		#export CUPY_USE_CUDA_PYTHON=1
		for target in ${NVPTX_TARGETS}; do
			CUPY_NVCC_GENERATE_CODE+="arch=${target/sm/compute},code=${target};"
		done
		export CUPY_NVCC_GENERATE_CODE
		export NVCC="nvcc ${NVCCFLAGS}"

		#NDEV="/dev/nvidia-uvm-tools"
		#[[ -e ${NDEV} ]] || die \
		#	"${NDEV} does not exist. Try `nvidia-modprobe -u -c 0` to create it."
		#for device in /dev/nvidia*; do
		#	addpredict "${device}"
		#done
	fi
	distutils-r1_src_compile
}
