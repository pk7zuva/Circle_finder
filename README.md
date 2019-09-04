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
        
        **There are three main requirements to run the circle identification program and those are as follow:**

                An aligner (novoalign (http://www.novocraft.com/products/novoalign/) or any aligner of your choice like Bowtie and run it without allowing soft clipping parameter.)
                bedtools (https://github.com/arq5x/bedtools2)
                samtools (http://samtools.sourceforge.net)
        
        The only thing need to be chnaged in the script is the path of aligner, samtools and bedtools according to your system. 
-------------------------------------------------------------------------------------------------------       
Usage: bash "microDNA.InOne.sh" "firstfastqfile_R1_001.fastq" "secondfastqfile_R2_001.fastq" "samplename"  "Island.Mapped-Unmapped_file.Intersect_PE.bed"

Replace the samplename with what ever name you would like to give to your sample. At the end you get a list of circular DNA with number of junctional sequence. It also will give the information about presence of direct repeat at junction (this is one of the property seen with circular DNA).
