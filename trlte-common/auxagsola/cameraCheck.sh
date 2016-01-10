#!/bin/bash

PROPRIETARYFILES=`grep -v "#" /Users/tucho/Desktop/alberto/development/android/CM13/android_device_samsung_trlte-common/proprietary-filesForCameraAux.txt`
#PROPRIETARYFILES=`grep -v "#" /root/android/system/device/samsung/trltexx/proprietary-files.txt | cut -d ":" -f1`
DIR1="/Users/tucho/Desktop/alberto/development/android/CM13/proprietary_vendor_samsung/trlte-common/proprietary"
DIR2="/Users/tucho/Desktop/alberto/development/android/CM13/vendor_motorola_shamu/shamu/proprietary"

#DIR2="/media/null/9e7d6fb6-c8f8-4241-b20a-09e2bbcb296d/511Blobsv1.0/system"
#DIR1="/media/null/9e7d6fb6-c8f8-4241-b20a-09e2bbcb296d/511Blobsv1.0/system/"
#DIR2="`pwd`/proprietary"

#salidaDIR1=`find $DIR1`
#salidaDIR2=`find $DIR2`

DONTCHECK="vendor/lib/egl/eglSubDriverAndroid.so
vendor/lib/egl/libEGL_adreno.so
vendor/lib/egl/libGLESv1_CM_adreno.so
vendor/lib/egl/libGLESv2_adreno.so
vendor/lib/egl/libq3dtools_adreno.so
vendor/lib/egl/libq3dtools_esx.so
vendor/lib/libC2D2.so
vendor/lib/libCB.so
vendor/lib/libRSDriver_adreno.so
vendor/lib/libadreno_utils.so
vendor/lib/libc2d30-a3xx.so
vendor/lib/libc2d30-a4xx.so
vendor/lib/libgsl.so
vendor/lib/libllvm-glnext.so
vendor/lib/libllvm-qcom.so
vendor/lib/librs_adreno.so
vendor/lib/librs_adreno_sha1.so
vendor/lib/egl/eglsubAndroid.so
vendor/lib/libc2d30.so
vendor/lib/libqcci_legacy.so"

echo "* Primero buscamos a ver si hay algún fichero que falte."
for i in $PROPRIETARYFILES; do
	if [ ! -f $DIR1/$i ]; then
		#: # no encontrado
		echo "No encontrado en DIR1 --> vale: $i - $DIR1/$i"
	else
		#echo "SI encontrado en DIR1 --> vale: $i - $DIR1/$i"
		: # Encontrado
	fi
	#echo
done
echo "* fin de búsqueda de fallos."
echo
echo
#exit




echo
echo
echo
echo "* Ahora buscamos los que estén en proprietary pero no estén en el source (DIR2, /mnt/temporal, de donde coger las cosas)"
for i in $PROPRIETARYFILES; do
	if [ ! -f $DIR2/$i ]; then
		#: # Do nothing
		echo "No encontrado en DIR2: $DIR2/$i"
	else
		:
		#echo "SI encontrado en DIR2: $DIR2/$i"
	fi
done



echo
echo
echo "* Por último comprobamos si lo que hay en DIR1 (destino) es distinto de DIR2 (origen), y dependiendo de lo que sea lo copiamos o no (si he comentado el cp) -- NOTA: TARDA UN RATO POR LOS MD5"
for i in $PROPRIETARYFILES; do
	if [ -f $DIR2/$i ]; then
		if [ -f $DIR1/$i ]; then
			salida=`echo $DONTCHECK | grep "$i"`
			if [ $? -eq 1 ]; then # PARA COMPROBAR QUE NO ESTÁ EN LA LISTA, SI SALE 1 ES QUE NO HAY COINCIDENCIA
				file1=$(shasum $DIR1/$i | awk '{print $1}')
				file2=$(shasum $DIR2/$i | awk '{print $1}')
				if [ ! $file1 = $file2 ]; then
					echo "DISTINTO: Fichero $DIR1/$i (sha $file1) es DISTINTO (a $DIR2/$i) (sha $file2)."
					# Si quiero copiar de 2 a 1
					#cp $DIR2/$i $DIR1/$i
				else
					:
					#echo "IGUAL: Fichero $DIR1/$i (sha $file1) es IGUAL (a $DIR2/$i) (sha $file2)."
				fi
			fi
		else # No se encuentra en dir1, pero sí en dir2, así que hay que copiarlo.
			:
			#cp $DIR2/$i $DIR1/$i
		fi
	fi
done

exit

	if [ -f $i ]; then
		lastpart=`echo ${i#$DIR1}`
		#echo lastpart vale $lastpart
		salida=`echo $DONTCHECK | grep "$lastpart"`
		if [ $? -eq 1 ]; then # PARA COMPROBAR QUE NO ESTÁ EN LA LISTA, SI SALE 1 ES QUE NO HAY COINCIDENCIA
			if [ -f $i ]; then
				if [ -f $DIR2/$lastpart ]; then
					file1=$(md5 $i | awk '{print $1}')
					file2=$(md5 $DIR2/$lastpart | awk '{print $1}')
					if [ ! $file1 = $file2 ]; then
						echo "Fichero $i es distinto (a $DIR2/$lastpart)."
						# Si quiero copiar de 2 a 1
						#cp $DIR2/$lastpart $DIR1$lastpart
						# Si quiero copiar de 1 a 1
						#cp $DIR1$lastpart $DIR2/$lastpart
					fi
				else
					echo "No existe $DIR2/$lastpart"
				fi
			fi
		fi
	fi

echo "FIN"



