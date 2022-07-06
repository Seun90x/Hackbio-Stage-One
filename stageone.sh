#!usr/bin/bash

#downloading fasta file
wget https://raw.githubusercontent.com/HackBio-Internship/wale-home-tasks/main/DNA.fa

#counting sequence
grep -c ">" DNA.fa

#counting total ATGC 
grep -v ">" DNA.fa | wc -c

#setting up a conda environment
conda --create {stageone_task}
conda activate {stageone_task}

#installing packages
sudo apt-get install fastqc
sudo apt-get install cutadapt
sudo apt-get install seqtk
sudo apt-get install samtools
sudo apt-get install  fastp
sudo apt-get -y install multiqc

#downloading datasets
wget https://raw.githubusercontent.com/josoga2/yt-dataset/main/dataset/aligner.sh
wget https://raw.githubusercontent.com/josoga2/yt-dataset/main/dataset/trim.sh
wget https://github.com/josoga2/yt-dataset/raw/main/dataset/ACBarrie_R1_rep.fastq.gz
wget https://github.com/josoga2/yt-dataset/raw/main/dataset/ACBarrie_R2_rep.fastq.gz
wget https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Alsen_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Alsen_R2.fastq.gz
wget https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Baxter_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Baxter_R2.fastq.gz
wget https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Chara_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Chara_R2.fastq.gz
wget https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Drysdale_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/raw/main/dataset/raw_reads/Drysdale_R2.fastq.gz

mkdir output
mkdir fastqc_report
#implementing fastqc on datasets
fastqc ACBarrie_R1_rep.fastq.gz -o fastqc_report/
fastqc ACBarrie_R2_rep.fastq.gz -o fastqc_report/
fastqc Alsen_R1.fastq.gz -o fastqc_report/
fastqc Alsen_R2.fastq.gz -o fastqc_report/
fastqc Baxter_R1.fastq.gz -o fastqc_report/
fastqc Baxter_R2.fastq.gz -o fastqc_report/
fastqc Chara_R1.fastq.gz -o fastqc_report/
fastqc Chara_R2.fastq.gz -o fastqc_report/
fastqc Drysdale_R1.fastq.gz -o fastqc_report/
fastqc Drysdale_R2.fastq.gz -o fastqc_report/

#implementing fastp on datasets

mkdir trimmed_reads

for sample in $(cat datasets.txt) ; do
fastp \
	-i "${sample}_R1.fastq.gz" \
	-I "${sample}_R2.fastq.gz" \
	-o "trimmed_reads/${sample}_R1.fastq.gz" \
	-O "trimmed_reads/${sample}_R2.fastq.gz" \
	--html "trimmed_reads_/${sample}_fastp.html"
done

#implementing multiqc on datasets

multiqc fastqc_report/

#moving outputs to output directory

mv fastqc_report/ trimmed_reads/ output
