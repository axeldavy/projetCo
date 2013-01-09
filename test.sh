
#tests/exec/*.c ; do  #


#for i in `ls tests/exec | grep \\\\.out` ; do
#	cat ./tests/ligne ./tests/exec/$i ./tests/ligne > ./tests/exec/temp.tout
#	cat ./tests/exec/temp.tout > ./tests/exec/$i
#done


for i in `ls tests/exec | grep \\\\.c` ; do
	echo test fichier $i
	./minic tests/exec/$i
	(java -jar Mars_4_2.jar tests/exec/`basename $i .c`.s)|grep -v 'Vollmar' > tests/exec/`basename $i .c`_minic.out
	diff -s tests/exec/`basename $i .c`.out tests/exec/`basename $i .c`_minic.out
done
