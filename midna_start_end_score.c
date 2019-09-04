//Author Pankaj Kumar; Biochemistry & Molecular Genetics; University of Virginia (pankjrf@gmail.com; pk7zuva@gmail.com; pk7z@eservices.virginia.edu)
////Usage:<MIDNA_START_END_SCORE>  <file_containing_base_number_and_how_many_times_base_was_read (chromosome specific)> <chromosome name> chr_name <distance_between_consecutive_bases>
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
main(int argc,char *argv[])
{
char RBUF[200],PRESENT[200],PREVIOUS[200],filename[200],filename1[200],c,chromosome_name[50];
int dist=0,start_midna=0,end_midna=0,score=0,flag=0,flag1=0,basenum_previous=0,score_previous=0,basenum_present=0,score_present=0,z=0;
FILE *fp,*fp1;
if(argc==4){
        strcpy(filename,argv[1]);
        strcpy(filename1,argv[1]);
        strcpy(chromosome_name,argv[2]);
	dist=atoi(argv[3]);
	strcat(filename1,"_score");
}
else {
        printf("ERROR!!!!!!!!!!\n");
printf("Usase:<MIDNA_START_END_SCORE>  <file_containing_base_number_and_how_many_times_base_was_read (chromosome specific)> <chromosome name> chr_name <distance_between_consecutive_bases>\n");
        printf("This program output the putative microdna start and end and sum of the base read between the specified regions\n ");
}
fp=fopen(filename,"r");
while(fgets(RBUF,200,fp)){
		z++;
		strcpy(PREVIOUS, PRESENT);
		strcpy(PRESENT, RBUF);
                sscanf(PREVIOUS,"%d %d %*[^\n]",&basenum_previous,&score_previous);
                sscanf(RBUF,"%d %d %*[^\n]",&basenum_present,&score_present);
		score=score+score_present;
	if(((basenum_present-basenum_previous)<=dist)){
		if (flag==0 && z>1){
			start_midna=basenum_previous; flag=1; flag1=0; 
			printf("%s\t%d",chromosome_name,start_midna);
		}
	}
	else if (((basenum_present-basenum_previous)>dist)){
			if (flag1==0 && z>1){
			end_midna=basenum_previous; flag1=1; flag=0;
			printf("\t%d %d\n",end_midna,score);
			score=0;
			}
	}
}
fclose(fp);
		if (z>100)
			printf("\t%d %d\n",basenum_present,score);
}
