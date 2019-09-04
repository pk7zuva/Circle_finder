#!/bin/sh
#Arg1 is the predicted microDNA 
#First step is to extract genomic sequence
#Arg2 is the whole genome file 
#Arg3 is the length of read
#Arg4 is number of cores
#Arg5 is sorted bam file (sample name)
rm microDNA.JT.postalign.wholeread.bed
awk 'NF==5 && $1~/chr/ && $2>0 && $3>0 && $3!~/c/ && $2!~/c/ {printf ("%s\t%s\t%d\n",$1,$2-1,$3)}' $1 > TeMp1.bed
#awk 'NF==5 && $1~/chr/ && $2>0 && $3>0 && $3!~/c/ && $2!~/c/ {printf ("%s\t%s\t%d\n",$1,$2,$3)}' $1 > TeMp1.bed
fastaFromBed -fi $2 -bed TeMp1.bed -tab -fo TeMp1.fa

exec<"TeMp1.fa"
while read line 
        do
Island=`echo $line | awk '{print \$1}'`
mkdir $Island
echo $line > $Island/TeMp2.bed
readlength=`echo $3 | awk '{print \$1}'`
string1stop=`echo $3 | awk '{print \$1-15}'`
cirdnalength=`echo $line | awk '{print length(\$2)}'`
string2start=`echo "$cirdnalength $string1stop" | awk '{print (\$1-\$2)+1}'`
echo "awk '{print substr(\$2,1,$string1stop),substr(\$2,$string2start,$string1stop)}' $Island/TeMp2.bed" > Foo.sh
#Extracting junctional sequence on which unmapped read will be mapped
#plus
sh Foo.sh | awk '{printf ("%s%s\n",$2,$1)}' | tr '[a-z]' '[A-Z]' | awk '{printf (">plus\n%s\n",$1)}' > $Island/TeMp3.fa
#minus
sh Foo.sh | awk '{printf ("%s%s\n",$2,$1)}' | tr '[a-z]' '[A-Z]' | tr '[A:T:G:C]' '[T:A:C:G]' | rev | awk '{printf (">minus\n%s\n",$1)}' > $Island/TeMp4.fa

#Extracting unmapped reads that will be used as queries and will be mapped on junctional sequence generated above 
#The below extracted unmmaped read should map on plus (TeMp3.fa) in plus orientation
#Thie below change is based on my mapping of unmapped reads on genome
samtools view -@ $4 -f 4 -F32 $5-hg38.sorted.bam $Island | awk '{printf (">minus%d\n%s\n",NR,$10)}' > $Island/TeMp4.minus.fa
#The below extracted unmmaped read should map on minus (TeMp4.fa) in plus orientation because it is being mapped on reverse complemented sequence
samtools view -@ $4 -f 36 $5-hg38.sorted.bam $Island | awk '{printf (">plus%d\n%s\n",NR,$10)}' > $Island/TeMp4.plus.fa

#Mapping plus on plus
bowtie2-build --threads $4 $Island/TeMp3.fa $Island/TeMp3
bowtie2 -x $Island/TeMp3 -f -a --end-to-end --very-fast -p $4 --score-min 'C,0,-1' -U $Island/TeMp4.plus.fa | samtools view -@ $4 -bS -o $Island/TeMp3.bam

bowtie2-build --threads $4 $Island/TeMp4.fa $Island/TeMp4
bowtie2 -x $Island/TeMp4 -f -a --end-to-end --very-fast -p $4 --score-min 'C,0,-1' -U $Island/TeMp4.minus.fa | samtools view -@ $4 -bS -o $Island/TeMp4.bam

bedtools bamtobed -cigar -i $Island/TeMp3.bam > $Island/TeMp3.bed
bedtools bamtobed -cigar -i $Island/TeMp4.bam > $Island/TeMp4.bed


echo "awk '\$0~/plus/ && \$6==\"+\" && \$7==\"$3M\"' $Island/TeMp3.bed" > $Island/Foo.sh
PLUS=`sh $Island/Foo.sh  | wc -l | awk '{print \$1}'`
echo "awk '\$0~/minus/ && \$6==\"+\" && \$7==\"$3M\"' $Island/TeMp4.bed" > $Island/Foo.sh
MINUS=`sh $Island/Foo.sh  | wc -l | awk '{print \$1}'`
echo $Island P=$PLUS M=$MINUS | sed -e s/P=/P=\ /g | sed -e s/M=/M=\ /g | sed -e s/-/\ /g | sed -e s/:/\ /g | awk '$5>0 || $7>0' | awk '{printf ("%s\t%d\t%d\t%d\t%d\n",$1,$2,$3,$5,$7)}' >> microDNA.JT.postalign.wholeread.bed





rm -rf $Island

done
#The output of this program need to be fixed beacuse start should be 1 bp plus. 
