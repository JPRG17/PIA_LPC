#!/bin/bash
clear
echo "-------------------"
echo "Selecciona una opcion"
echo "1 Detectar equipos"
echo "2 Esacneo de Puertos"
echo "3 Mostrar info"
echo "4 Salir"
echo "--------------------"

opc=0
until [ $opc -eq 4 ]
do
	case $opc in

		1) echo "---------------------"
			which ifconfig && { echo "Comando ifconfig existe...";
			                          direccion_ip=`ifconfig  |grep inet |grep -v "127.0.0.1" |awk '{ print $2}'`;
						  echo "Esta es tu direccion ip: "$direccion_ip;
						  subred=`ifconfig |grep inet |grep -v "127.0.0.1" |awk '{ print $2}'|awk -F. '{print $1"."$2"."$3"."}'`;
						  echo "Esta es tu subred: "$subred;
					  }\
				        ||{ echo "No existe el comando ifconfig...usando ip ";
					          direccion_ip=`ip addr show |grep inet | grep -v "127.0.0.1" |awk '{ print $2}'`;
						  echo "Esta es tu direccion ip: "$direccion_ip;
						  subred=`ip addr show |grep inet | grep -v "127.0.0.1" |awk '{ print $@}'|awk -F. '{print $1"."$2"."$3"."}'`;
					  }
		          for ip in {1..245}
		          do
				  ping -q -c 4 ${subred}${ip} > /dev/null
				  if [ $? -eq 0 ]
			          then
					  echo "Host responde : "${subred}${ip}
			          fi
		          done
		 ;;



	 2) echo "------------------------"
		 direccion_ip=$1
		 puertos="20,21,22,23,25,50,51,53,80,110,119,135,136,137,138,139,143,161,162,389,443,445,636,1025,1443,3389,5985,5986,8080,10000"

		 [ $# -eq 0 ] && { echo "Modo de uso: $0 <direccion ip>"; exit 1; }
		 IFS=,
		 for port in $puertos
	         do
			 #echo $port
			 timeout 1 bash -c "echo > /dev/tcp/$direccion_ip/$port > /dev/null 2>&!" &&\
		          echo $direccion_ip":"$port" is open"\
			  ||\
			  echo $direccion_ip":"$port" is closed";
	         done
	;;

	  3) echo "------------------------"
		  if type -t wevtutil &> /dev/null
	          then
			  OS=MSWin
		  elif type -t scutil &> /dev/null
		  then
			  OS=macOS
		  else
			  OS-Linux
		  fi
		  echo $OS

		  ;;


            4) break
		    ;;

	     *) echo "opcion invalida."
		     ;;

     esac
     read opc
 done

		  




