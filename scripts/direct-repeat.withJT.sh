#This script left align a given co-ordinates
#Extracting 15 bases down stream sequence for each identified microDNA
awk '{printf ("%s\t%d\t%d\n",$1,$2-1,$3+15)}' microDNA.JT.postalign.bed > microDNA.JT.postalign.up01dn15.bed
bedtools getfasta -fi hg38.fa -bed microDNA.JT.postalign.up01dn15.bed -tab -fo microDNA.JT.postalign.up01dn15.fa
awk '$2=toupper($2)' microDNA.JT.postalign.up01dn15.fa | sed -e s/:/\ /g | sed -e s/-/\ /g | sort -k1,1 -k2,2n > TeMp.premotif.fa
#Extracting junctional tags
awk '{print $4}'  microDNA.JT.postalign.bed > JT_Number
#Making input file for finding direct repeat at the microDNA junction
paste JT_Number TeMp.premotif.fa > microDNA.JT.premotif.fa
#Identify direct repat in a given microDNA co-ordinate
DIRECT.REPEAT.FINDER microDNA.JT.premotif.fa > microDNA.JT.postmotif.fa
