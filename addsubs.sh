#!/bin/bash

read -e -p "Is this a Movie or a Series? [M/s] " mediaType
mediaType=$(echo $mediaType | tr '[:upper:]' '[:lower:]')	# Forces mediaType to become lowercase

if [ $mediaType = "m" ]; then
	read -e -p "Enter the film's name: " filmName
	read -e -p "Enter the release year: " releaseYear

	mkdir "${filmName} (${releaseYear})"

	ffmpeg -i *.mp4 -i Subs/*.srt -map 0:v -map 0:a -c copy -map 1 -c:s:0 mov_text -metadata:s:s:0 language=eng output.mp4
	mv output.mp4 "${filmName} (${releaseYear})/${filmName} (${releaseYear}).mp4"
else
	read -e -p "Enter the series' name: " seriesName
	read -e -p "Enter the season number: " seasonNum

	printf -v seasonNum "%02d" $seasonNum	# Makes sure seasonNum is at least 2 digits

	mkdir "Season ${seasonNum}"

	episodeNum=0
	declare -i episodeNum

	for file in ./*RARBG.mp4;do
		episodeNum+=1
		printf -v episodeN "%02d" $episodeNum
		
		file="${file##*/}"	# Removes preceding directory; only filename remains
		fileMinusExt="${file%.*}"	# Removes extension from filename
		
		read -p "Adding subtitles to $file"
		
		ffmpeg -i $file -i Subs/$fileMinusExt/*.srt -map 0:v -map 0:a -c copy -map 1 -c:s:0 mov_text -metadata:s:s:0 language=eng output.mp4
		
		mv output.mp4 "Season ${seasonNum}/${seriesName} - s${seasonNum}e${episodeN}.mp4"
		
		#echo
		#echo ---------------------------
		#read -p "Press ENTER to continue."
	done
fi