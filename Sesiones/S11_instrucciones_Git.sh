git config --global user.name "Carlos Vergara-Hernández"
git config --global user.email "vergara_car@gva.es"
git config user.name
git config user.email
ssh -T git@github.com
mkdir ~/pintamapas
cd ~/pintamapas
pwd
git init
git status
echo "pintamapas
---------
Paquete de R para representar mapas" >> README.md
echo "Esto es un archivo de prueba en el proyecto." >> prueba.txt
git status
git add README.md
git status
git add .
git status
echo "Este paquete funciona gracias a la funcion \`pintamapas()\`" >> README.md
git status
git add .
git commit -m "Primer commit: se crean archivos README.md y prueba.txt"
git log
mkdir -p inst/docs && cp README.md inst/docs/README.md
git add "*.md" # git add tambien acepta patrones.
git commit -m "Segundo commit: se añade copia de README.md en inst/docs/"
echo "Las dependencias del paquete son \`sp\` y \`RColorBrewer\`" >> README.md
git status
git diff
git log --oneline --decorate --graph
git commit -a -m "Tercer commit: especificar dependencias en README.md"
echo "Este es nuevo archivo" >> inst/docs/nuevo_doc.txt
git add . && git commit -m "Cuarto commit: se incorpora inst/docs/nuevo_doc.txt"
git tag "v0.0.1"
git tag
echo "Una nueva modificación" >> README.md
git add .
git rm --cached README.md
git status
git add .
git reset HEAD README.md
git checkout -- README.md
git status
git mv inst/docs/nuevo_doc.txt inst/docs/doc_renombrado.txt
git status -sb
git mv prueba.txt inst/docs/prueba.txt
git status -sb
git commit -m "Quinto commit: se cambia de nombre de archivo"
echo -e ".Rhistory\n.RData\n.Rproj.user/\n/cache/" >> .gitignore
git add . && git commit -m "Se añade el archivo .gitignore y archivos renombrados"
git branch
git branch desarrollo
git checkout desarrollo
echo 'Creamos un archivo en la nueva rama' >> desarrollo.txt
git status
git add . && git commit -m "Primer commit en desarrollo: se incorpora un archivo"
git checkout master
echo "Solucionamos el problema en la rama master" >> solucion_bug.txt
git add . && git commit -m "Sexto commit: se soluciona un bug"
git checkout desarrollo
echo 'Continuamos con nuestro trabajo' >> desarrollo.txt
git add . && git commit -m "Segundo commit en desarrollo: se finaliza la mejora"
git checkout master
git merge desarrollo -m "Séptimo commit: Unión de dos ramas"
git log -n 5 --oneline --decorate --graph --all
git branch -d desarrollo
git remote add origin git@github.com:carlosvergara/pintamapas.git
git remote -v
git push -u origin master
echo "Este paquete ha sido desarrollado en el curso de investigación repsoducible" >> README.md
git add . && git commit -m "Octavo commit: se hacen modificaciones para probar el trabajo con GitHub"
git status
git push -u origin master
git status
echo "Modificación del viernes" >> README.md
git add . && git commit -m "Noveno commit: queda trabajo pendiente para el fin de semana"
git push -u origin master
git pull
echo "Modificación del sábado" >> README.md
git add . && git commit -m "Décimo commit: se adelanta trabajo el sábado"
git push -u origin master
git pull
git clone https://github.com/fisabio/fisabior ~/fisabior
rm -r ~/fisabior
rm -r ~/pintamapas
