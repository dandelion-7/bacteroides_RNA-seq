# !/usr/bin/bash 
# ------------------------------------------------------------------------------------------------------------------
# Script: /home/zhanggaopu/crisprome/bacteroides_RNA-seq/scripts/3.bowtie2.sh
# This script is for mapping bacterial RNA-seq data onto genomes with Bowtie2.
# Last modified: 24.3.14
# ------------------------------------------------------------------------------------------------------------------

if [ -z $1 ]; then
    echo "Please provide the directory containing the fastq files to be aligned, at the first parameter."
    exit
else
    fastq_dir=${1}
    echo Fastq files to be aligned: ${fastq_dir}
fi

if [ -z $2 ]; then
    echo "Please provide the file only containing the names of input fastq files, at the second parameter."
    exit
else
    fastq_list=${2}
    echo List of fastq files: ${fastq_list}
fi

if [ -z $3 ]; then
    echo "Please provide the directory for the output files from bowtie2 and samtools, at the third parameter."
    exit
else
    output_dir=${3}
    echo Directory for output: ${output_dir}; mkdir -p ${output_dir}
fi

if [ -z $4 ]; then
    echo "Please provide the directory of the bowtie2 reference."
    exit
else
    ref=${4}
    echo Bowtie2 reference: ${ref}
fi

cd ${fastq_dir}
cat ${fastq_list} | while read file
do
    echo ------------------------------------
    file_count=`ls ${file}*.fastq | wc -l`

    if [ ${file_count} == 1 ]; then
        fastq=`ls ${file}*.fastq`
        sam=${output_dir}/${file}.sam
        bam=${output_dir}/${file}.bam
        sorted_bam=${output_dir}/${file}_sorted.bam
        bai=${output_dir}/${file}.bai
        log=${output_dir}/${file}.log

        echo ${fastq}
        bowtie2 -p 32 -x ${ref} -U ${fastq} -S ${sam} 2> ${log}
        samtools view -b -S ${sam} > ${bam}; rm ${sam}
        samtools sort --threads 32 -o ${sorted_bam} ${bam}; rm ${bam}
        samtools index -b ${sorted_bam} ${bai}
    else
        fastq_1=`ls ${file}_1*.fastq`
        fastq_2=`ls ${file}_2*.fastq`
        sam=${output_dir}/${file}.sam
        bam=${output_dir}/${file}.bam
        sorted_bam=${output_dir}/${file}_sorted.bam
        bai=${output_dir}/${file}.bai
        log=${output_dir}/${file}.log

        echo ${fastq_1} ${fastq_2}
        bowtie2 -p 32 -x ${ref} -1 ${fastq_1} -2 ${fastq_2} -S ${sam} 2> ${log}
        samtools view -b -S ${sam} > ${bam}; rm ${sam}
        samtools sort --threads 32 -o ${sorted_bam} ${bam}; rm ${bam}
        samtools index -b ${sorted_bam} ${bai}
    fi
done
