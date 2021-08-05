#Use this script if your read length is >= 75
#Arg1 = Number of processors
#Arg2 = Genome or index file "/hdata1/MICRODNA-HG38/hg38.fa"
#Arg3 = fastq file 1 "1E_S1_L1-L4_R1_001.fastq"
#Arg4 = fastq file 2 "1E_S1_L1-L4_R2_001.fastq"
#Arg5 = minNonOverlap between two split reads "10"
#Arg6 = Sample name "1E"
#Arg7 = genome build "hg38"

#Usage: bash "Number of processors" "/path-of-whole-genome-file/hg38.fa" "fastq file 1" "fastq file 2" "minNonOverlap between two split reads" "Sample name" "genome build"
#bash circle_finder-pipeline-bwa-mem-samblaster.sh 16 hg38.fa 1E_S1_L1-L4_R1_001.fastq.75bp-R1.fastq 1E_S1_L1-L4_R2_001.fastq.75bp-R2.fastq 10 1E hg38

#Step 1: Mapping.

bwa mem -t $1 $2 $3 $4 | samblaster -e --minNonOverlap $5 -d $6-$7\.disc.sam -s $6-$7\.split.sam -u $6-$7\.unmap.sam > $6-$7\.sam

#Step 2: Converting (sam2bam), sorting and indexing mapped reads. Output of this step is input in step 3

samtools view -@ $1 -bS $6-$7\.sam -o $6-$7\.bam
samtools sort -@ $1 -O bam -o $6-$7\.sorted.bam $6-$7\.bam
samtools index $6-$7\.sorted.bam

samtools view -@ $1 -bS $6-$7\.disc.sam > $6-$7\.disc.bam
samtools view -@ $1 -bS $6-$7\.split.sam > $6-$7\.split.bam
samtools view -@ $1 -bS $6-$7\.unmap.sam > $6-$7\.unmap.bam

#Step 3: Extract concordant pairs with headers 

samtools view  -@ $1 -hf 0x2 $6-$7\.sorted.bam -bS > $6-$7\.concordant.bam

#Step 4: Converting bam to bed format (Remember bedtools generate 0 based co-ordinates)

bedtools bamtobed -cigar -i $6-$7\.split.bam | sed -e s/_2\\/2/\ 2/g | sed -e s/_1\\/1/\ 1/g | awk '{printf ("%s\t%d\t%d\t%s\t%d\t%d\t%s\t%s\n",$1,$2,$3,$4,$5,$6,$7,$8)}' | awk 'BEGIN{FS=OFS="\t"} {gsub("M", " M ", $8)} 1' | awk 'BEGIN{FS=OFS="\t"} {gsub("S", " S ", $8)} 1' | awk 'BEGIN{FS=OFS="\t"} {gsub("H", " H ", $8)} 1' | awk 'BEGIN{FS=OFS=" "} {if (($9=="M" && $NF=="H") || ($9=="M" && $NF=="S"))  {printf ("%s\tfirst\n",$0)} else if (($9=="S" && $NF=="M") || ($9=="H" && $NF=="M")) {printf ("%s\tsecond\n",$0)} }' | awk 'BEGIN{FS=OFS="\t"} {gsub("\ ", "", $8)} 1' > $6-$7\.split.txt
#bedtools bamtobed -cigar -i $6-$7\.concordant.bam | sed -e s/\\//\ /g | awk '{printf ("%s\t%d\t%d\t%s\t%d\t%d\t%s\t%s\n",$1,$2,$3,$4,$5,$6,$7,$8)}' > $6-$7\.concordant.txt
bedtools bamtobed -cigar -i $6-$7\.sorted.bam | sed -e s/\\//\ /g | awk '{printf ("%s\t%d\t%d\t%s\t%d\t%d\t%s\t%s\n",$1,$2,$3,$4,$5,$6,$7,$8)}' > $6-$7\.concordant.txt
bedtools bamtobed -cigar -i $6-$7\.disc.bam | sed -e s/\\//\ /g | awk '{printf ("%s\t%d\t%d\t%s\t%d\t%d\t%s\t%s\n",$1,$2,$3,$4,$5,$6,$7,$8)}' > $6-$7\.disc.txt

#step 5: Calculating the Read-ID frequency. The frequency of 2 would indicate that particular Read is uniquely mapping in genome and there are only two split-mapped reads

awk '{print $4}' $6-$7\.split.txt | sort | uniq -c > $6-$7\.split.id-freq.txt
#This file "$6-$7\.split.id-freq.txt" will be used for collecting split id that have frequency equal to 4.
awk '$1=="2" {print $2}' $6-$7\.split.id-freq.txt > $6-$7\.split.id-freq2.txt
awk '$1=="4" {print $2}' $6-$7\.split.id-freq.txt > $6-$7\.split.id-freq4.txt

awk '{print $4}' $6-$7\.concordant.txt | sort | uniq -c > $6-$7\.concordant.id-freq.txt
#The following command will chose (may not be always true) one concordant and 2 split read
awk '$1=="3" {print $2}' $6-$7\.concordant.id-freq.txt > $6-$7\.concordant.id-freq3.txt
awk '$1>3 {print $2}' $6-$7\.concordant.id-freq.txt > $6-$7\.concordant.id-freqGr3.txt

#Step 6: Selecting split reads that were 1) mapped uniquely and 2) mapped on more than one loci. For normal microDNA identification no need to use the "freqGr2" file
grep -w -Ff $6-$7\.split.id-freq2.txt $6-$7\.split.txt > $6-$7\.split_freq2.txt
grep -w -Ff $6-$7\.split.id-freq4.txt $6-$7\.split.txt > $6-$7\.split_freq4.txt

#Selecting concordant pairs that were 1) mapped uniquely and 2) mapped on more than one loci (file "freqGr3.txt")
grep -w -Ff $6-$7\.concordant.id-freq3.txt $6-$7\.concordant.txt > $6-$7\.concordant_freq3.txt
grep -w -Ff $6-$7\.concordant.id-freqGr3.txt $6-$7\.concordant.txt > $6-$7\.concordant_freqGr3.txt

#Step 7: Putting split read with same id in one line
sed 'N;s/\n/\t/' $6-$7\.split_freq2.txt > $6-$7\.split_freq2.oneline.txt
sed 'N;s/\n/\t/' $6-$7\.split_freq4.txt > $6-$7\.split_freq4.oneline.txt

#Step 8: Split reads map on same chromosome and map on same strand. Finally extracting id (split read same chromosome, split read same strand), collecting all the split reads that had quality >0
awk '$1==$10 && $7==$16 && $6>0 && $15>0 {print $4} ' $6-$7\.split_freq2.oneline.txt > $6-$7\.split_freq2.oneline.S-R-S-CHR-S-ST.ID.txt

#Step 9: Based on unique id I am extracting one continuously mapped reads and their partner mapped as split read (3 lines for each id) 
grep -w -Ff $6-$7\.split_freq2.oneline.S-R-S-CHR-S-ST.ID.txt $6-$7\.concordant_freq3.txt > $6-$7\.concordant_freq3.2SPLIT-1M.txt

#Step 10: Sorting based on read-id followed by length of mapped reads.
awk 'BEGIN{FS=OFS="\t"} {gsub("M", " M ", $8)} 1' $6-$7\.concordant_freq3.2SPLIT-1M.txt | awk 'BEGIN{FS=OFS="\t"} {gsub("S", " S ", $8)} 1' | awk 'BEGIN{FS=OFS="\t"} {gsub("H", " H ", $8)} 1' | awk 'BEGIN{FS=OFS=" "} {if (($9=="M" && $NF=="H") || ($9=="M" && $NF=="S"))  {printf ("%s\tfirst\n",$0)} else if (($9=="S" && $NF=="M") || ($9=="H" && $NF=="M")) {printf ("%s\tsecond\n",$0)} else  {printf ("%s\tconfusing\n",$0)}}' | awk 'BEGIN{FS=OFS="\t"} {gsub("\ ", "", $8)} 1' | awk '{printf ("%s\t%d\n",$0,($3-$2)+1)}' | sort -k4,4 -k10,10n | sed 'N;N;s/\n/\t/g' | awk '{if ($5==$15) {print $0}  else if (($5=="1" && $15=="2" && $25=="1") || ($5=="2" && $15=="1" && $25=="2")) {printf ("%s\t%d\t%d\t%s\t%d\t%d\t%s\t%s\t%s\t%d\t%s\t%d\t%d\t%s\t%d\t%d\t%s\t%s\t%s\t%d\t%s\t%d\t%d\t%s\t%d\t%d\t%s\t%s\t%s\t%d\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20)} else if (($5=="1" && $15=="2" && $25=="2") || ($5=="2" && $15=="1" && $25=="1")) {printf ("%s\t%d\t%d\t%s\t%d\t%d\t%s\t%s\t%s\t%d\t%s\t%d\t%d\t%s\t%d\t%d\t%s\t%s\t%s\t%d\t%s\t%d\t%d\t%s\t%d\t%d\t%s\t%s\t%s\t%d\n", $11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10)} }' > $6-$7\.concordant_freq3.2SPLIT-1M.inoneline.txt

#Step 11: Unique number of microDNA with number of split reads
awk '$1==$11 && $1==$21 && $7==$17 && length($8)<=12 && length($18)<=12 && length($28)<=12'  $6-$7\.concordant_freq3.2SPLIT-1M.inoneline.txt | awk '($7=="+" && $27=="-") || ($7=="-" && $27=="+")' | awk '{if ($17=="+" && $19=="second" && $12<$2 && $22>=$12 && $23<=$3) {printf ("%s\t%d\t%d\n",$1,$12,$3)} else if ($7=="+" && $9=="second" && $2<$12 && $22>=$2 && $23<=$13) {printf ("%s\t%d\t%d\n",$1,$2,$13)} else if ($17=="-" && $19=="second" && $12<$2 && $22>=$12 && $23<=$3) {printf ("%s\t%d\t%d\n",$1,$12,$3)} else if ($7=="-" && $9=="second" && $2<$12 && $22>=$2 && $23<=$13) {printf ("%s\t%d\t%d\n",$1,$2,$13)} }' | sort | uniq -c | awk '{printf ("%s\t%d\t%d\t%d\n",$2,$3,$4,$1)}' > $6-$7\.microDNA-JT.txt

rm *hg38.sam *hg38.bam
