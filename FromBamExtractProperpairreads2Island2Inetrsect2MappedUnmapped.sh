#This program is to generate microDNA island from the sorted bam file
#Arg1 is sorted bam file
#Arg2 is the length of longest chromosome in given species. For example it is for human genome "195471971"
#Arg3 is length of read
#Arg4 is Mapped-Unmapped pairs: "$3.hg38_NM" in the Master script
#Arg5 is distance between two sequenced bases in genome to be considered as part of same island
#Arg6 is the number of processor
#Arg7 is longest circular DNA (Putting is threshold would drastically decrease computation time)
#Arg8 Path of script directory
#Usage: Program-Name Bam-file Length-of-longest-chromososme length-of-read Merge-Island-distance (separation between two sequenced bases to be considered part of one island)
#Collecting only well annotated chromosome
ulimit -s unlimited
samtools view -H  $1 | awk '{print $2}' | sed -e s/:/\ /g | awk '$2~/chr/ && length($2)<=5 {print $2}' | while read i
        do
	#Arg1 is sorted bam file
	#Arg7 is longest circular DNA (Putting is threshold would drastically decrease computation time)
	#I consider those pair end reads that are mapped as far as longest circular DNA expected. 
	echo "samtools view  -@ $6 -f 1 $1 $i | awk '\$6!=\"*\" && \$7==\"=\" && (\$8-\$4)<$7 && (\$8-\$4)>0 && \$9>0 {printf (\"%s\t%d\t%d\n\",\$3,\$4,\$8)}'"  > Foo.sh
	sh Foo.sh > TeMp_Address_PE

	#Below step is to add the those paired end reads where only one end was mapped
	samtools view  -@ $6 -f 4 -F264 $1 $i | awk '$4>0 && $4==$8 && $6=="*"' | awk ' {printf("%s\t%d\t%d\n",$3,$4,$8)}' >> TeMp_Address_PE

	#Arg2 is the length of longest chromosome in human
	#Arg3 is length of read
	#At this step program generates chromosome specific profile based on mapped reads. ADDRESS2PROFILEPAIREND is a "C" executable. The C source code is "address2profile.pairend.c".
	$8/ADDRESS2PROFILEPAIREND TeMp_Address_PE $2 $3 > TeMp_Profile_PE


	#Arg5 is distance between two sequenced bases in genome to be considered as part of same island
	#The islands are merged if they are less that 50 bp apart and finally islands are reported with coverage (Total bases sequenced). MIDNA_START_END_SCORE is a "C" executable. The C source code is "midna_start_end_score.c". 
	$8/MIDNA_START_END_SCORE TeMp_Profile_PE $i $5 | awk '{printf ("%s\t%d\t%d\t%.1f\n",$1,$2,$3,$4/(($3-$2)+1))}'
done

#Collecting only those islands that has coverage more than 2X. 
awk '$4>2 {printf ("%s\t%d\t%d\n",$1,$2,$3)}' Island_PE > Island_PE.bed


#Arg4 is Mapped-Unmapped pairs: "$3.hg38_NM" in the Master script
#Finally island that have atleast one mapped-unmapped pairs (filename = Island.Mapped-Unmapped_file.Intersect_PE.bed) are consider for further analysis 
readlength=`echo $3 | awk '{print $1}'`
echo "sed -e s/_chr/\ chr/g $4 | awk '\$0!~/random/ {print \$2}' | sed -e s/_/\ /g | awk '{printf (\"%s\\t%d\\t%d\\n\",\$1,\$2,\$2+$readlength)}'" > Foo
sh ./Foo > TeMp_Mapped-Unmapped_file_PE

#Collecting Island that has at least two Mapped-Unmapped pair. Also limiting length of Island to user specified longest circle.
echo "bedtools intersect -a Island_PE.bed -b TeMp_Mapped-Unmapped_file_PE -c | awk '(\$3-\$2)<$7'" > Foo.sh
sh Foo.sh > Island.Mapped-Unmapped_file_PE.bed
awk '$4>=2 {printf ("%s\t%d\t%d\n",$1,$2,$3)}' Island.Mapped-Unmapped_file_PE.bed > Island.Mapped-Unmapped_file.Intersect_PE.bed
rm TeMp_Profile_PE
rm TeMp_Address_PE
