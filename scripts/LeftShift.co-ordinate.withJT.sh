#This script left align a given co-ordinates
#The first file should be genome co-ordinate which need to be left aligned
#Collecting probable microDNA and number of junction tags
awk '{print $1}' junction.microDNA | sed -e s/:/\ /g | sed -e s/-/\ /g | awk '{printf ("%s %d %d\n",$1,$2+$4,$2+$7)}' | sort | uniq -c | awk '{printf ("%s\t%d\t%d\t%d\n",$2,$3,$4,$1)}' | sort -k1,1 -k2,2n > microDNA.JT.prealign.bed
#Extracting predicted microDNA sequence and 500 bp upstream sequence
awk '{printf ("%s\t%d\t%d\n",$1,$2-501,$3)}' microDNA.JT.prealign.bed > microDNA.prealign.up501.bed
bedtools getfasta -fi hg38.fa -bed microDNA.prealign.up501.bed -tab -fo microDNA.prealign.up501.fa
awk '$2=toupper($2)' microDNA.prealign.up501.fa | sed -e s/:/\ /g | sed -e s/-/\ /g | sort -k1,1 -k2,2n > TeMp.prealign.fa
#Junctional tags
awk '{print $4}' microDNA.JT.prealign.bed > JT_Number
#making input file for left alignment
paste JT_Number TeMp.prealign.fa > microDNA.JT.prealign.fa
#Left aliging a given island co-ordinate and sequence
LEFT.ALIGNMENT microDNA.JT.prealign.fa > TeMp-b
#Identifying unique microDNA and number of junctional tags
awk '{a[$1" "$4" "$5]+=$6}END{for (i in a){print i,a[i]}}' TeMp-b | sort -k1,1 -k2,2n | awk '{printf ("%s\t%d\t%d\t%d\n",$1,$2,$3,$4)}'> microDNA.JT.postalign.bed 
