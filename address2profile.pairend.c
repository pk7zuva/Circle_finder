//Author Pankaj Kumar; Biochemistry & Molecular Genetics; University of Virginia (pankjrf@gmail.com; pk7zuva@gmail.com; pk7z@eservices.virginia.edu)
//This program takes Mapped position as input and report the profile for each chromosome
//Usage: <ADDRESS2PROFILEPAIREND> <file that has information about chromosome and mapped position> <length of longest chromosome. e.g: chr1 in human> <length of reads> > TeMp_Profile_PE
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
main(int argc,char *argv[])
{
char RBUF[200],filename[200],address[200],seq1[200],seq2[200],strand1,strand2,chr1[200],chr2[200];
long size_chr=0,start1=0,end1=0,start2=0,Temp=0,i=0,read_len=0,profile[248956423];
FILE *fp;
if(argc==4){
        strcpy(filename,argv[1]);
	size_chr=atoi(argv[2]);
        read_len=atoi(argv[3]);
}
else {
        printf("ERROR!!!!!!!!!!\n");
printf("Usage: <ADDRESS2PROFILEPAIREND> <file that has information about chromosome and mapped position> <length of longest chromosome. e.g: chr1 in human> <length of reads> > TeMp_Profile_PE");
}
fp=fopen(filename,"r");
	for (i=0; i<=size_chr; i++)
		profile[i]=0;
while(fgets(RBUF,200,fp)){
                sscanf(RBUF,"%s %ld %ld %*[^\n]",chr1,&start1,&end1);
		for(i=start1; i<=(end1+(read_len-1)); i++){
			profile[i]++;
		}
	}	
	fclose(fp);
	for(i=1; i<size_chr; i++)
		if(profile[i]>0)
		printf("%ld\t%ld\n",i,profile[i]);
}
