# UPD_plotter
Script to display Uniparental Disomies (UPD) on ideograms, based on trio exome/genome vcf


## Requirements
bcftools to manage variants : https://github.com/samtools/bcftools<br>
tagore to plot ideograms : https://github.com/jordanlab/tagore
 
## Usage <br>
./script_upd.txt $vcf $trio $output_prefix<br>
where :<br>
-$vcf is a sorted indexed multi sample vcf (order of samples do not matter, can have more than three samples)<br>
-$trio is a string indicating sample IDs as they appear in the vcf : child_ID,mother_ID,father_ID<br>
 
## Results<br>
outputs ideograms as PNG and SVG files, where informative variants are colored:<br>
-biparental contribution in green (displayed on the left chromatid)<br>
-maternal uniparental contribution in pink (displayed on the right chromatid)<br>
-paternal uniparental contribution in blue (displayed on the right chromatid)<br>
 
<br>
Example on trio exome (first) and trio genome (second):<br><br>

![Exome](https://i.ibb.co/cJ9SgMQ/WES-example.png)<br>
![genome](https://i.ibb.co/ZSqrgMk/WGS-example.png)<br>


