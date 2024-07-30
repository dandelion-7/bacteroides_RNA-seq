# !/usr/bin/bash 
# ------------------------------------------------------------------------------------------------------------------
# Script: /home/zhanggaopu/crisprome/bacteroides_RNA-seq/scripts/8-1.defense_system_coverage.sh
# This script is for calculating the coverage of predicted defense systems.
# Last modified: 24.6.11
# ------------------------------------------------------------------------------------------------------------------

if [ -z $1 ]; then
    echo "Please provide the path for the input sorted_bam files at the first parameter."
    exit
else
    INPUT_DIR=${1}
    echo Directory of input bam file:${1}
fi

if [ -z $2 ]; then
    echo "Please provide the file containing regions for plotting coverages."
    exit
else
    REGION_LIST=${2}
    echo Region for coverage plotting: ${2}
fi

if [ -z $3 ]; then
    echo "Please provide the path for the output file."
    exit
else
    OUTPUT_DIR=${3}; mkdir -p ${OUTPUT_DIR}
    echo Output directory: ${OUTPUT_DIR}
fi

cd ${INPUT_DIR}
bam_files=`ls *_sorted.bam`
output_head=`ls *_sorted.bam| xargs | sed "s/ /\t/g"`

cat ${REGION_LIST} | while read region name
do
    echo ${name}

    output=${OUTPUT_DIR}/${name}.txt
    cat /dev/null > ${output}
    echo -e "contig\tposition\t${output_head}" >> ${output}

    samtools depth -Q 10 -r ${region} -aa ${bam_files} >> ${output}
done