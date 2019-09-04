//Author Pankaj Kumar; Biochemistry & Molecular Genetics; University of Virginia (pankjrf@gmail.com; pk7zuva@gmail.com; pk7z@eservices.virginia.edu)
////Usage:<JUNCTIONAL.TAG> <file that has island coordinate and its sequence in each line> > <junction.fa>
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<ctype.h>
main(int argc,char *argv[])
{
        FILE *input1;
        int i, j, cc, dd, SeqLenth;
	char sequence[50000],QBUF[60000],coordinate[50],coordinate1[50],sequence1[21],sequence2[21],sequence3[41];
        if((input1=fopen(argv[1],"r"))!=NULL && argc==2)
	{
		while(fgets(QBUF,60000,input1)){
			if (strlen(QBUF)>1){
                		sscanf(QBUF,"%s%s",coordinate,sequence);
				SeqLenth=strlen(sequence);
				for (i = 0; i<=(SeqLenth-60); i++){
					for (j=SeqLenth; j>=(i+60); j--){
						cc=i+20; dd=j-20;
						strncpy ( sequence1, sequence + i, 20 );
						sequence1[20]='\0';
						strncpy ( sequence2, sequence + dd, 20 );
						sequence2[20]='\0';
						printf (">%s-%d-%d-%d-%d\n%s%s\n",coordinate,i+1,i+20,dd+1,j,sequence2,sequence1);
					}
				}
			}
		}
	}
        else {
                printf ("ERROR!!!!!!!!!!\n");
                printf ("Usage:<JUNCTIONAL.TAG> <file that has island coordinate and its sequence in each line> > <junction.fa>\n");
        }
}
