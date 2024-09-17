# Instalando Arch Linux

- [Instalando Arch Linux](#instalando-arch-linux)
- [Configurar un entorno virtual 📦](#configurar-un-entorno-virtual-)
  - [Descargar la ISO 📀](#descargar-la-iso-)
  - [Crear una máquina en VBox 🖥️](#crear-una-máquina-en-vbox-️)
- [Particiones, formato y montaje](#particiones-formato-y-montaje)
  - [Crear particiones 🍕](#crear-particiones-)
  - [Formatear particiones ℹ️](#formatear-particiones-ℹ️)
  - [Montar particiones 🏇](#montar-particiones-)
    - [Crear el archivo fstab](#crear-el-archivo-fstab)
  - [Entrar en el sistema 🏠](#entrar-en-el-sistema-)
- [Configurando el sistema ⚙️](#configurando-el-sistema-️)
  - [Usuarios 👥](#usuarios-)
    - [Contraseña de root 🗝️](#contraseña-de-root-️)
    - [Crear un usuario regular 🙍](#crear-un-usuario-regular-)
    - [Editar el archivo **sudoers**](#editar-el-archivo-sudoers)
  - [Idiomas 💬](#idiomas-)
    - [Idiomas de los programas](#idiomas-de-los-programas)
    - [Idioma del teclado en consola ⌨️](#idioma-del-teclado-en-consola-️)
  - [Instalar Grub ☣️](#instalar-grub-️)
  - [Nombre del equipo (hostname) ❔](#nombre-del-equipo-hostname-)
  - [Archivo Hosts](#archivo-hosts)
  - [Instalar Neofetch 😎](#instalar-neofetch-)
  - [Reiniciar el sistema ♻️](#reiniciar-el-sistema-️)
- [Configurando el Sistema - 2 ⚙️](#configurando-el-sistema---2-️)
  - [Configurar los servicios de Internet 📶](#configurar-los-servicios-de-internet-)
    - [Si estamos en un portátil para wifi](#si-estamos-en-un-portátil-para-wifi)
  - [Añadiendo repositorios de AUR 🐊](#añadiendo-repositorios-de-aur-)
  - [Añadir repositorios de Black-Arch Linux 🖤](#añadir-repositorios-de-black-arch-linux-)
  - [Interfaz gráfica de usuario 👱‍♂️](#interfaz-gráfica-de-usuario-️)

Referencia de video: https://www.youtube.com/watch?v=fshLf6u8B-w&t=2737s

---

# Configurar un entorno virtual 📦
## Descargar la ISO 📀

Descarga la ISO desde la página oficial de Arch Linux usando el siguiente enlace:

[Arch Linux Official website](https://archlinux.org/download/)

![Alt text](images/Pasted%20image%2020231214083636.png)

## Crear una máquina en VBox 🖥️

Crea una nueva máquina con las siguientes características, <mark style="background: #FF5582A6;">2Gb de RAM y 20 Gb de disco duro</mark>, con un procesador.

![Alt text](images/Pasted%20image%2020231214083910.png)

![Alt text](images/Pasted%20image%2020231214083957.png)

![Alt text](images/Pasted%20image%2020231214084010.png)

---

# Particiones, formato y montaje

## Crear particiones 🍕

Primero configuraremos el teclado en español para trabajar más cómodamente.

```bash
loadkeys es
```

Con el siguiente comando podemos ver qué discos tenemos y sus particiones. En la imagen inferior, vemos que actualmente tenemos 3 discos, y nuestro disco duro será **sda**.

```bash
lsblk
```

![Alt text](images/Pasted%20image%2020231214084607.png)

---

Antes de continuar, verifica que tienes conexión a Internet haciendo un ping.

![Alt text](images/Pasted%20image%2020231214084912.png)

---

Usaremos el programa cfdisk para crear las particiones, dándole como parámetro la dirección de nuestro disco duro.

```bash
cfdisk /dev/sda
```

El primer paso será elegir la etiqueta (label), seleccionaremos **msdos**.

![Alt text](images/Pasted%20image%2020231214085236.png)

---

En el segundo paso, <mark style="background: #FFB8EBA6;">crearemos tres particiones: una para el boot, otra para el sistema operativo y la última para swap</mark>. Con la siguiente configuración de memoria. Ten cuidado, la partición de swap debe cambiarse de tipo.

![Alt text](images/Pasted%20image%2020231214085929.png)

Usando de nuevo `lsblk`, deberíamos poder ver las particiones de nuestro disco.

![Alt text](images/Pasted%20image%2020231214090148.png)

---

## Formatear particiones ℹ️

Ahora le daremos el formato adecuado a cada partición usando los siguientes comandos.

- Partición de arranque
```bash
mkfs.fat -F 32 /dev/sda1
```

- Para el sistema operativo
```bash
mkfs.ext4 /dev/sda2
```

- Para la partición de swap
```
mkswap /dev/sda3
```

Y para activar el swap
```bash
swapon /dev/sda3
```

---

## Montar particiones 🏇

Primero montaremos la partición raíz. <mark style="background: #FFB8EBA6;">Es necesario montarla primero porque el boot estará bajo la raíz.</mark>

```bash
mount /dev/sda2 /mnt
```

Montaremos la partición de arranque en la carpeta `/mnt/boot`, siempre después de montar la raíz.

```bash
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
```

---

Usando `packstrap`, instalaremos algunos paquetes esenciales. Estos agregarán muchos archivos conocidos del sistema Linux, ya que, por el momento, `/mnt` está vacío.

```bash
pacstrap /mnt linux linux-firmware networkmanager grub wpa_supplicant base base-devel
```

*Nota: Dado que la descarga es bastante grande, este es un buen momento para <mark style="background: #ABF7F7A6;">hacer una snapshot en VirtualBox</mark>. Así, si algo sale mal, podremos volver a este punto.*

---

### Crear el archivo fstab

El archivo fstab le dice al sistema operativo cómo deben montarse las particiones. De esta manera, se montarán automáticamente al iniciar el sistema y no será necesario repetir los pasos anteriores.

```bash
genfstab -U /mnt > /mnt/etc/fstab
```

---

## Entrar en el sistema 🏠

Con el siguiente comando, entramos en */mnt*, recordando que `mnt` tiene montada la raíz, es decir, el directorio raíz `/` de nuestro sistema operativo.

```bash
arch-chroot /mnt
```

---

# Configurando el sistema ⚙️

## Usuarios 👥

### Contraseña de root 🗝️

Primero, como estamos actuando como root, usaremos el comando `passwd` para establecer una nueva contraseña para root.

```bash
passwd
```

---

### Crear un usuario regular 🙍

Como sabes, no es recomendable hacer tareas generales como root, ya que tiene grandes riesgos. Por eso, crearemos un nuevo usuario y le daremos privilegios de root para que pueda ejecutar comandos como root si es necesario.

```bash
useradd -m mikel
passwd mikel
```

---

Ahora añadiremos el usuario al grupo *wheel* para que pueda usar `sudo su` o `sudo`, como mencionamos anteriormente.

```bash
usermod -aG wheel mikel
```

- Para ver los grupos de un usuario, usa `groups mikel`. Deberían aparecer dos grupos: wheel y mikel (el grupo predeterminado).

---

### Editar el archivo **sudoers**

El archivo sudoers es un archivo de configuración ubicado en */etc/sudoers*. Se utiliza para gestionar la seguridad, por ejemplo, para configurar si se pide contraseña o no al usar `sudo`, entre otras cosas.

---

Ahora instalaremos el paquete `sudo` usando `pacman`.

```bash
pacman -S sudo
```

También instalaremos algunos editores para editar archivos, como `vim` y `nano`.

```bash
pacman -S vim nano
```

---

Abre el archivo sudoers para editarlo:

```bash
nano /etc/sudoers
```

Elimina el comentario en la línea `%wheel ALL=(ALL:ALL) ALL`.

- <mark style="background: #FF5582A6;">Si eliminas el comentario en la línea de NOPASSWD, no se solicitará contraseña a los miembros del grupo wheel al usar `sudo`, pero esto no es recomendable por razones de seguridad.</mark>

![Alt text](images/Pasted%20image%2020231214130741.png)

---

## Idiomas 💬

### Idiomas de los programas

Usa `nano` para abrir

 el archivo */etc/locale.gen*. Este archivo, como muchos en `etc`, es de configuración. Contiene varios idiomas dentro, pero la mayoría están comentados.

![Alt text](images/Pasted%20image%2020231214133128.png)

Nuestro trabajo es descomentar el español y el inglés.
1. Busca `Cntr + W` y descomenta *en_US*.
2. Busca `Cntr + W` y descomenta *es_ES*.
3. Guarda y cierra.

Finalmente, usaremos el programa `locale-gen` para generar las palabras en los idiomas seleccionados.

```bash
locale-gen
```

---

### Idioma del teclado en consola ⌨️

Cuando abrimos la terminal, lo primero que hicimos fue configurarla en español. Para que no tengamos que hacerlo cada vez y aparezca por defecto en español, crea el siguiente archivo:

```bash
nano /etc/vconsole.conf
```

Escribe `KEYMAP=es` dentro y guarda.

---

## Instalar Grub ☣️

Grub es el gestor de arranque de Linux. Proporciona un menú al iniciar el sistema que permite elegir entre varios modos de arranque.

```bash
grub-install /dev/sda
```

Crea el archivo de configuración de Grub:

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

---

## Nombre del equipo (hostname) ❔

Como siempre, crearemos un archivo en `/etc` llamado `hostname` y dentro colocaremos el nombre de nuestro equipo.

```bash
echo mikel-pc > /etc/hostname
```

---

## Archivo Hosts

Este archivo contiene algunos alias, por ejemplo, `localhost` se refiere a `127.0.0.1`.

```bash
nano /etc/hosts
```

Añade las siguientes líneas, ten en cuenta que donde pone `mikel-pc`, debes colocar tu propio hostname.

```bash
127.0.0.1    localhost
::1          localhost
127.0.0.1    mikel-pc.localhost mikel-pc
```

---

## Instalar Neofetch 😎

Instala el programa `neofetch`, que nos mostrará información del sistema. Prueba usando `neofetch`.

```bash
pacman -S neofetch
```

![Alt text](images/Pasted%20image%2020231214135552.png)

---

## Reiniciar el sistema ♻️

En este punto, sal de root usando `exit` y reinicia con `reboot` en el contexto del Live CD. Ahora debería aparecer Grub y el sistema debería arrancar correctamente con todas las configuraciones que hemos establecido.

- Si no aparece Grub y Arch Linux arranca desde el Live CD, presiona `F12` al encender y selecciona el disco duro. Debería aparecer el menú de Grub.

![Alt text](images/Pasted%20image%2020231214140230.png)

*Nota: <mark style="background: #ABF7F7A6;">Este es un buen momento para hacer una snapshot en VirtualBox. Si algo sale mal, podremos volver a este punto.</mark>*

---

# Configurando el Sistema - 2 ⚙️

## Configurar los servicios de Internet 📶

Si intentamos hacer `ping www.googl.es`, veremos que no tenemos Internet.

Esto se debe a que el servicio de gestión de red no está activado. Haremos dos cosas:

1. Iniciar el servicio de NetworkManager.
2. Configurarlo para que se inicie automáticamente en el futuro.

```bash
systemctl start NetworkManager.service 
```

```bash
systemctl enable NetworkManager
```

Ahora `ping` debería funcionar. Prueba con `ping www.googl.es`.

### Si estamos en un portátil para wifi
Los mismos pasos aplican para el servicio *wpa_supplicant*.

```bash
systemctl start wpa_supplicant.service 
```

```bash
systemctl enable wpa_supplicant
```

---

## Añadiendo repositorios de AUR 🐊

AUR es un repositorio que contiene muchos programas creados por la comunidad. Nos permitirá descargar muchos más programas, pero primero tenemos que configurarlo.

0. Cambia a tu usuario, NO ROOT! Para cambiar: `su mikel`.
1. Primero, instala `git`. Git es una herramienta para gestionar repositorios. Es similar a Google Drive, pero se utiliza para código.

```bash
sudo pacman -S git
```

2. Crea una carpeta *repos* en el perfil de tu usuario personal en */home/{tu-usuario}/repos*.

```bash
mkdir -p Desktop/mikel/repos
```

3. Navega a la carpeta repos `cd !$`.

*Nota: `!$` es un pequeño truco que se refiere al último parámetro del comando anterior. En este caso, después de usar `mkdir -p Desktop/mikel/repos`, `!$` se referirá a `Desktop/mikel/repos`, por lo que ambos comandos son equivalentes 😀:
  * `cd Desktop/mikel/repos` es lo mismo que `cd !$`*.

4. Clona el siguiente repositorio, que es como descargarlo.

```bash
git clone https://aur.archlinux.org/paru-bin.git
```

Después de hacer esto, se creará una carpeta llamada `paru-bin` en el directorio de repos. Entra en el directorio y escribe:

```bash
makepkg -si
```

¡Hecho! Ahora tenemos disponibles los paquetes de AUR 👏.

---

## Añadir repositorios de Black-Arch Linux 🖤

Dentro de la carpeta *repos*, crea un directorio llamado `blackarch` y entra en él.

```bash
mkdir blackarch
cd blackarch
```

Usando el comando `curl`, descarga el archivo desde la siguiente dirección:
- `curl` se usa para descargar cosas de Internet. Es similar a hacer clic en un enlace para descargar algo en Chrome. Los sitios web también se descargan de esta manera; como prueba, intenta `curl www.google.es` para ver cómo te devuelve el sitio web de Google.

```bash
curl -O https://blackarch.org/strap.sh > strap.sh
```

El archivo `strap.sh` es un script de bash que podemos ejecutar, pero primero debemos darle permisos de ejecución.

```bash
chmod +x strap.sh
```

Ejecuta el script:

```bash
./strap.sh
```

Cuando el proceso haya terminado, si usamos el comando `pacman -Sy`, veremos que los repositorios de Blackarch aparecen en la lista de repositorios de `pacman`.

---

## Interfaz gráfica de usuario 👱‍♂️

Primero, descargaremos los paquetes para la interfaz gráfica.

 ⚠️ Ten cuidado, las descargas serán bastante pesadas. 
 ⚠️ Antes de comenzar, haz una snapshot de la máquina virtual.

```bash
pacman -S xorg xorg-server
```

```bash
pacman -S gnome
```

Como hicimos antes, activaremos los servicios de la interfaz gráfica usando `systemctl start` y `systemctl enable`.

```bash
systemctl start gdm.service
```

Después de hacer esto, debería aparecer la interfaz gráfica.
1. Inicia sesión.
2. Abre una terminal. Si no aparece, usa `Ctrl + Alt + F2` para abrir una terminal virtual.

```bash
systemctl enable gdm.service
```

Puede que la interfaz gráfica no se vea bien todavía. Intenta usar el siguiente comando para actualizar los paquetes del sistema y reinicia.

```bash
pacman -Syu
reboot
```