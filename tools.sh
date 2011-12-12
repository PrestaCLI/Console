#!/bin/bash

# File : marinetti.sh
# Author : Michaël Marinetti
# Description : Bibliothèque de fonction de bases pour simplifier les scripts et afficher les options de bases
# Creation : 2010/04/01
# Last Mod : 2011/05/04

VERSION_LIB="0.0.2"
###############################################
if(test "$DATE" = "") then 
	echo "La variable \$DATE n'a pas ete cree."
	exit 1
fi
if(test "$SCRIPT_NAME" = "") then 
	echo "Nom du script manquant."
	exit 1
fi
if(test "$SCRIPT_VERSION" = "") then 
	echo "Version du script manquant."
	exit 1
fi
###############################################

getArg (){
	thisone=0
	for i in $1;
	do
		echo "for i=$i";
		if(test $i = "$2") then
			echo "this one";
			thisone=1;
		fi
		if(test $thisone = 1) then
			return $i
		fi
		exit 1
	done
}
### verbose()
# Affiche sur la sortie standard l'argument passén parametre
verbose () {
	if(test "$verbose_mode" = "On" ) then
		printf "$1\r\n"
	fi
	return 0
}
logerror () {
	if (test "$show_error" = "On")  then
		printf "ERROR $1\r\n"
	fi
	echo "$1" >> $errorfile	
	#if(test $2 = 'exit') then
	#else 
	#fi
}

marinetti_info(){
	echo $INFOS
}

marinetti_help(){
	marinetti_info
	echo ""
	echo "Options disponibles"
	echo "--display-logfile    Afficher les logs d'erreur a la fin"
	echo "-h/ --help / ?       Afficher cette aide et quitter"
	echo "-show-error          Afficher les erreurs (ne pas utiliser le fichier errorfile)"
	echo "-v                   mode verbose"
	exit 0
}

