//Author Pankaj Kumar; Biochemistry & Molecular Genetics; University of Virginia (pankjrf@gmail.com; pk7zuva@gmail.com; pk7z@eservices.virginia.edu)
//Usage:<DIRECT.REPEAT.FINDER> <microDNA.JT.premotif.fa> > <microDNA.JT.postmotif.fa>
// head -1 microDNA.JT.premotif.fa 
// 1 (junctional tag)	chr1 631147 631295 AGCTGGAGTCCTAGGCACAGCTCTAAGCCTCCTTATTCGAGCCGAACTGGGCCAGCCAGGCAACCTTCTAGGTAACGACCACATCTACAACGTTATCGTCACAGCCCATGCATTTGTAATAATCTTCTTCATAGTAATACCCATCATA 
//Usage: <DIRECT.REPEAT.FINDER> <file that has information about number of junctional tags, microDNA co-ordinate and it's sequence (see above)> <microDNA.JT.postmotif.fa>
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<ctype.h>
main(int argc,char *argv[])
{
        FILE *input1;
        int h, y, z, SeqLenth, LeftShift, StartNew, EndNew, StartOld, START, END, StopLength, JTag;
	char sequence[50000],QBUF[60000],coordinate[50],coordinate1[50],sequence1[16],sequence2[16],sequence3[16],CHROM1[10],Uppercase[50000];
        if((input1=fopen(argv[1],"r"))!=NULL && argc==2){
		while(fgets(QBUF,60000,input1)){
			if (strlen(QBUF)>1){
                		sscanf(QBUF,"%d%s%d%d%s",&JTag,&CHROM1,&START,&END,sequence);
				SeqLenth=strlen(sequence); StopLength=SeqLenth-500;
			}
				for ( y = 1; y <= 15; y++){
					//Initializing to null
					for (h=0; h<=15; h++){
						sequence1[h]='\0';
						sequence2[h]='\0';
						sequence3[h]='\0';
					}
					strncpy ( sequence1, sequence + 0, y );
					sequence1[15]='\0';
					strncpy ( sequence2, sequence + SeqLenth-15, y );
					sequence2[15]='\0';
					if(strcmp(sequence1, sequence2)){
						if (y<2){
							printf ("%s\t%d\t%d\t%d\tNOMOTIF\n",CHROM1,START+1,END-15,JTag);break;
						}
						else if (y>=2 && y<=15){
					strncpy ( sequence3, sequence + 0, y-1 );
							sequence3[15]='\0';
						printf ("%s\t%d\t%d\t%d\t%s\n",CHROM1,START+1,END-15,JTag,sequence3);break;
						}
					}
					else if (y>=15){
					strncpy ( sequence3, sequence + 0, y-1 );
                                                        sequence3[15]='\0';
                                                printf ("%s\t%d\t%d\t%d\t%s\n",CHROM1,START+1,END-15,JTag,sequence3);
                                        }
				}
			}
		}
	else {
        	printf ("ERROR!!!!!!!!!!\n");
		printf ("<DIRECT.REPEAT.FINDER> <file that has information about number of junctional tags, microDNA co-ordinate and it's sequence (1 (junctional tag)   chr1 631147 631295 AGCTG...CATCATA)> <microDNA.JT.postmotif.fa>\n");
	}
}
