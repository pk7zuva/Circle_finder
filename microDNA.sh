#Arg1 is pair-end sequencing file 1
#Arg2 is pair-end sequencing file 2
#Arg3 is sample-name XXXXXX
#Arg4 is Island file (/hdata4/YOSHI_HUMAN-PRONEURAL-GLIOMA_CELL/TMZr_S2/Island.Mapped-Unmapped_file_PE.bed)
/home/pk7z/bin/novocraft/novoalign -o SAM -r Random -t 100 -i 50-2000 -d /home/pk7z/bin/novocraft/hg38.k14.s1.ndx -f $1 $2 > $3.hg38.sam 2>novolog.txt
#(OVCA23_1_2_S1-S4_NM_1.txt OVCA23_1_2_S1-S4_NM_2.txt > OVCA23_1_2_S1-S4_NM_1_2.sam 2>novolog.txt &)

/home/pk7z/bin/samtools-1.3/samtools view -bS -@ 20 $3.hg38.sam -o $3.hg38.bam
/home/pk7z/bin/samtools-1.3/samtools sort -@ 20 $3.hg38.bam  -o $3.hg38.sorted.bam
/home/pk7z/bin/samtools-1.3/samtools index $3.hg38.sorted.bam
rm $3.hg38.sam $3.hg38.bam

/home/pk7z/bin/samtools-1.3/samtools view -@ 20 -f 4 -F264 $3.hg38.sorted.bam | awk '$4>0 && $4==$8 && $6=="*"' | awk '$10!~/N/ {printf("%s_%s_%d\t%s\t%s\n",$1,$3,$4,$10,$11)}' > $3.hg38\_NM

bash /home/pk7z/bin/FromBamExtractProperpairreads2Island2Inetrsect2MappedUnmapped4human.sh $3.hg38.sorted.bam 248956422 50 $3.hg38_NM 50 > Island_PE

bash /home/pk7z/bin/microDNA.RunAsOneJob.sh $4  /home/pk7z/bin/hg38.fa $3.hg38.sorted.bam
