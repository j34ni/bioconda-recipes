#!/bin/bash
set -x -e

RM_DIR="${PREFIX}/share/RepeatModeler"
mkdir -p ${PREFIX}/bin
mkdir -p ${RM_DIR}

sed -i.bak '1 s|^.*$|#!/usr/bin/env perl|g' util/*.pl
sed -i.bak '1 s|^.*$|#!/usr/bin/env perl|g' BuildDatabase
sed -i.bak '1 s|^.*$|#!/usr/bin/env perl|g' LTRPipeline
sed -i.bak '1 s|^.*$|#!/usr/bin/env perl|g' Refiner
sed -i.bak '1 s|^.*$|#!/usr/bin/env perl|g' RepeatClassifier
sed -i.bak '1 s|^.*$|#!/usr/bin/env perl|g' RepeatModeler

rm -rf *.bak
rm -rf util/*.bak

cp -rf * ${RM_DIR}

# configure
cd ${RM_DIR}

# prompt 1: <PRESS ENTER TO CONTINUE>
# prompt 2: confirm path to running perl interpreter
# prompt 3: Configure for LTR structural search [y] or n?
# Answering n, because NINJA is not yet in bioconda
CONFIG_OPTIONS=" \
    -cdhit_dir ${PREFIX}/bin \
    -genometools_dir ${PREFIX}/bin \
    -ltr_retriever_dir ${PREFIX}/bin \
    -mafft_dir ${PREFIX}/bin \
    -recon_dir ${PREFIX}/bin \
    -repeatmasker_dir ${PREFIX}/share/RepeatMasker \
    -rmblast_dir ${PREFIX}/bin \
    -rscout_dir ${PREFIX}/bin \
    -trf_dir ${PREFIX}/bin \
    -ucsctools_dir ${PREFIX}/bin \
    -repeatafterme_dir ${PREFIX}/bin"
    
if [[ "$(uname -s)" == "Linux" ]]; then
    LTR_STRUCTURAL_SEARCH="y"
    CONFIG_OPTIONS+=" \
    -ninja_dir ${PREFIX}/bin"
else
    LTR_STRUCTURAL_SEARCH="n"
    # ninja_dir option not set for osx because package not available in bioconda
fi

sed -i.bak '1 s|^.*$|#!/usr/bin/env perl|g' configure
rm -rf *.bak

# prompt 1: <PRESS ENTER TO CONTINUE>
# prompt 2: confirm path to running perl interpreter
# prompt 3: Configure for LTR structural search [y] or n?
# Answering y for linux; n for osx because NINJA is not available for osx in bioconda
printf "\n\n${LTR_STRUCTURAL_SEARCH}\n" | perl ./configure ${CONFIG_OPTIONS}

# add RepeatModeler
ln -sf ${RM_DIR}/RepeatModeler ${PREFIX}/bin/RepeatModeler

# add other tools
RM_OTHER_PROGRAMS="BuildDatabase LTRPipeline Refiner RepeatClassifier"
for name in ${RM_OTHER_PROGRAMS}; do
  ln -sf ${RM_DIR}/${name} ${PREFIX}/bin/${name}
done

# add utils
# note that not all utils are linked directly in bin/, but
# can still be accessed via ${PREFIX}/share/RepeatModeler/util/*.pl
RM_UTILS="alignAndCallConsensus.pl generateSeedAlignments.pl viewMSA.pl Linup"
for name in ${RM_UTILS}; do
  ln -sf ${RM_DIR}/util/${name} ${PREFIX}/bin/${name}
done
