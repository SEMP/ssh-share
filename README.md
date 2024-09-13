### 01. Crear archivo .env
Copiar el contenido del archivo rename.env a un archivo con nombre .env y posterior mente editar su contenido.

```
cp rename.env .env
vi .env
```
### 02. Iniciar el contenedor
```
docker-composes up
```
### 03. Cargar los archivos que desea compartir por SSH en la carpeta **shared-files**
```
sudo touch ./shared-files/compartir.txt
```
### 04. Obtener los archivos por SSH
Se puede conectar por ssh para ver / editar los archivos (segun los permisos configurados)
El siguiente es un ejemplo de un comando para copiar un archivo **compartir.txt** utilizando el puerto **2222** con el usuario **elhacker**.
```
scp -P 2222 elhacker@localhost:/shared-files/compartir.txt .
```
