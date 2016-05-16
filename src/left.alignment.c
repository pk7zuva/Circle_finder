#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<ctype.h>
main(int argc,char *argv[])
{
        FILE *input1;
        int y, z, SeqLenth, LeftShift, StartNew, EndNew, StartOld, START, END, StopLength, JTag;
	char sequence[50000],QBUF[60000],coordinate[50],coordinate1[50],sequence1[2],sequence2[2],CHROM1[10],Uppercase[50000];
        if((input1=fopen(argv[1],"r"))!=NULL && argc==2){
		while(fgets(QBUF,60000,input1)){
			if (strlen(QBUF)>1){
          //      		*sequence='\0'; *coordinate='\0'; *sequence1='\0'; sequence2='\0';
                		sscanf(QBUF,"%d%s%d%d%s",&JTag,&CHROM1,&START,&END,sequence);
				SeqLenth=strlen(sequence); StopLength=SeqLenth-500;
                        		//printf ("%s %s %d %d \n%s\n",coordinate,CHROM1,START,END,sequence);
				for ( y = SeqLenth; y > StopLength; y--  ){
					z=y-StopLength;
					//sprintf(sequence3, "%s", toupper(sequence));
					//strncpy ( *sequence1, toupper(sequence);
					strncpy ( sequence1, sequence + y-1, 1 );
					sequence1[2]='\0';
					strncpy ( sequence2, sequence + z, 1 );
					sequence2[2]='\0';
//printf ("Sequence1=%s Sequence2=%s\t%d\n",sequence1,sequence2,SeqLenth);
					if(strcmp(sequence1, sequence2)){
						LeftShift=SeqLenth-y;
						StartNew=((START-LeftShift)+501);
						EndNew=(END-LeftShift);
						StartOld=(START+501);
						printf ("%s\t%d\t%d\t%d\t%d\t%d\n",CHROM1,StartOld,END,StartNew,EndNew,JTag);break;
						//printf ("%s\n",sequence);break;
					}
				}
			}
		}
	}
}
