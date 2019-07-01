#!/bin/sh
sed -i 's/\r$//g' paths.txt # to convert is to unix format
sed -i  '/^[[:alpha:]\/]/!d' paths.txt        #paths.txt should have directory addresses starting with an alphabet only
readarray paths < paths.txt
echo "enter the the number of AES bits key(192 or 256, for 128 simply press enter). For eg. AES256 enter 256 .It will encrypt all the folders with this passphrase"
read key
echo "enter the passphrase .It will encrypt all the folders with this passphrase"
read -s phrase
for p in "${paths[@]}"
do
cd $p && pwd
echo "enter the  names of file and folders which you want to encrypt. Press Ctrl+D to finish"
readarray  names
for name in ${names[@]}
do
if [ -d "$name" ]; 
then
    tar czf $name.tar.gz $name
	gpg --cipher-algo AES$key  --batch --passphrase $phrase -c $name.tar.gz
	rm $name.tar.gz
else
	gpg --cipher-algo AES$key  --batch --passphrase $phrase -c $name

fi

 
done
done
