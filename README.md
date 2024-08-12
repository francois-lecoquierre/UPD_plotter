# UPD_plotter
Script to display Uniparental Disomies (UPD) on ideograms, based on trio exome/genome vcf

 
## Requirements <br>
bcftools to manage variants : https://github.com/samtools/bcftools<br>
tagore to plot ideograms : https://github.com/jordanlab/tagore
 
## Usage <br>
./UPD_plotter.sh $vcf $ped $output_prefix<br>
where :<br>
-$vcf is a sorted indexed multi sample vcf (order of samples do not matter, can have more than three samples)<br>
-$ped is a pedigree file with at least four columns trio_name, child_ID, father_ID, mother_ID separated by tabulations, using the same IDs as in multi_vcf<br>
 
## Results<br>
outputs ideograms as PNG and SVG files, where informative variants are colored:<br>
-biparental contribution in green (displayed on the left chromatid)<br>
-maternal uniparental contribution in pink (displayed on the right chromatid)<br>
-paternal uniparental contribution in blue (displayed on the right chromatid)<br>
 
<br>
Example on trio exome (first) and trio genome (second):<br><br>

![Exome](https://github.com/francois-lecoquierre/UPD_plotter/blob/main/WES_example.png)<br>
![genome](https://github.com/francois-lecoquierre/UPD_plotter/blob/main/WGS_example.png)<br>


