# !/usr/bin/bash
# ------------------------------------------------------------------------------------------------------------------
# Script: /home/zhanggaopu/crisprome/bacteroides_RNA-seq/scripts/5.featureCounts.sh
# This script is for counting the number of mapped reads on the annotated regions on genomes with featureCounts.
# Last modified: 24.3.19.
# ------------------------------------------------------------------------------------------------------------------

if [ -z $1 ]; then
    echo "Please provide the path to the directory containing the input sorted bam files."
    exit
else
    echo Input bam file path: ${1}
    INPUT_DIR=${1}
fi

if [ -z $2 ]; then
    echo "Please provide the gff table of the reference genome."
    exit
else
    echo Annotation gff table of reference genome: ${2}
    gff=${2}
fi

if [ -z $3 ]; then
    echo "Please provide the path for output."
    exit
else
    echo Output directory: ${3}
    OUTPUT_DIR=${3}; mkdir -p ${OUTPUT_DIR}
    tmp_dir=${OUTPUT_DIR}/tmp; mkdir -p ${tmp_dir}
fi

cd ${INPUT_DIR}
samples=`ls *_sorted.bam`
# echo ${samples}
output=${OUTPUT_DIR}/featureCounts_quality1_output.txt

# featureCounts -a ${gff} -t CDS,rRNA,tRNA -g locus_tag --tmpDir ${tmp_dir} -O -M -p -T 32 ${samples} -o ${output} #used for the gff file of B-theta # no quality/pair check.
# featureCounts -a ${gff} -t CDS,rRNA,tRNA -g locus_tag --tmpDir ${tmp_dir} -Q 1 -O -M -p -B -P -d 30 -C -T 32 ${samples} -o ${output} # quality check 1 and paired.
# featureCounts -a ${gff} -t CDS,rRNA,tRNA -g locus_tag --tmpDir ${tmp_dir} -Q 1 -O -M -p -T 32 ${samples} -o ${output} # quality check 10.
# featureCounts -a ${gff} -t CDS,rRNA,tRNA -g locus_tag --tmpDir ${tmp_dir} -Q 10 -O -M -p -T 32 ${samples} -o ${output} # quality check 10.
# featureCounts -a ${gff} -t CDS,tRNA -g locus_tag --tmpDir ${tmp_dir} -Q 1 -O -M -p -B -P -d 30 -C -T 32 ${samples} -o ${output} # quality check 1 and paired, ignore rRNA reads.
# featureCounts -a ${gff} -t CDS,tRNA,tmRNA,transcript,sequence_feature -g locus_tag --tmpDir ${tmp_dir} -Q 1 -p -O -M -T 32 ${samples} -o ${output} # quality check 1, ignore rRNA, for SE data.
# featureCounts -a ${gff} -t CDS,rRNA,tRNA -g locus_tag --tmpDir ${tmp_dir} -Q 1 -p -O -M -T 32 ${samples} -o ${output} # quality check 1, for SE data.
# featureCounts -a ${gff} -t CDS,tRNA,tmRNA,transcript,sequence_feature -g ID --tmpDir ${tmp_dir} -Q 1 -O -M -p -B -P -d 30 -C -T 32 ${samples} -o ${output} # quality check 1 and paired, ignore rRNA reads, B-uniformis 2022 Cell Host
featureCounts -a ${gff} -t CDS,tRNA,tmRNA,riboswitch,RNase_P_RNA -g ID --tmpDir ${tmp_dir} -Q 1 -O -M -p -B -P -d 30 -C -T 32 ${samples} -o ${output} # quality check 1 and paired, ignore rRNA reads, B-xylan 2016 BMC genomics.

rm -r ${tmp_dir}