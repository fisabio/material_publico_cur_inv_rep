Requisitos técnicos previos al inicio del curso
================

## Equipo

Creemos conveniente que cada uno de los alumnos se traiga su propio ordenador portátil al curso, de forma que cada alumno termine el curso con el software instalado que resulta necesario para poner en marcha cada una de las partes tratadas en él. De hecho, pensamos que ese es un activo del curso y por eso animamos a traer un portátil propio.

En cualquier caso, y para quien tuviera problemas para desplazarse con el ordenador o no dispusiera de uno, desde la organización podremos proporcionar uno por alumno. La persona interesada solo habría de decírnoslo a lo largo de la semana previa al inicio del curso.

## Software necesario

Con la intención de maximizar el tiempo útil del curso, creemos **necesario** que los alumnos instalen los siguientes programas de software (todos ellos disponibles en Linux, Mac y Windows):

- versión 3.3.4 de [R](https://cran.r-project.org/),
- versión 1.0.143 de [RStudio](https://www.rstudio.com/products/rstudio/download/), y
- versión 2.13.0 de [Git](https://git-scm.com/downloads).

## Paquetes de R

Durante las sesiones de trabajo resultará **necesario** usar algunos paquetes de R. Lanzando la siguiente sentencia se instalarán los imprescindibles junto a sus dependencias:

```r
install.packages(pkgs = c("devtools", "DT", "ggplot2", "leaflet", "pander", "plotly",
                          "rmarkdown", "roxygen2", "shiny", "testthat"))
```

## GitHub

Dado que forma una parte importante del curso, resulta **imprescindible** disponer de una cuenta en [GitHub](https://github.com/), cuyo registro solo precisa de un correo electrónico. GitHub es una plataforma web que da un respaldo remoto a todo el trabajo que se haga con Git de manera local. Es por ello que hay que asegurar que el canal de comunicación entre el ordenador y GitHub sea efectivo, lo que se reduce a tener bien introducidas en la cuenta de GitHub las claves SSH del ordenador (u ordenadores) en el que se trabaje. Para hacer esto, hay que abrir una terminal en cualquier directorio (los usuarios de Windows abrirán la aplicación *Git Bash* que se instala junto a Git) y seguir estos pasos:

1. Ejecutar la instrucción `ssh-keygen -t rsa -b 4096 -C "tu_correo@electronico.com"`, añadiendo el correo que desees (no tiene que ser el mismo que figura en la cuenta de GitHub que se acaba de crear, aunque es recomendable),
    - apretar Intro las veces necesarias hasta que dejen de aparecer mensajes en la terminal. Sobre todo **NO SE INTRODUCE UNA CONTRASEÑA**.
2. Ejecutar las siguientes instrucciones: primero `eval "$(ssh-agent -s)"`, esperar al resultado e introducir `ssh-add ~/.ssh/id_rsa`.
    - si apareciera un error en el último paso (algo poco probable), se deberá buscar el directorio `.ssh` en el sistema y modificar la anterior ruta.
3. Copiar el contenido del archivo `~/.ssh/id_rsa.pub`.
    - se puede hacer muy fácilmente con la instrucción `cat ~/.ssh/id_rsa.pub`, lo que imprimirá en la terminal un conjunto de caracteres que es el que hay que copiar.
4. Abrir un navegador e ir a la cuenta de GitHub. En la parte superior derecha, pinchar en el avatar y luego en *Settings*.
5. En el apartado *Personal settings*, pinchar en *SSH and GPG keys*.
6. En la sección *SSH keys*, hacer clic en *New SSH key*, otorgar un título a la clave (por ejemplo: mi-ordenador-personal), pegar la clave recién copiada en el apartado *Key*, y hacer clic en *Add SSH key* para terminar la operación.


Por último, solo queda que Git conozca la identidad del usuario del ordenador, para lo cual hay que introducir en una terminal:
```
git config --global user.name "tu_nombre_completo"
git config --global user.email tu_correo@electronico.com
```

En todo caso, esta conexión se tratará en la sesión correspondiente del curso de modo que si surgiera alguna complicación esta se podrá resolver durante el desarrollo del mismo.

## Software opcional

Aunque se puede aprovechar el curso al 100 % con lo anteriormente expuesto, sería **recomendable** (y por tanto, opcional) que quienes quieran experimentar con herramientas avanzadas acudan con una versión reciente y lo más completa posible de:

- el sistema de producción de documentos [TeX](https://es.wikipedia.org/wiki/TeX) (recomendamos la distribución de [Tex Live](https://tug.org/texlive/acquire-netinstall.html)),
- una [interfaz de usuario TeX](http://www.texstudio.org/),
- una [interfaz de usuario para Git](https://git-scm.com/downloads/guis) (aunque se trabajará desde terminal o RStudio, recomendamos [GitKraken](https://www.gitkraken.com/download) como elemento de apoyo), y
- un buen procesador de textos, siendo recomendable [Atom](https://atom.io/) o [Sublime Text](https://www.sublimetext.com/).

Los usuarios de Windows o Mac que deseen trabajar con código compilado (C++), deberán instalar [Rtools.exe](https://cran.r-project.org/bin/windows/Rtools/Rtools34.exe) (Windows) o [Xcode](https://developer.apple.com/xcode/) (Mac).
