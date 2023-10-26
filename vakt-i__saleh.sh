#!/bin/sh

#======================================
# version
version="0.0.9"
date1="2023.10.02 - 08.00"

# author / müellif
# huseyin ozdemir
# huseyinozdemir1419@gmail.com
#======================================



#======================================
# settings

# 1: linux
# 2: specific file
# 3: android
option_1="1"


if [ $option_1 -eq "1" ];then 
  file="/usr/local/share/salat_vakti/city/kutahya.csv"
fi


if [ $option_1 -eq "2" ];then 
  file="$1"
fi


if command -v termux-setup-storage > /dev/null
  then
  # change here, folder that containts files (turkce: vakit dosyalarının bulunduğu klasör)
  # folder="change_here"
  # examples

  # change here, city name in ascii
  # examples
  # city="kutahya"
  city="kutahya"
  
  file="/sdcard/1/salat_vakti/city/$city.csv"
fi
#======================================



argument_0=$0
argument_1=$1
argument_2=$2
argument_sharp=$#








#======================================
# functions

version_show() {
  echo "$version
$date1"
}



usage() {
echo "
salat_vakti.sh
  --help | -h
    show help menu

  --setup | -s [pc|termux]
    setup

  --version | -v
    show version
    
  --menu
    work in progress
  
  --file | -f [filename.csv]
    read from that file
    work in progress
"
}



show() {
  # learn todays date in type that we want
  date=$(date +%d-%m-%Y)

  # show city name
  head -n 1 $file

  # show date manually
  echo "$(date '+%H.%M.%S %A %Y.%m.%d ')"

  i=1; while [ $(($i)) -le 18 ]; do
    # it should not show second line, so add 1
    i=$(($i + 1))
    
    # günün hangi vaktini istiyorsun onu değişkene ata. i=1 iken imsak, i=7 iken yatsı gibi
    # 
    vakt=`grep -i "gece" $file | cut -d, -f$i`
    
    # bugünün tarihi ile arama yaparak istediğim vaktin zamanını öğren
    # search with todays date
    time=`grep $date $file | cut -d, -f$i`
    
    # print
    echo $time $vakt
  done
}




setup() {
case $argument_2 in
  pc)
  setup_pc
  ;;
  termux)
  setup_termux
  ;;
esac
}



# pc setup
setup_pc() {
  sudo mkdir /usr/local/bin/ -p
  sudo cp salat_vakti.sh /usr/local/bin/salat_vakti
  
  sudo mkdir /usr/local/share/salat_vakti/ -p
  sudo cp -r city /usr/local/share/salat_vakti/
}



# android termux setup
setup_termux() {
  mkdir /data/data/com.termux/files/usr/bin/

  cp $argument_0 /data/data/com.termux/files/usr/bin/vakt-i_salat.sh

  rm /data/data/com.termux/files/usr/bin/1
  ln -sf /data/data/com.termux/files/usr/bin/vakt-i_salat.sh /data/data/com.termux/files/usr/bin/1
  
  chmod +x /data/data/com.termux/files/usr/bin/vakt-i_salat.sh /data/data/com.termux/files/usr/bin/1
}



main() {

# parse command-line arguments
if [ $argument_sharp -gt 0 ]; then
	case $argument_1 in
		--help)
			usage
			;;
		-h)
		  usage
		  ;;
		--menu)
			menu
			;;
		--setup)
      setup
      ;;
		-s)
      setup
      ;;
		--version)
      version_show
      ;;
		-v)
      version_show
      ;;
		--file)
      version_show
      ;;
		-f)
      version_show
      ;;
		*)
			usage
			;;
	esac
else
  show
fi

}
#======================================


# run the program
main

