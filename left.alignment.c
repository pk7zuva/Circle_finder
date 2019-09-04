//Author Pankaj Kumar; Biochemistry & Molecular Genetics; University of Virginia (pankjrf@gmail.com; pk7zuva@gmail.com; pk7z@eservices.virginia.edu)
//Usage:<LEFT.ALIGNMENT microDNA.JT.prealign.fa > <TeMp-b>
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<ctype.h>
main(int argc,char *argv[])
{
        FILE *input1;
        int h, y, z, SeqLenth, LeftShift, StartNew, EndNew, StartOld, START, END, StopLength, JTag;
	char sequence[50000],QBUF[60000],coordinate[50],coordinate1[50],sequence1[2],sequence2[2],CHROM1[10],Uppercase[50000];
        if((input1=fopen(argv[1],"r"))!=NULL && argc==2){
		while(fgets(QBUF,60000,input1)){
			if (strlen(QBUF)>1){
                		sscanf(QBUF,"%d%s%d%d%s",&JTag,&CHROM1,&START,&END,sequence);
				SeqLenth=strlen(sequence); StopLength=SeqLenth-500;
				for ( y = SeqLenth; y > StopLength; y--  ){
					z=y-StopLength;
					for (h=0; h<=2; h++){
                                                sequence1[h]='\0';
                                                sequence2[h]='\0';
                                        }
					strncpy ( sequence1, sequence + y-1, 1 );
					sequence1[2]='\0';
					strncpy ( sequence2, sequence + z-1, 1 );
					sequence2[2]='\0';
					if(strcmp(sequence1, sequence2)){
						LeftShift=SeqLenth-y;
						StartNew=((START-LeftShift)+501);
						EndNew=(END-LeftShift);
						StartOld=(START+501);
						printf ("%s\t%d\t%d\t%d\t%d\t%d\n",CHROM1,StartOld,END,StartNew,EndNew,JTag);break;
					}
				}
			}
		}
	}
        else {
                printf ("ERROR!!!!!!!!!!\n");
                printf ("Usage:<LEFT.ALIGNMENT microDNA.JT.prealign.fa > <outfile (TeMp-b)>\n");
        }
}
