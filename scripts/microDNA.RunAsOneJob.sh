#Author Pankaj Kumar
#Email: pankjrf@gmail.com
#This script generate junctional sequence on the basis of Island interval and sequence and map the junctional sequence on the unmapped reads of mapped-unmapped pairs.
#Argument 1 is the fasta file of island "chr:start-end seq"
#fastaFromBed -fi <genome-file> -bed <*.bed> -tab -fo <output.fasta>
#Argument 2 bam file name which is a sorted bam file. $2 file name "<samplename.sorted.bam>"
#Removing the <junction.microDNA> if exits
rm junction.microDNA

#Taking 10 bases up and downstream sequence and making extracting genomic sequence for each interval

echo "awk '\$1~/chr/ {printf (\"%s\\t%d\\t%d\\n\",\$1,\$2-10,\$3+10)}' $1 | sort -nk2 > Island.bed" > FFF
sh ./FFF
fastaFromBed -fi $2 -bed Island.bed -tab -fo Island.fa

exec<"Island.fa"
while read line 
        do
        Island=`echo $line | awk '{print \$1}'`
        echo $line > TeMp1

#Extraction of Mapped-Unmapped pairs in a given interval and making fasta files of all the unmapped reads
samtools-1.3/samtools view -@ 8 -f 4 -F264 $3 $Island | awk '{printf (">%s-%s-%d\n%s\n",$1,$3,$4,$10)}' > 1.NM.fasta

#Indexing the unmapped fasta sequence 
novocraft/novoindex -t 8 1.NM.ndx 1.NM.fasta

#Generating junctional sequence based on sequence of Island. "JUNCTIONAL.TAG" is a C program executable. The C source code is "junctional.tag.c". Junctional tags are 30 bases long (15+15)
JUNCTIONAL.TAG TeMp1 > junction.fa

#Mapping the junctional tags on Unmapped reads
novocraft/novoalign -o SAM -r All -t 0 -d 1.NM.ndx -F FA -f junction.fa > junction.sam

#Extracting mapped junctioanl tags with 100% identity on Unmapped tags.
awk '$6=="30M"' junction.sam | awk '{printf ("%s\t%s\t%s\t%s\n",$1,$3,$6,$10)}' >> junction.microDNA
done
