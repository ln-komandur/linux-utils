#!/bin/bash

# Download the video using yt-dlp https://vimeo.com/1111111111

if [ $# -le 1 ]
then
    echo "Usage: Extract_parts_of_video_and_combine_them <Name of video file> <Name of prefix>"
    echo "Argument 1: <Name of the video file> from which to extract parts and combine"
    echo "Argument 2: <Name of prefix> to prepend the output video with"
    echo "Example: "
    echo "Extract_parts_of_video_and_combine_them all_performances.mp4 Singing_in_"
    echo "Exiting"
    exit 1
fi
part_number=0 # Start with 0 as there are no parts to assemble yet
> $2_list_of_video_parts_to_concat.txt # Create an empty file to list the file names of all parts

echo "------------------------------------------------------------"
echo
echo "To extract part "$part_number" of the video from" $1 ", enter Start time and Duration as hh:mm:ss hh:mm:ss"

while true; do
	part_number=$((part_number+1)) # Increment the part number
	while
		echo "Example: To start at 2 minutes and to last 14.5 seconds, enter"
		echo "00:02:00 00:00:14.5"
		read -p ">" start_time duration # Get the user input
	  	[[ -z $start_time || $start_time == *[^0-9:.]* || -z $duration || $duration == *[^0-9:.]* ]] # Prompt again if an empty string or containing anything other than "0-9 or : or ."
	do echo "Please enter a valid start time and duration in hh:mm:ss hh:mm:ss"; done

	ext="${1##*.}" # The single # operator is used to try and remove the shortest text matching the pattern, while ## tries to do it with the longest text matching from the beginning of the string.
	filename="${1%.*}" # The % operator is used in the pattern ${variable%substring} returns content of the variable with the shortest occurrence of substring deleted from the back of the variable.

	part_file_name="$2_${filename}_Part_$part_number.${ext}" # Name of the file to save the part as

	echo "------------------------------------------------------------"
	echo
	echo "Extracting" $part_number "from" $start_time "for Duration" $duration "to save in" $part_file_name
	echo file \'$part_file_name\' >> $2_list_of_video_parts_to_concat.txt # Put the part file name in the list of parts.
	echo
	echo "------------------------------------------------------------"
	ffmpeg -ss $start_time -i "$1" -to $duration -c:v copy -c:a copy "$part_file_name" # Extract part of the video from the start time up to the duration

	echo "------------------------------------------------------------"
	echo
	read -p "Any more parts to extract? (Y/N)" yn
    	case $yn in
    		[Yy]* ) echo "Great. Let's move on.";; #These options are needed in the case statement to exhaust all valid options. break should not be included as it will break from the loop
		[Nn]* ) echo "Combining parts now";
			ffmpeg -f concat -safe 0 -i $2_list_of_video_parts_to_concat.txt -c copy "$2_$1"; #Concatenate all video parts. Use -safe 0 to accommodate white space in file names
		        break;; # Break from the loop
		* ) echo "Please answer Y or N.";;
	esac
done
