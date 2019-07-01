#!/bin/sh
sed -i 's/\r$//g' paths.txt # to convert is to unix format
sed -i  '/^[[:alpha:]\/]/!d' paths.txt        #paths.txt should have directory addresses starting with an alphabet only
readarray paths < paths.txt
echo "enter the passphrase .It will will be used for decryption of all files"
read -s phrase
for p in "${paths[@]}"
do
cd $p && pwd
echo enter the file names you want to decrypt.Press Ctrl+D when done.
readarray names
for name in ${names[@]}
do
if [[ $name == *"tar.gz"* ]]; 
then
	name=${name//.tar.gz.gpg/}
	gpg -o $name.tar.gz --batch --passphrase $phrase -d $name.tar.gz.gpg
	tar xzf $name.tar.gz
	rm $name.tar.gz
    
else
	name1=$name
	name1=${name1//.gpg/}
	gpg -o $name1 --batch --passphrase $phrase  -d $name

fi

 
done


done
