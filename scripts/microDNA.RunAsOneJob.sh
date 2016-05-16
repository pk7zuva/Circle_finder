#This script identify the putative circular DNA co-ordinates based on junctional sequence mapping on Unmapped tags
#Author Pankaj Kumar
#Email: pankjrf@gmail.com
#This script verify the circle identified by split read method and report the circle co-ordinates and the number of junctional tag identified in forward and reverse strand.
#Argument 1 is the fasta file of island "chr:start-end seq"
#fastaFromBed -fi /data/reference/genome/celegans_ce10_ws220_Oct2010_ucsc/chrI-V-X-M.fa -bed Cele_Sample_Z245.bed -tab -fo Cele_Sample_Z245.fasta
#Since FastaFromBed print after the given starting base "ONE" need to CORRECT co-ordinate -1 (only start). 
#Argument 2 bam file name which is a sorted bam file. $2 file name "Z247_NoIndex_L006_R1R2_002.out.sorted.bam"
#DateModified:15June,2012. This is bug free.
rm junction.microDNA
echo "awk '\$1~/chr/ {printf (\"%s\\t%d\\t%d\\n\",\$1,\$2-10,\$3+10)}' $1 | sort -nk2 > Island.bed" > FFF
sh ./FFF
fastaFromBed -fi $2 -bed Island.bed -tab -fo Island.fa
exec<"Island.fa"
while read line 
        do
        Island=`echo $line | awk '{print \$1}'`
        echo $line > TeMp1
/home/pk7z/bin/samtools-1.3/samtools view -@ 20 -f 4 -F264 $3 $Island | awk '{printf (">%s-%s-%d\n%s\n",$1,$3,$4,$10)}' > 1.NM.fasta
/home/pk7z/bin/novocraft/novoindex -t 20 1.NM.ndx 1.NM.fasta
/home/pk7z/bin/GENERATE.FASTA TeMp1 > junction.fa
/home/pk7z/bin/novocraft/novoalign -c 20 -o SAM -r All -t 0 -d 1.NM.ndx -F FA -f junction.fa > junction.sam
awk '$6=="30M"' junction.sam | awk '{printf ("%s\t%s\t%s\t%s\n",$1,$3,$6,$10)}' >> junction.microDNA
done
time /home/pk7z/bin/microDNA.InOne.sh -a TotalTime
