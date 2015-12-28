#!/bin/bash
# examples: http://linuxconfig.org/bash-scripting-tutorial

DIR1="`pwd`/proprietary/"
DIR2="/mnt/temporal"
salidaDIR1=`find $DIR1`
salidaDIR2=`find $DIR2`


for i in $salidaDIR1; do
	if [ -f $i ]; then
		lastpart=`echo ${i#$DIR1}`
		#echo lastpart vale $lastpart
		if [ -f $i ]; then
			if [ -f $DIR2/$lastpart ]; then
				file1=$(md5sum $i | awk '{print $1}')
				file2=$(md5sum $DIR2/$lastpart | awk '{print $1}')
				if [ ! $file1 = $file2 ]; then
					echo "Fichero $i es distinto (a $DIR2/$lastpart)."
				fi
			else
				echo "No existe $DIR2/$lastpart"
			fi
		fi
	fi
    
done


