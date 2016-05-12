#This script finds direct repeat at a given co-ordinates
#The first file should be genome co-ordinate are left aligned
#The 2nd file should be the complete genome fasta sequence

awk '{printf ("%s\t%d\t%d\n",$1,$2-1,$3+15)}' microDNA.JT.postalign.bed > microDNA.JT.postalign.up01dn15.bed
bedtools getfasta -fi /home/pk7z/bin/hg38.fa -bed microDNA.JT.postalign.up01dn15.bed -tab -fo microDNA.JT.postalign.up01dn15.fa
awk '$2=toupper($2)' microDNA.JT.postalign.up01dn15.fa | sed -e s/:/\ /g | sed -e s/-/\ /g | sort -k1,1 -k2,2n > TeMp.premotif.fa
awk '{print $4}'  microDNA.JT.postalign.bed > JT_Number
paste JT_Number TeMp.premotif.fa > microDNA.JT.premotif.fa
./a.out microDNA.JT.premotif.fa > microDNA.JT.postmotif.fa
