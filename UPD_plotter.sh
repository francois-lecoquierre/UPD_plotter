#!/bin/bash

# parameter check ************************************************************************
if [ "$#" -ne 3 ]; then
    echo "3 parameters required :"
    echo "*** sorted_multi_vcf.vcf.gz" 
    echo "*** ped_file.ped with at least 4 columns : trio_name, child_ID, father_ID, mother_ID separated by tabulations, using the same IDs as in multi_vcf"
    echo "*** output_prefix"
    exit 1
fi


echo "multi_vcf : $1"
echo "ped_file : $2"
echo "output_prefix : $3"

multi_vcf=$1
ped_file=$2
output_prefix=$3


# functions
function exists_in_list() {
    LIST=$1
    DELIMITER=$2
    VALUE=$3
    echo $LIST | tr "$DELIMITER" '\n' | grep -F -q -x "$VALUE"
}


# sample extraction from VCF
samples=$(bcftools query -l $multi_vcf)



# iterate on ped file lines ***************************************************************************************************************************************************************************
while read ped_line; do
    echo "****************** Reading trio : $ped_line"

    IFS=$'\t'
    read -a strarr <<< "$ped_line"

    if ! {( exists_in_list ${strarr[1]} '\n' $samples ) && ( exists_in_list ${strarr[2]} '\n' $samples ) && ( exists_in_list ${strarr[3]} '\n' $samples )}; then

            echo "*** Error : child / mother / father not detected or not in multi-vcf"

        else

            child=${strarr[1]}
            father=${strarr[2]}
            mother=${strarr[3]}

            echo "*** Trio : ${strarr[0]}"
            echo "*** Child : $child"
            echo "*** Father : $father"
            echo "*** Mother : $mother"



        # output files *****************************************************************************

        out_file=${output_prefix}_informative_genotypes_${child}_for_tagore.bed
        temp_file=${output_prefix}_tempo.txt
        upd_plot_prefix=${output_prefix}_UPD_plot_${child}



        # output txt file preparation *************************************************************

        chromosomes=chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,X,Y

        bcftools view -s $child,$mother,$father -r $chromosomes $multi_vcf > $temp_file
        echo -e '#chr\tstart\tend\tshape\thsize\tcolor\tchr_copy' > $out_file

        type=BPC
        color=#5eed94
        chr_copy=1
        output_format='%CHROM\t%POS\t%POS\t3\t1\t'${color}'\t'${chr_copy}'\n'
        # child = 0/1, one parent 1/1 and one parent 0/0
        bcftools view -Ou -i 'FORMAT/GT[0] == "0/1" && ((FORMAT/GT[1] == "1/1" && FORMAT/GT[2] == "0/0") ||(FORMAT/GT[2] == "1/1" && FORMAT/GT[1] == "0/0"))' $temp_file|  bcftools query -f $output_format >> $out_file


        type=UA-M
        color=#ffb3e2
        chr_copy=2
        output_format='%CHROM\t%POS\t%POS\t3\t1\t'${color}'\t'${chr_copy}'\n'
        # pattern1="1/1${TAB}1/1${TAB}0/0"
        # pattern2="0/0${TAB}0/0${TAB}1/1"
        bcftools view -Ou -i '(FORMAT/GT[0] == "1/1" && FORMAT/GT[1] == "1/1" && FORMAT/GT[2] == "0/0") ||(FORMAT/GT[0] == "0/0" && FORMAT/GT[1] == "0/0" && FORMAT/GT[2] == "1/1")' $temp_file | bcftools query -f $output_format >> $out_file


        type=UI-M
        color=#ffb3e2
        chr_copy=2
        output_format='%CHROM\t%POS\t%POS\t3\t1\t'${color}'\t'${chr_copy}'\n'
        # pattern1="1/1${TAB}0/1${TAB}0/0"
        # pattern2="0/0${TAB}0/1${TAB}1/1"
        bcftools view -Ou -i '(FORMAT/GT[0] == "1/1" && FORMAT/GT[1] == "0/1" && FORMAT/GT[2] == "0/0") ||(FORMAT/GT[0] == "0/0" && FORMAT/GT[1] == "0/1" && FORMAT/GT[2] == "1/1")' $temp_file | bcftools query -f $output_format >> $out_file

        type=UA-P
        color=#99b9ff
        chr_copy=2
        output_format='%CHROM\t%POS\t%POS\t3\t1\t'${color}'\t'${chr_copy}'\n'
        output_format='%CHROM\t%POS\t%POS\t3\t1\t'${color}'\t'${chr_copy}'\n'
        # pattern1="1/1${TAB}0/0${TAB}1/1"
        # pattern2="0/0${TAB}1/1${TAB}0/0"
        bcftools view -Ou -i '(FORMAT/GT[0] == "1/1" && FORMAT/GT[1] == "0/0" && FORMAT/GT[2] == "1/1") ||(FORMAT/GT[0] == "0/0" && FORMAT/GT[1] == "1/1" && FORMAT/GT[2] == "0/0")' $temp_file | bcftools query -f $output_format >> $out_file

        type=UI-P
        color=#99b9ff
        chr_copy=2
        output_format='%CHROM\t%POS\t%POS\t3\t1\t'${color}'\t'${chr_copy}'\n'
        # pattern1="1/1${TAB}0/0${TAB}0/1"
        # pattern2="0/0${TAB}1/1${TAB}0/1"
        bcftools view -Ou -i '(FORMAT/GT[0] == "1/1" && FORMAT/GT[1] == "0/0" && FORMAT/GT[2] == "0/1") ||(FORMAT/GT[0] == "0/0" && FORMAT/GT[1] == "1/1" && FORMAT/GT[2] == "0/1")' $temp_file | bcftools query -f $output_format >> $out_file




        # down sampling if too many lines *****************************************************************************************

        nb_lines=$(wc -l < $out_file)
        if (( $nb_lines > 199000 )); then
        echo "Downsampling to 200k informative positions"
        (shuf -n 199000) <<<$(<$out_file) > $out_file
        fi

        # outputing ideogam plots ***********************************************************************************************

        echo "Launching tagore"
        tagore -i $out_file -p $upd_plot_prefix

        # white background
        convert ${upd_plot_prefix}.png -background white -alpha remove -alpha off ${upd_plot_prefix}.white.png

    fi
done <  $ped_file


