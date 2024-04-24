# !/usr/bin/bash 
# ------------------------------------------------------------------------------------------------------------------
# Script: /home/zhanggaopu/crisprome/bacteroides_RNA-seq/scripts/2-2.fastp.sh
# This script is for filtering raw data with fastp.
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
    echo "Please provide the directory for the output files from fastp, at the third parameter."
    exit
else
    output_dir=${3}
    echo Directory for fastp output: ${output_dir}; mkdir -p ${output_dir}
fi

source activate fastp
cd ${fastq_dir}
cat ${fastq_list} | while read file
do
    echo -----------------------------
    file_count=`ls ${file}* | wc -l`
    if [ ${file_count} == 1 ]; then
        fastq=`ls ${file}*`
        echo ${fastq}

        out1=${output_dir}/${file}_fastp.fastq
        json=${output_dir}/${file}.json
        html=${output_dir}/${file}.html
        fastp --in1 ${fastq} --out1 ${out1} --trim_poly_g -j ${json} -h ${html} --thread 32 --length_required 30
    else
        fastq_1=`ls ${file}_1*`
        fastq_2=`ls ${file}_2*`
        echo ${fastq_1} ${fastq_2}

        out1=${output_dir}/${file}_1_fastp.fastq
        out2=${output_dir}/${file}_2_fastp.fastq
        unpaired=${output_dir}/${file}_se_fastp.fastq
        json=${output_dir}/${file}.json
        html=${output_dir}/${file}.html
        # fastp --in1 ${fastq_1} --in2 ${fastq_2} --out1 ${out1} --out2 ${out2} --unpaired1 ${unpaired} --unpaired2 ${unpaired} -j ${json} -h ${html} --detect_adapter_for_pe --correction --trim_poly_g --thread 16 --length_required 30 --trim_front1 5 --trim_front2 5
        # fastp --in1 ${fastq_1} --in2 ${fastq_2} --out1 ${out1} --out2 ${out2} --unpaired1 ${unpaired} --unpaired2 ${unpaired} -j ${json} -h ${html} --detect_adapter_for_pe --correction --trim_poly_g --thread 16 --length_required 30 --trim_front1 3 --trim_front2 3 --trim_tail1 1 --trim_tail2 1 # data from Cell Reports used this parameter setting.
        # fastp --in1 ${fastq_1} --in2 ${fastq_2} --out1 ${out1} --out2 ${out2} --unpaired1 ${unpaired} --unpaired2 ${unpaired} -j ${json} -h ${html} --detect_adapter_for_pe --correction --trim_poly_g --thread 16 --length_required 30 --trim_front1 9 --trim_front2 9 # data of B.uniformis used this parameter setting.
        fastp --in1 ${fastq_1} --in2 ${fastq_2} --out1 ${out1} --out2 ${out2} --unpaired1 ${unpaired} --unpaired2 ${unpaired} -j ${json} -h ${html} --detect_adapter_for_pe --correction --trim_poly_g --thread 32 --length_required 30 --trim_front1 5 --trim_front2 5 --trim_tail1 5 --trim_tail2 5 # data of B.theta from 2024 Nature Microbiology paper.

    fi
done
conda deactivate