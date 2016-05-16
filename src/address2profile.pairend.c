#include<stdio.h>
#include<string.h>
#include<stdlib.h>
main(int argc,char *argv[])
{
char RBUF[200],filename[200],address[200],seq1[200],seq2[200],strand1,strand2,chr1[200],chr2[200];
long size_chr=0,start1=0,end1=0,start2=0,Temp=0,i=0,read_len=0,profile[248956422];
FILE *fp;
if(argc==4)
{
        strcpy(filename,argv[1]);
	size_chr=atoi(argv[2]);
        read_len=atoi(argv[3]);
}
else {
        printf("ERROR!!!!!!!!!!\n");
//Usage: a.out mapped_file_in_this_format(chr1 49675415 49675815) chrmosome_length read_length
//a.out sample_file 249250621 36
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
