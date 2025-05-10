#!/bin/bash
set -ex

# Export compilers from conda build environment
export CC="${CC}"
export CXX="${CXX}"
export FC="${FC}"
export PERL="${PERL}"
export PYTHON="${PYTHON}"

# Install Devel::CheckLib manually (non-interactively)
cd checklib
perl Makefile.PL INSTALLDIRS=vendor PREFIX="${PREFIX}" LIB="${PREFIX}/lib/perl5/vendor_perl"
make
make install PREFIX="${PREFIX}"
cd ..

# Set up Python environment and paths
python -c "import numpy; print('NumPy:', numpy.__version__)"
python -c "import scipy; print('SciPy:', scipy.__version__)"
python -c "import astropy; print('Astropy:', astropy.__version__)"
python -c "import matplotlib; print('Matplotlib:', matplotlib.__version__)"

# Export Python package include paths 
export NUMPY_INCLUDE=$(python -c "import numpy; print(numpy.get_include())")
export ASTROPY_INCLUDE=$(python -c "import astropy; print(astropy.get_include())")
export SCIPY_INCLUDE=$(python -c "import scipy; print(scipy.__path__[0])")
export MATPLOTLIB_INCLUDE=$(python -c "import matplotlib; print(matplotlib.__path__[0])")
export PYTHON_INCLUDE=$(python -c "import sysconfig; print(sysconfig.get_path('include'))")

# Explicitly disable parallel builds
export MAKEFLAGS="-j1"

cd heasoft/BUILD_DIR

# Set important environment variables with the Python includes
export CFLAGS="${CFLAGS} -I${PREFIX}/include -I${NUMPY_INCLUDE} -I${PYTHON_INCLUDE} -I${BUILD_PREFIX}/include -fPIC"
export CXXFLAGS="${CXXFLAGS} -I${PREFIX}/include -I${NUMPY_INCLUDE} -I${PYTHON_INCLUDE} -I${BUILD_PREFIX}/include -fPIC"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -L${BUILD_PREFIX}/lib -Wl,-rpath,${PREFIX}/lib"
export FFLAGS="${FFLAGS} -fPIC"
export PYTHONPATH="${PREFIX}/lib/python${PY_VER}/site-packages:${PYTHONPATH}"

# Set Perl environment variables to avoid Perl installation issues
export PERL_MM_USE_DEFAULT=1
export PERL_EXTUTILS_AUTOINSTALL="--defaultdeps"
export PERL5LIB="${PREFIX}/lib/perl5/vendor_perl:${PREFIX}/lib/perl5:${PERL5LIB}"

# Configure with proper X11 paths - following NASA's recommendations
./configure --prefix="${PREFIX}" \
            --x-includes="${PREFIX}/include" \
            --x-libraries="${PREFIX}/lib"
make -j1
make install
