# !/usr/bin/bash 
# ------------------------------------------------------------------------------------------------------------------
# Script: /home/zhanggaopu/crisprome/bacteroides_RNA-seq/scripts/2-1.fastqc.sh
# This script is for quality checking of sequencing data with fastqc.
# Last modified: 24.3.13.
# ------------------------------------------------------------------------------------------------------------------

if [ -z $1 ]; then
    echo "Please provide the directory containing the input fastq files, at the first parameter."
    exit
else
    fastq_dir=${1}
    echo Directory of input fastq files: ${fastq_dir}
fi

if [ -z $2 ]; then
    echo "Please provide the file only containing the names of input fastq files, at the second parameter."
    exit
else
    fastq_list=${2}
    echo List of fastq files: ${fastq_list}
fi

if [ -z $3 ]; then
    echo "Please provide the directory for the output files from fastqc, at the third parameter."
    exit
else
    output_dir=${3}
    echo Directory for fastqc output: ${output_dir}; mkdir -p ${output_dir}
fi

cat ${fastq_list} | while read file
do
    echo ------------------------------------------
    cd ${fastq_dir}
    fastq=`ls ${file}* | grep "fastq"`
    echo ${fastq}
    fastqc -o ${output_dir} -f fastq --threads 16 ${fastq}
done

cd ${output_dir}
mkdir -p ./multiqc
multiqc ./ --outdir ./multiqc