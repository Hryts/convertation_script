#! /bin/bash

# Init variables
in_dir=${1:-"."}"/"
digits_num=$((10#${2:-8}))
current_val=$((10#${3:-0}))
out_dir=${4:-$in_dir}"/"

# Some additional functions
validate_digits () {
	if [ $1 -lt 0 ]
	then
		>&2 echo "Not enough digits"
		rm -r $out_dir"/tmp"
		exit -1
	fi
}

rename_gifs () {
	for gif in $(ls ${out_dir}"/tmp")
	do
		validate_digits $(($digits_num-${#current_val}))
		printf -v id "%0${digits_num}d" "$current_val"
		mv $out_dir"/tmp/"$gif $out_dir$(date +"%Y-%m-%d-%H-%M-%S")-${id}.jpg
		current_val=$(($current_val+1))
	done
	rm -r $out_dir"/tmp"
}

# Whole salt
[ ! -d ${in_dir} ] && >&2 echo "${in_dir} does not exist, or is not a directory" && exit -1
mkdir -p ${out_dir}
mkdir -p ${out_dir}"/tmp"
for image in $(ls -a $in_dir | grep -E "\.(jpg|png|bmp|gif)$")
do
	validate_digits $(($digits_num-${#current_val}))
	printf -v id "%0${digits_num}d" "$current_val"
	if [ ${image: -4} == ".gif" ]
	then
		magick convert ${in_dir}${image} ${out_dir}"/tmp/"${image}.jpg
	else
		magick convert ${in_dir}${image} ${out_dir}$(date +"%Y-%m-%d-%H-%M-%S")-${id}.jpg
		current_val=$(($current_val+1))
	fi
done

rename_gifs
