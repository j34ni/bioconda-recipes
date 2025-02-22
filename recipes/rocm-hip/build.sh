#!/bin/bash

mkdir -p $PREFIX/opt/rocm/bin
mkdir -p $PREFIX/opt/rocm/include/hip
mkdir -p $PREFIX/opt/rocm/lib
mkdir -p $PREFIX/opt/rocm/doc/hip

if [ -d $SRC_DIR/include/hip ]; then
  cp -r $SRC_DIR/include/hip/* $PREFIX/opt/rocm/include/hip/
elif [ -d $SRC_DIR/include ]; then
  cp -r $SRC_DIR/include/* $PREFIX/opt/rocm/include/hip/ 2>/dev/null || true
fi

if [ -f $SRC_DIR/bin/hipcc ]; then
  cp $SRC_DIR/bin/hipcc $PREFIX/opt/rocm/bin/
  chmod +x $PREFIX/opt/rocm/bin/hipcc
fi

if [ -f $PREFIX/opt/rocm/bin/hipcc ]; then
  echo "#!/bin/bash" > $PREFIX/bin/hipcc
  echo "exec $PREFIX/opt/rocm/bin/hipcc \$@" >> $PREFIX/bin/hipcc
  chmod +x $PREFIX/bin/hipcc
fi
