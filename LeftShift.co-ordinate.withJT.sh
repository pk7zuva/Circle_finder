#This script identify putative circular DNA and the number of junctional reads mapping on reads in F and R orientation
#Arg1 is whole genome file 
#Arg2 is length of longest circle requested
#Arg3 Path of script directory
ulimit -s unlimited
#Removing the below file if it exit because at the end of this script output is being appended in this file
rm microDNA.JT.postalign.TeMp1.bed
#This script left align a given co-ordinates
#The first file should be genome co-ordinate which need to be left aligned
#Collecting probable microDNA and number of junction tags
echo "awk 'NF==4 && \$2~/plus/ && \$4==\"+\" && !x[\$2]++ {print \$1}' junction.microDNA | sed -e s/:/\ /g | sed -e s/-/\ /g | awk 'NF==7 && length(\$1)<=5 {printf (\"%s %d %d\n\",\$1,\$2+\$4,\$2+\$7)}' | sort | uniq -c | awk '{printf (\"%s\t%d\t%d\t%d\n\",\$2,\$3,\$4,\$1)}' | sort -k1,1 -k2,2n | awk '\$2>1000 && \$2<195471971 && \$3<195471971 && \$3>\$2 && (\$3-\$2)<=$2' | grep ^chr" > Foo.sh
sh Foo.sh > microDNA.JT.prealign.bed
#awk '{print $1}' junction.microDNA | sed -e s/:/\ /g | sed -e s/-/\ /g | awk '{printf ("%s %d %d\n",$1,$2+$4,$2+$7)}' | sort | uniq -c | awk '{printf ("%s\t%d\t%d\t%d\n",$2,$3,$4,$1)}' | sort -k1,1 -k2,2n | awk '$2>1000' > microDNA.JT.prealign.bed
#Extracting predicted microDNA sequence and 500 bp upstream sequence
awk '{printf ("%s\t%d\t%d\n",$1,$2-501,$3)}' microDNA.JT.prealign.bed > microDNA.prealign.up501.bed
#bedtools getfasta -fi /hdata1/MICRODNA-HG38/hg38.fa -bed microDNA.prealign.up501.bed -tab -fo microDNA.prealign.up501.fa
bedtools getfasta -fi $1 -bed microDNA.prealign.up501.bed -tab -fo microDNA.prealign.up501.fa
awk '$2=toupper($2)' microDNA.prealign.up501.fa | sed -e s/:/\ /g | sed -e s/-/\ /g | sort -k1,1 -k2,2n > TeMp.prealign.fa
#Junctional tags
awk '{print $4}' microDNA.JT.prealign.bed > JT_Number
#making input file for left alignment
paste JT_Number TeMp.prealign.fa > microDNA.JT.prealign.fa
#Left aliging a given island co-ordinate and sequence
$3/LEFT.ALIGNMENT microDNA.JT.prealign.fa > TeMp-b
#Identifying unique microDNA and number of junctional tags
#awk '{a[$1" "$4" "$5]+=$6}END{for (i in a){print i,a[i]}}' TeMp-b | sort -k1,1 -k2,2n | awk '$2>100 {printf ("%s\t%d\t%d\t%d\n",$1,$2,$3,$4)}'> microDNA.JT.postalign.bed
awk '{a[$1" "$4" "$5]+=$6}END{for (i in a){print i,a[i]}}' TeMp-b | sort -k1,1 -k2,2n | awk '$2>100 {printf ("%s-%d-%d\t%d\n",$1,$2,$3,$4)}'> microDNA.JT.postalign.plus.bed

#This script left align a given co-ordinates
#The first file should be genome co-ordinate which need to be left aligned
#Collecting probable microDNA and number of junction tags
echo "awk 'NF==4 && \$2~/minus/ && \$4==\"-\" && !x[\$2]++ {print \$1}' junction.microDNA | sed -e s/:/\ /g | sed -e s/-/\ /g | awk 'NF==7 && length(\$1)<=5 {printf (\"%s %d %d\n\",\$1,\$2+\$4,\$2+\$7)}' | sort | uniq -c | awk '{printf (\"%s\t%d\t%d\t%d\n\",\$2,\$3,\$4,\$1)}' | sort -k1,1 -k2,2n | awk '\$2>1000 && \$2<195471971 && \$3<195471971 && \$3>\$2 && (\$3-\$2)<=$2' | grep ^chr" > Foo.sh
sh Foo.sh > microDNA.JT.prealign.bed
#awk '{print $1}' junction.microDNA | sed -e s/:/\ /g | sed -e s/-/\ /g | awk '{printf ("%s %d %d\n",$1,$2+$4,$2+$7)}' | sort | uniq -c | awk '{printf ("%s\t%d\t%d\t%d\n",$2,$3,$4,$1)}' | sort -k1,1 -k2,2n | awk '$2>1000' > microDNA.JT.prealign.bed
#Extracting predicted microDNA sequence and 500 bp upstream sequence
awk '{printf ("%s\t%d\t%d\n",$1,$2-501,$3)}' microDNA.JT.prealign.bed > microDNA.prealign.up501.bed
#bedtools getfasta -fi /hdata1/MICRODNA-HG38/hg38.fa -bed microDNA.prealign.up501.bed -tab -fo microDNA.prealign.up501.fa
bedtools getfasta -fi $1 -bed microDNA.prealign.up501.bed -tab -fo microDNA.prealign.up501.fa
awk '$2=toupper($2)' microDNA.prealign.up501.fa | sed -e s/:/\ /g | sed -e s/-/\ /g | sort -k1,1 -k2,2n > TeMp.prealign.fa
#Junctional tags
awk '{print $4}' microDNA.JT.prealign.bed > JT_Number
#making input file for left alignment
paste JT_Number TeMp.prealign.fa > microDNA.JT.prealign.fa
#Left aliging a given island co-ordinate and sequence
$3/LEFT.ALIGNMENT microDNA.JT.prealign.fa > TeMp-b
#Identifying unique microDNA and number of junctional tags
#awk '{a[$1" "$4" "$5]+=$6}END{for (i in a){print i,a[i]}}' TeMp-b | sort -k1,1 -k2,2n | awk '$2>100 {printf ("%s\t%d\t%d\t%d\n",$1,$2,$3,$4)}'> microDNA.JT.postalign.bed
awk '{a[$1" "$4" "$5]+=$6}END{for (i in a){print i,a[i]}}' TeMp-b | sort -k1,1 -k2,2n | awk '$2>100 {printf ("%s-%d-%d\t%d\n",$1,$2,$3,$4)}'> microDNA.JT.postalign.minus.bed

cat microDNA.JT.postalign.plus.bed microDNA.JT.postalign.minus.bed | awk '{printf ("%s\n",$1)}'  | sort -u > microDNA.JT.postalign.TeMp.bed

#This script would run faster if the below script is separate script.
#The below script need to fix every where
exec<"microDNA.JT.postalign.TeMp.bed"
	while read line
	do
	COUNTPLUS=`grep -w $line microDNA.JT.postalign.plus.bed | awk '{for (i=1; i<=$2; i=i+1) {print $0}}' | wc -l` 
	COUNTMINUS=`grep -w $line microDNA.JT.postalign.minus.bed | awk '{for (i=1; i<=$2; i=i+1) {print $0}}' | wc -l`
echo "$line $COUNTPLUS $COUNTMINUS" >> microDNA.JT.postalign.TeMp1.bed
done

cat microDNA.JT.postalign.TeMp1.bed | sed -e s/-/\ /g | awk '{printf ("%s\t%d\t%d\t%d\t%d\n",$1,$2,$3,$4,$5)}' > microDNA.JT.postalign.bed

