#Author Pankaj Kumar
#Email: pankjrf@gmail.com
#This script generate junctional sequence on the basis of Island interval and sequence and map the junctional sequence on the unmapped reads of mapped-unmapped pairs.
#Argument 1 is file "Island.Mapped-Unmapped_file.Intersect_PE.bed"
#fastaFromBed -fi <genome-file> -bed <*.bed> -tab -fo <output.fasta>
#Arg2 is number of CPU for bowtie
#Argument 3 bam file name which is a sorted bam file. $2 file name "<samplename.sorted.bam>"
#ARG4 is whole genome file
#ARG5 is length of longest circle "10000"
#ARG6 is number of total parallel jobs
#ARG7 is path of script directory
#Removing the <junction.microDNA> if exits
#Usage: bash /hdata1/MICRODNA-HG38/microDNA.RunAsOneJob.parallel.applytoall.sh "Island.Mapped-Unmapped_file.Intersect_PE.bed" "1" "sorted-bam-file" "whole genome file" "length of leongest circle "number of parallel jobs""
rm junction.microDNA

#Taking 10 bases up and downstream sequence and making extracting genomic sequence for each interval

echo "awk '\$1~/chr/ && (\$3-\$2)<$5 {printf (\"%s\\t%d\\t%d\\n\",\$1,\$2-10,\$3+10)}' $1 | sort -nk2" > FFF
sh ./FFF | awk '$2>0 && $3>0' > Island.bed
fastaFromBed -fi $4 -bed Island.bed -tab -fo Island.fa

#Arg1 is "Island.fa" file
#Arg2 is number of CPU
#Arg3 is name of sorted bam file "<samplename.sorted.bam>"
#Arg4 is whole genome file
exec<"Island.fa"
while read line 
        do
Island=`echo $line | awk '{print \$1}'`

echo "mkdir $Island; echo $line > $Island/TeMp1; samtools view -@ $2 -f 4 -F32 $3 $Island | awk '{printf (\">%sminus-%s-%d\n%s\n\",\$1,\$3,\$4,\$10)}' > $Island/1.NM.fasta; samtools view -@ $2 -f 36 $3 $Island | awk '{printf (\">%splus-%s-%d\n%s\n\",\$1,\$3,\$4,\$10)}' >> $Island/1.NM.fasta; bowtie2-build --threads 2 $Island/1.NM.fasta $Island/1.NM; $7/JUNCTIONAL.TAG $Island/TeMp1 > $Island/junction.fa; bowtie2 -x $Island/1.NM -f -a --end-to-end --very-fast -p 1 --score-min 'C,0,-1' -U $Island/junction.fa | samtools view -@ $2 -bS -o $Island/junction.bam; bedtools bamtobed -cigar -i $Island/junction.bam > $Island/junction.bed; awk '\$7==\"40M\"' $Island/junction.bed | awk '{printf (\"%s\t%s\t%s\t%s\n\",\$4,\$1,\$7,\$6)}' >> junction.microDNA; rm -rf $Island"
done | parallel -j $6
