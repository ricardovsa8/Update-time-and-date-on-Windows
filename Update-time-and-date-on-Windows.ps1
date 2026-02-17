#Modificar la hora y fecha
#set-date -Date "20-5-2024 10:44:55 AM"

#Ejecutar como administrador

#Detener el servico de hora de windows
Stop-Service w32time

#Anular el registro y vuelva a registrar el servicio para restablecer la configuración prederminada
w32tm /unregister
w32tm /register

#Iniciarl el servicio de hora en windows
Start-Service w32time

#Configurando parametro del servidor de hora
$ServidorHora = "time.windows.com"

#Configurar una fuente de hora externa
w32tm /config /manualpeerlist:"$ServidorHora,0x1" /syncfromflags:manual /reliable:yes /update

#Forma la sincronización de hora
w32tm /resync /force

#Obtener la hora actual
#get-date

#Autor Ricardo