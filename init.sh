#! /bin/bash

# File : init.sh
# Author : Michael Marinetti
# Description : Traitement des arguments du script
VERSION_INIT=0.1
# Creation : 2010/04/01
# Last Mod : 2010/04/01
verbose_mode="Off"
show_error="off"
if(test $# -gt 0 ) then 
	for i in $(seq 1 "$#"); do
		if (test "${!i}" = "-v")  then
			verbose_mode="On"
			echo "verbose ok"
		fi
		if (test "${!i}" = "--show-error")  then
			show_error="On"
		fi
		if (test "${!i}" = "--display-errorfile")  then
			display_errorfile="On"
		fi
		if (test "${!i}" = "--help" -o "${!i}" = "?" -o "${!i}" = "-h")  then
			echo "POUET"
			marinetti_help
		fi
	done
fi

#### Declaration des messages d'erreurs
declare -a CDERR
CDERR[1]="Could not connect to remote host."
CDERR[2]="Could not connect to remote host - timed out."
CDERR[3]="Transfer failed."
CDERR[4]="Transfer failed - timed out."
CDERR[5]="Directory change failed."
CDERR[6]="Directory change failed - timed out."
CDERR[7]="Malformed URL."
CDERR[8]="Usage error."
CDERR[9]="Error in login configuration file."
CDERR[10]="Library initialization failed."
CDERR[11]="Session initialization failed."
CDERR[12]="Can't create file \"%s\"."
CDERR[142]="connection timeout."
errorfile="$TEMPPATH"error.log;



INFOS="#################
# Script #
#################
Nom du script :           $SCRIPT_NAME
Version:                  $SCRIPT_VERSION
Version de init :         $VERSION_INIT
Version de tools :        $VERSION_LIB
Debut :                   $DATE"


###################################
# HOW TO MAKE THIS IN A FUNCTION !?!
for i in $@;
do 
	if((test $i = '-h') || (test $i == '--help')) then
		SHOW_HELP=1; 
		exit 0
	fi
done
###################################

###################################
# HOW TO MAKE THIS IN A FUNCTION !?!
for i in $@;
do 
	if((test $i = '-v') || (test $i == '--verbose')) then
		verbose_mode=On
		echo "mode verbose activé"
	fi
done
###################################
