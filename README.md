# Update-time-and-date-on-Windows
Update time and date on Windows Server using PowerShell
# Como ejecutarlo:
- Descargar el archivo PS1 o copia el codigo del script
- Guardar en el equipo donde va a ejecutar el script, en caso de copiar el script se debe guardar con la extencioón .ps1
- Ejecutar el script en modo ADMINISTRADOR
# Lo que hace:
  Detalles del script
### 1. Detener y desinstalar el servicio
Antes de reparar algo, hay que apagarlo y limpiar los registros previos.

- Stop-Service w32time
  + Qué hace: Detiene el servicio de Windows que gestiona la hora. Si el servicio está "trabado" o funcionando mal, este comando lo obliga a cerrarse para que no bloquee los archivos que vamos a modificar.
- w32tm /unregister
  + Qué hace: Elimina por completo la configuración del servicio del Registro de Windows y quita el servicio del sistema. Básicamente, le dice al sistema: "Olvida que este servicio existía".

### 2. Reinstalar y reiniciar
Ahora que el camino está limpio, volvemos a crear el servicio desde cero.

- w32tm /register
  + Qué hace: Vuelve a registrar el servicio en el sistema y crea las claves de registro predeterminadas (y limpias) en HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\W32Time.
- Start-Service w32time
  + Qué hace: Arranca de nuevo el servicio que acabamos de instalar. Ahora el servicio está corriendo con una configuración de fábrica.

### 3. Configuración y Sincronización
Aquí es donde le dices al sistema de dónde debe sacar la hora exacta.

- w32tm /config /manualpeerlist:"time.windows.com,0x1" /syncfromflags:manual /reliable:yes /update
  + /manualpeerlist:"time.windows.com,0x1": Establece a quién le vamos a preguntar la hora. El 0x1 es una bandera que indica que se use un intervalo de tiempo especial definido en el registro.
  + /syncfromflags:manual: Le ordena al equipo que use la lista que acabamos de escribir (manual) en lugar de buscar un servidor en un dominio de red.
  + /reliable:yes: Marca a este equipo como una fuente de hora confiable para otros.
  + /update: Avisa al servicio de que la configuración ha cambiado para que surta efecto inmediato sin reiniciar.

- w32tm /resync /force
  + Qué hace: Le ordena al reloj que se sincronice ahora mismo. El parámetro /force hace que el sistema ignore cualquier diferencia de tiempo acumulada y fuerce el ajuste con el servidor de Microsoft.
 
# Codigo fuente

```Stop-Service w32time
w32tm /unregister
w32tm /register
Start-Service w32time
$ServidorHora = "time.windows.com"
w32tm /config /manualpeerlist:"$ServidorHora,0x1" /syncfromflags:manual /reliable:yes /update
w32tm /resync /force
#Autor: Ricardo VS
