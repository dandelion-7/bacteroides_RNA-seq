# !/usr/bin/bash 
# ------------------------------------------------------------------------------------------------------------------
# Script: /home/zhanggaopu/crisprome/artifical_microbiome/scripts/1.downloading_raw_data.sh
# This script is for downloading the sra raw data through prefetch.
# Last modified: 24.3.12.
# ------------------------------------------------------------------------------------------------------------------

# set the command for running.
if [ -z $1 ]; then
    echo "Please provide the command you want to perform: prefetch / md5sum / fastq-dump / rename, at the first parameter."
    exit
elif [ ${1}=="prefetch" ] | [ ${1}=="md5sum" ] | [ ${1}=="fastq-dump" ] | [ ${1}=="rename" ]; then
    command=${1}
    echo Command to be run: ${command}
else
    echo "Please provide an avavilable command: prefetch / md5sum / fastq-dump / rename."
    exit
fi

# For prefetch (downloading) SRR, the SRR list and output directory are required.
if [ ${command} == "prefetch" ]; then
    if [ -z $2 ]; then
        echo "Please provide the file only containing the SRR codes to be downloaded at the second parameter."
        exit
    else
        srr_list=${2}
        echo SRR list to be downloaded: ${srr_list}
    fi

    if [ -z $3 ]; then
        output_dir=`pwd`
        echo Files will be downloaded into the current directory: ${output_dir}
    else
        output_dir=${3}
        echo Files will be downloaded into: ${output_dir}
    fi

    mkdir -p ${output_dir}/temp; cd ${output_dir}/temp
    cat ${srr_list} | while read srr
    do
        echo ${srr}
        prefetch ${srr}
    done

    cd ${output_dir}/temp
    mv */*.sra ${output_dir}
    cd ${output_dir}; rm -r ${output_dir}/temp


# For md5sum checking the downloaded sra file, the directory containing the sra files, the md5 code file, and the output file of results are required.
elif [ ${command} == "md5sum" ]; then
    if [ -z $2 ]; then
        echo "Please provide the directory containing the downloaded sra files, at the second parameter."
        exit
    else
        sra_dir=${2}
        echo sra files in ${sra_dir} will be checked.
    fi

    if [ -z $3 ]; then
        echo Please provide the file containing md5 code and file names at the third parameter.
        exit
    else
        md5_srr=${3}
        echo Check the files according to: ${md5_srr}
    fi

    if [ -z $4 ]; then
        echo md5sum check results will be printed on the screen.
    else
        md5sum_check_output=${4}
        echo md5sum check results will be written into: ${md5sum_check_output}
    fi

    cd ${sra_dir}
    md5sum --check ${md5_srr} > ${md5sum_check_output} 


# for fastq-dump, the SRR list (same with prefetch), directory of sra files, and output directory for fastq files are required.
elif [ ${command} == "fastq-dump" ]; then
    if [ -z $2 ]; then
        echo "Please provide the file only containing the downloaded SRR codes at the second parameter, same with prefetch."
        exit
    else
        srr_list=${2}
        echo SRR list to be converted to fastq: ${srr_list}
    fi

    if [ -z $3 ]; then
        echo "Please provide the directory containing the downloaded sra files, at the third parameter, same with md5sum."
        exit
    else
        sra_dir=${3}
        echo sra files in ${sra_dir} will be converted to fastq.
    fi

    if [ -z $4 ]; then
        echo Please provide the path for converted fastq files at the fourth parameter.
        exit
    else
        fastq_output=${4}
        echo Fastq files converted from sra files will be saved in: ${fastq_output}
    fi

    mkdir -p ${fastq_output}; cd ${fastq_output}
    cat ${srr_list} | while read srr
    do
        sra=${sra_dir}/${srr}.sra
        echo ${sra}
        fasterq-dump ${sra} --split-3 -O ${fastq_output}
    done

# for renaming fastq files, the SRR_new_name file is required, and the path of fastq files is required.
elif [ ${command} == "rename" ]; then
    if [ -z $2 ]; then
        echo "Please provide the paired SRR_name file at the second parameter."
        exit 
    else
        SRR_name=${2}
        echo Renaming file: ${SRR_name}
    fi

    if [ -z $3 ]; then
        echo "Please provide the directory of all fastq files."
        exit 
    else
        fastq_dir=${3}
        echo Fastq directory: ${fastq_dir}
    fi

    cd ${fastq_dir}
    cat ${SRR_name} | while read srr name
    do
        rename "${srr}" "${name}" *
    done
fi


# mkdir -p /home/zhanggaopu/crisprome/artifical_microbiome/intermediates/3.B-theta_RNA-seq_raw_data/raw_data/sra
# cd /home/zhanggaopu/crisprome/artifical_microbiome/intermediates/3.B-theta_RNA-seq_raw_data/raw_data/sra
# cat /home/zhanggaopu/crisprome/artifical_microbiome/intermediates/3.B-theta_RNA-seq_raw_data/data_table/SRR.txt | while read SRR
# do
    # echo ${SRR}
    # prefetch ${SRR}
# done

# moving all the .sra files into one folder.
# md5sum check
# cd /home/zhanggaopu/crisprome/artifical_microbiome/intermediates/3.B-theta_RNA-seq_raw_data/raw_data/sra
# md5sum --check /home/zhanggaopu/crisprome/artifical_microbiome/intermediates/3.B-theta_RNA-seq_raw_data/data_table/md5.txt
# all OK.

# use fastq-dump to convert .sra into .fastq files.
# mkdir -p /home/zhanggaopu/crisprome/artifical_microbiome/intermediates/3.B-theta_RNA-seq_raw_data/raw_data/fastq
# cd /home/zhanggaopu/crisprome/artifical_microbiome/intermediates/3.B-theta_RNA-seq_raw_data/raw_data/fastq
# cat /home/zhanggaopu/crisprome/artifical_microbiome/intermediates/3.B-theta_RNA-seq_raw_data/data_table/SRR.txt | while read SRR
# do
    # sra=/home/zhanggaopu/crisprome/artifical_microbiome/intermediates/3.B-theta_RNA-seq_raw_data/raw_data/sra/${SRR}.sra
    # echo ${sra}
    # fastq-dump ${sra} --split-3 -O /home/zhanggaopu/crisprome/artifical_microbiome/intermediates/3.B-theta_RNA-seq_raw_data/raw_data/fastq
# done

# rename the fastq files.
# cd /home/zhanggaopu/crisprome/artifical_microbiome/intermediates/3.B-theta_RNA-seq_raw_data/raw_data/fastq
# cat /home/zhanggaopu/crisprome/artifical_microbiome/intermediates/3.B-theta_RNA-seq_raw_data/data_table/new_names.txt | while read old new
# do
    # mv ${old}.fastq ${new}.fastq
# done