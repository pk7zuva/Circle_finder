#This program is to generate microDNA island from the sorted bam file
#Usage: Program-Name Bam-file Length-of-longest-chromososme length-of-read Merge-Island-length(separation between two sequenced bases to be considered part of one island)
ulimit -s unlimited 
#This loop is specific to human genome
for i in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY
        do
#Arg1 is sorted bam file
#I am going to consider those pair end reads too that are mapped 10kb apart
/home/pk7z/bin/samtools-1.3/samtools view -@ 20 -f 1 $1 $i | awk '$3~/chr/ && $6!="*" && $7=="=" && ($8-$4)<10000 && ($8-$4)>0 && $9>0 {printf ("%s\t%d\t%d\n",$3,$4,$8)}'  > TeMp_Address_PE
#Arg2 is the length of longest chromosome in human
#Arg5 is length of read
        ADDRESS2PROFILEPAIREND TeMp_Address_PE $2 $5 > TeMp_Profile_PE
#Arg3 is distance between two sequenced bases in genome to be considered as part of same island
        MIDNA_START_END_SCORE TeMp_Profile_PE $i $3 | awk '{printf ("%s\t%d\t%d\t%.1f\n",$1,$2,$3,$4/(($3-$2)+1))}'
done

awk '{if ($4>1.5) {printf ("%s\t%d\t%d\n",$1,$2,$3)} else if ($4>1.0 && ($3-$2)>100 && ($3-$2)<400) {printf ("%s\t%d\t%d\n",$1,$2,$3)}}' Island_PE > Island_PE.bed

#awk '{printf ("%s\t%d\t%d\n",$1,$2,$3)}' Island_PE > Island_PE.bed

#Arg4 is Mapped-Unmapped pairs: GSC-Nakano2_S2_1_2.newindex_NM
#I am adding "74" because length of the read was 75
#Arg5 is length of read
readlength=`echo $5 | awk '{print $1}'`
echo "sed -e s/_chr/\ chr/g $4 | awk '\$0!~/random/ {print \$2}' | sed -e s/_/\ /g | awk '{printf (\"%s\\t%d\\t%d\\n\",\$1,\$2,\$2+$readlength)}'" > Foo
sh ./Foo > TeMp_Mapped-Unmapped_file_PE
bedtools intersect -a Island_PE.bed -b TeMp_Mapped-Unmapped_file_PE -c > Island.Mapped-Unmapped_file_PE.bed
awk '$4>0 {printf ("%s\t%d\t%d\n",$1,$2,$3)}' Island.Mapped-Unmapped_file_PE.bed > Island.Mapped-Unmapped_file.Intersect_PE.bed
rm TeMp_Profile_PE
rm TeMp_Address_PE
