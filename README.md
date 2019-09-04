For questions about the scripts or C programs in this project please contact Pankaj Kumar (pankjrf@gmail.com or pk7zuva@gmail.com or pk7z@virginia.edu)

-------------------------------------------------------------------------------------------------------
# CircularDNA_finder
A method to identify Circular DNA (Micro DNA) from pair-end high-throughput sequencing data

**Cite:** Kumar P, Dillon LW, Shibata Y, Jazaeri AA, Jones DR, Dutta A. Normal and Cancerous Tissues Release Extrachromosomal Circular DNA (eccDNA) into the Circulation. Mol. Cancer Res. Sep; 15(9): 1197-1205, 2017.

Cite: Laura W. Dillon, Kumar P, Shibata Y, Smaranda Willcox, Jack D. Griffith, Yves Pommier, Shunichi Takeda, Anindya Dutta. Production of extrachromosomal microDNAs is linked to mismatch repair pathways and transcriptional activity. Cell Reports; 11:1749-59, 2015.

**Initially this method was described in following article**

Shibata Y, Kumar P, Layer R, Willcox S, Gagan JR, Griffith JD, Dutta A. Extrachromosomal microDNAs and chromosomal microdeletions in normal tissues. Science. 2012 Apr 6;336(6077):82-6. doi: 10.1126/science.1213307. Epub 2012 Mar 8.

-------------------------------------------------------------------------------------------------------
Table of Contents
-------------------------------------------------------------------------------------------------------
        Requirement
        
        **Followings are the software requirements to run the circle identification program:**

                An aligner (novoalign (http://www.novocraft.com/products/novoalign/) or any aligner of your choice like Bowtie and run it without allowing soft clipping parameter.)
                 bowtie2 (https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.5.1/)
                bedtools (https://github.com/arq5x/bedtools2)
                samtools (http://samtools.sourceforge.net)
                parallel (https://www.gnu.org/software/parallel/)
                     bwa (https://github.com/lh3/bwa)
              samblaster (https://github.com/GregoryFaust/samblaster)
                
-------------------------------------------------------------------------------------------------------    
        
        All the above tools should be installed on the system. 
-------------------------------------------------------------------------------------------------------       


Important Note about the update:

**If your sequencing read length is >= 100 bases long then it is recommended to use the following script ** "circle_finder-pipeline-bwa-mem-samblaster.sh"

Also one need to download the whole genome and index file link provided in to "download-link-hg38-and-bowtie-index.txt" file.

#Usage: bash "Number of processors" "/path-of-whole-genome-file/hg38.fa" "fastq file 1" "fastq file 2" "minNonOverlap between two split reads" "Sample name" "genome build"

#bash /path-of-script-dirctory/microDNA-pipeline-bwa-mem-samblaster.sh 16 /path-of-script-dirctory/hg38.fa 1E_S1_L1-L4_R1_001.fastq.75bp-R1.fastq 1E_S1_L1-L4_R2_001.fastq.75bp-R2.fastq 10 1E hg38

#Arg1 = Number of processors

#Arg2 = Genome or index file "/hdata1/MICRODNA-HG38/hg38.fa"

#Arg3 = fastq file 1 "1E_S1_L1-L4_R1_001.fastq"

#Arg4 = fastq file 2 "1E_S1_L1-L4_R2_001.fastq"

#Arg5 = minNonOverlap between two split reads "10"

#Arg6 = Sample name "1E"

#Arg7 = genome build "hg38"

#####################################################################################################


Usage: bash "microDNA.InOne.sh" "firstfastqfile_R1_001.fastq" "secondfastqfile_R2_001.fastq" "samplename"  "Island.Mapped-Unmapped_file.Intersect_PE.bed"

Replace the samplename with what ever name you would like to give to your sample. At the end you get a list of circular DNA with number of junctional sequence. It also will give the information about presence of direct repeat at junction (this is one of the property seen with circular DNA).


Welcome to the Circle_finder wiki!

### This is step by step guide to run Circle_Finder. Use the below steps if your read length <100 bases

Step 1: Clone the repository
-------------------------------------------------------------------------------------------------------
git clone https://github.com/pk7zuva/Circle_finder.git

Step 2: Change to "Circle_finder" directory
-------------------------------------------------------------------------------------------------------
cd Circle_finder

In this directory you will find four types of files: 1) *.c 2) *.sh 3) *.txt and 4) C executable that has no extension

Note: Though the "C" executable files are provided it is advisable to make these executable afresh

Step 3: Type the following command on your terminal one by one
-------------------------------------------------------------------------------------------------------
cc -o ADDRESS2PROFILEPAIREND address2profile.pairend.c

cc -o DIRECT.REPEAT.FINDER1 direct.repeat.finder1.c

cc -o JUNCTIONAL.TAG junctional.tag.c

cc -o LEFT.ALIGNMENT left.alignment.c

cc -o MIDNA_START_END_SCORE midna_start_end_score.c

Step 4: Download the whole genome files and bowtie index files from link given in file "download-link-hg38-and-bowtie-index.txt"
-------------------------------------------------------------------------------------------------------
cat download-link-hg38-and-bowtie-index.txt

http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/hg38.fa http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/hg38.1.bt2 http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/hg38.2.bt2 http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/hg38.3.bt2 http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/hg38.4.bt2 http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/hg38.fa.amb http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/hg38.fa.ann http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/hg38.fa.bwt http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/hg38.fa.fai http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/hg38.fa.pac http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/hg38.fa.sa http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/hg38.rev.1.bt2 http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/hg38.rev.2.bt2

Example download command: wget http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/hg38.fa

Step 5: Download the fastq files. Link to download these files is given in file "fastq-file-download-link.txt"
-------------------------------------------------------------------------------------------------------
cat fastq-file-download-link.txt

http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/Index11_1.fq http://genome.bioch.virginia.edu/CIRCLE_FINDER_MASTER/Index11_2.fq

Step 6: You are all set to run the pipeline
-------------------------------------------------------------------------------------------------------
bash /path-of-the-"Circle_finder"-directory/microDNA.InOne.sh /path-of-the-"Circle_finder"-directory/hg38 Index11_1.fq Index11_2.fq 24 C4-2 49 10000 /path-of-the-"Circle_finder"-directory &

#Arg1 is bowtie2 index file "/hdata1/CIRCLE_ANALYSIS/MICRODNA-HG38/hg38"

#Arg2 is fastq file 1 "fastqfile1"

#Arg3 is fastq file 2 "fastqfile2"

#Arg4 is # of processor "24" Higher the number lower would be run time.

#Arg5 is Sample name  "C4-2" in this case because circular DNA was isolated from C4-2 cell lines. You want give anyname to sample 

#Arg6 Read length "49"

#Arg7 Longest circle wish to identify "10000" Higher this number more time it would take to finish the run.

#Arg8 Path of script directory

Step 7: Final output file "microDNA.JT.postmotif.fa"
-------------------------------------------------------------------------------------------------------
head microDNA.JT.postmotif.fa chr1	28761	29551	0	1	NOMOTIF

chr1	199385	199915	0	1	GTC

chr1	631932	632604	0	1	NOMOTIF

chr1	632019	632252	1	0	CA

chr1	632112	632242	0	1	T

chr1	889483	890225	4	0	C

chr1	897103	898784	2	0	C

chr1	980217	981339	0	1	G

chr1	982484	982697	1	0	NOMOTIF

chr1	983705	984358	0	2	C

Step 8: Explanation of output
-------------------------------------------------------------------------------------------------------
Column 1 "Chromosome name"

Column 2 "start position of circle"

Column 3 "end position of circle"

Column 4 "Number of reads mapping on circle junction from "+" strand"

Column 5 "Number of reads mapping on circle junction from "-" strand"

Column 6 "micro homology (if any) at the junction of circle"

Step 9: If you wish to extract only those circular DNA that has evidence of at least one read mapping on circle junction as "+" and "-" orientation
-------------------------------------------------------------------------------------------------------
awk '$4>0 && $5>0' microDNA.JT.postmotif.fa | head

chr1	1069854	1070524	1	2	C

chr1	1069934	1071919	6	2	NOMOTIF

chr1	1070501	1070786	1	2	GAGTC

chr1	1428170	1428595	5	5	NOMOTIF

chr1	1459119	1460224	6	2	NOMOTIF

chr1	1459425	1462380	3	1	GGG

chr1	1495168	1495816	1	3	GG

chr1	1579383	1580962	1	1	GTA

chr1	1667878	1668245	9	6	C

chr1	1772882	1773318	2	3	A
