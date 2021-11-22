#Menu Escaneos....
#
#Elaborado por: JUAN PABLO RANGEL GUEVARA
#Mtricula: 2076411
#Fecha: 16/10/21
#


#declare dos funciones
#en cada funcion se encuentra el codigo correspondiente


#en esta funcion se localiza el codigo para el escaneo de puertos para un equipo o ip corrspondiente
function Escaneo-PuertosIP{
$subred = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop
         Write-Host "== Determinando tu gateway ..."
         Write-Host "Tu gateway:  $subred"

         $rango = $subred.Substring(0,$subred.IndexOf('.') + 1 + $subred.Substring($subred.IndexOf('.') + 1).IndexOf('.') + 3)
         Write-Host "== Determinando tu rango de subred..."
         echo $rango

         $punto =  $rango.EndsWith('.')
         if ( $punto -like "False" )
         {

             $rango = $rango + '.'
         }


         $portstoscan = @(20,21,22,23,25,50,51,53,80,110,119,135,136,137,138,139,143,161,162,389,443,445,636,1025,1443,3389,5985,5986,8080,10000)
         $waittime = 100

         Write-Host "Direccion ip a escanear: " -NoNewline
         $direccion = Read-Host

         foreach ( $p in $portstoscan )
         {
                 $TCPObject = new-object System.Net.Sockets.TcpClient
                 try{ 
                     $resultado = $TCPObject.ConnectAsync($direccion,$p).Wait($waittime)
                    }
                 catch{}
                 if ( $resultado -eq "True")
                 {
                     Write-Host "Puerto abierto: " -NoNewline; Write-Host $p -ForegroundColor Green
                 }
         } 

}

#en esta funcion se localiza el codigo para el escaneo de subred
function Escaneo-Subred {
 
         $subred = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop
         Write-Host "== Determinando tu gateway ..."
         Write-Host "Tu gateway:  $subred"

         $rango = $subred.Substring(0,$subred.IndexOf('.') + 1 + $subred.Substring($subred.IndexOf('.') + 1).IndexOf('.') + 3)
         Write-Host "== Determinando tu rango de subred..."
         echo $rango

         $punto =  $rango.EndsWith('.')
         if ( $punto -like "False" )
         {

             $rango = $rango + '.'
         }


          #ip 192.168.1.245
          $rango_ip = @(1..245)

          Write-Output ""
          Write-Host "__ Subred actual: "
          Write-Host "Escaneando: " -NoNewline ; Write-Host $rango -NoNewline; Write-Host "0/24" -ForegroundColor Red
          Write-Output ""
          foreach ( $r in $rango_ip)
          {
                $actual = $rango + $r 
                $responde = Test-Connection $actual -Quiet -Count 1 
                if ( $responde -eq "True" )
                {
                     Write-Output ""
                     Write-Host " Host responde: " -NoNewline; Write-Host $actual -ForegroundColor Green
                }
          }
       
}

#en esta funcion su propisto es crear el menu es decir creamos una variable con valor de entero para que al momento 
#de teclear el numero corrspondiente ejecute la funcion seleccionada, esto realizado con un switch
function get-menu{

    
[int]$respuesta = Read-Host  "`n`Elige una opción`n` ----------------`n` [1] Escaneo-Subred`n` [2] Escaneo-PuertoseIP`n` [3] Salir`n` ----------------`n` Opcion "

# es el switch donde se hace el llamdo alas funciones previamente vistas 
switch ($respuesta)

{ 
   1{Escaneo-Subred}
   2{Escaneo-PuertosIP}
   3{EXit}
   Default {"`n`--opcion no valida---"}
}}

do
{
 clear
 get-menu
 Read-Host "`n`Pulsa intro para volver al menu"  
    
}while ($true)

#esta parte del codigo es para que sea ciclico hasta que se seleccione la opcion de salir
