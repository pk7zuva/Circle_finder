#Usage: bash "microDNA.InOne.sh" "Par_S1_L001_R1_001.fastq" "Par_S1_L001_R2_001.fastq" "Par_S1"  "Island.Mapped-Unmapped_file.Intersect_PE.bed"
#Arg1 is pair-end sequencing file 1
#Arg2 is pair-end sequencing file 2
#Arg3 is sample-name XXXXXX
#Arg4 is Island file which is generated after mapping the reads "Island.Mapped-Unmapped_file_PE.bed"

#Mapping of reads starts
novocraft/novoalign -o SAM -r Random -t 50 -i 50-2000 -d novocraft/hg38.k14.s1.ndx -f $1 $2 > $3.hg38.sam 2>novolog.txt
samtools-1.3/samtools view -bS -@ 20 $3.hg38.sam -o $3.hg38.bam
samtools-1.3/samtools sort -@ 20 $3.hg38.bam  -o $3.hg38.sorted.bam
samtools-1.3/samtools index $3.hg38.sorted.bam
rm $3.hg38.sam $3.hg38.bam
#Mapping of reads endss

#Extraction of mapped-unmapped pairs starts
samtools-1.3/samtools view -@ 20 -f 4 -F264 $3.hg38.sorted.bam | awk '$4>0 && $4==$8 && $6=="*"' | awk '$10!~/NNNNNNNNNN/ {printf("%s_%s_%d\t%s\t%s\n",$1,$3,$4,$10,$11)}' > $3.hg38\_NM
#Extraction of mapped-unmapped pairs ends

#Collect the mapped reads informations, make profile, identifying the islands and finally consider only those islands that intersect with mapped unmapped pair of reads
bash FromBamExtractProperpairreads2Island2Inetrsect2MappedUnmapped4human.sh $3.hg38.sorted.bam 248956422 50 $3.hg38_NM 50 > Island_PE

#Generate junctional tags on the basis of island information and map the junctional tags on unmapped reads of mapped-unmapped pairs and report the mapped junctional tags
bash microDNA.RunAsOneJob.sh $4  hg38.fa $3.hg38.sorted.bam

#Left shift the identified microDNA and report the unique microDNA and the number of junctional tags found
bash LeftShift.co-ordinate.withJT.sh

#Identify the direct repeat motif at the junction of microDNA and finally report the microDNA co-ordinate, number of junctional tags and direct repeat motif for each identified microDNA
bash direct-repeat.withJT.sh
