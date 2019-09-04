#Arg1 is bowtie2 index file "/hdata1/CIRCLE_ANALYSIS/MICRODNA-HG38/hg38"
#Arg2 is fastq file 1 "fastqfile1"
#Arg3 is fastq file 2 "fastqfile2"
#Arg4 is # of processor "24" Higher the number lower would be run time.
#Arg5 is Sample name  "C4-2" in this case because circular DNA was isolated from C4-2 cell lines. You want give anyname to sample 
#Arg6 Read length "49"
#Arg7 Longest circle wish to identify "10000" Higher this number more time it would take to finish the run.
#Arg8 Path of script directory
#USAGE: bash /path-of-script-directory/microDNA.InOne.sh /path-of-script-directory/hg38  Index11_1.fq Index11_2.fq 24 C4-2 49 10000 /path-of-script-directory/ & 
bowtie2 -x $1 -1 $2 -2 $3 --end-to-end -p $4 > $5-hg38.sam
samtools view -bS -@ $4 $5-hg38.sam -o $5-hg38.bam
samtools sort -@ $4 $5-hg38.bam -o $5-hg38.sorted.bam
samtools index $5-hg38.sorted.bam
samtools view -@ $4 -f 4 -F32 $5-hg38.sorted.bam | awk '$4>0 && $4==$8 && $6=="*"' | awk '$10!~/NNNNNNNNNN/ {printf("%sminus_%s_%d\t%s\t%s\n",$1,$3,$4,$10,$11)}' > $5.hg38_NM
samtools view -@ $4 -f 36 $5-hg38.sorted.bam | awk '$4>0 && $4==$8 && $6=="*"' | awk '$10!~/NNNNNNNNNN/ {printf("%splus_%s_%d\t%s\t%s\n",$1,$3,$4,$10,$11)}' >> $5.hg38_NM
bash $8/FromBamExtractProperpairreads2Island2Inetrsect2MappedUnmapped.sh $5-hg38.sorted.bam 195471971 $6 $5.hg38_NM 50 $4 $7 $8 > Island_PE
bash $8/microDNA.RunAsOneJob.parallel.bowtie.sh Island.Mapped-Unmapped_file.Intersect_PE.bed 1 $5-hg38.sorted.bam $1.fa $7 $4 $8
bash $8/LeftShift.co-ordinate.withJT.sh $1.fa $7 $8
bash $8/Check-whole-read-mappingon-probable-junction-plus-minus.sh microDNA.JT.postalign.bed $1.fa $6 $4 $5
bash $8/Direct-repeat.withJT.sh $1.fa $7 $8
#The final circle co-ordinate is based on 1 based system
