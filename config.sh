#!/bin/bash

# File : backup-conf.sh
# Author : Michaël Marinetti
# Description : Configuration file for backup.sh
# Creation : 2010/04/01
# Last Mod : 2010/04/01
VERSION_CONFIG=0.1
#
######################################################
#                    CONNECT FTP                     #
######################################################
SERVER=""	#Serveur backup d'OVH
USER=""	        #Votre nom d'utilisateur (=nom de votre serveur)
PASS=""			    			#Votre password
EMAIL=""		#Pour envoi mail si backup echoue
MAILSIOK="1"										#Mettre "1" si on veut un mail aussi si backup ok



######################################################
#                  CONNECT MYSQL                     #
######################################################
mysql_createdb_user='root'
mysql_createdb_pass='' # TODO 
mysql_host='localhost'

WORKING_PATH=`pwd`

MODE_INTERACTIVE=true
INSTALL_MISSING_PACKAGE=true
INSTALL_PMA=true

















##### Ci dessous, des trucs que j'ai utilisé avant, 
##### que je met là car ça peut servir pour la syntaxe
## Les fichiers resultats
TEMPPATH="backup/tmp/" #repertoire temporaire de home pour creation tar
KEEPLOG=1
LOGPATH="/home/backup/log/" #repertoire temporaire de home pour creation tar
SVNDEPOTPATH="/home/svn/depot/"














declare -a name	
# sous-repertoire qui sera cree dans TEMPPATH
declare -a mysql_database1 # base1 a sauvegarder
declare -a mysql_database2 # base2 a sauvegarder
declare -a mysql_database3 # base2 a sauvegarder
declare -a savesvn1 # repertoire1 a sauvegarder
declare -a savesvn2 # repertoire2 a sauvegarder
declare -a savesvn3 # repertoire3 a  sauvegarde
declare -a savedir1 # repertoire1 a sauvegarder
declare -a savedir2 # repertoire2 a sauvegarder
declare -a savedir3 # repertoire3 a  sauvegarde

name[1]="mon nom pour m'en rappeller"
mysql_database1[1]="le nom de la bdd"
savesvn1[1]="le depot svn (relatif)"
savedir1[1]="le repertoire (chemin absolu) "

nbr_sav=1

