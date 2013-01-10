
#tests/exec/*.c ; do  #


#for i in `ls tests/exec | grep \\\\.out` ; do
#	cat ./tests/ligne ./tests/exec/$i ./tests/ligne > ./tests/exec/temp.tout
#	cat ./tests/exec/temp.tout > ./tests/exec/$i
#done


#for i in `ls tests/exec | grep \\\\.c` ; do
#	echo test fichier $i
#	./minic tests/exec/$i
#	(java -jar Mars_4_2.jar tests/exec/`basename $i .c`.s)|grep -v 'Vollmar' > tests/exec/`basename $i .c`_minic.out
#	diff -s tests/exec/`basename $i .c`.out tests/exec/`basename $i .c`_minic.out
#done

for i in `ls tests/exec-fail | grep \\\\.c` ; do
	echo test_mauvais fichier $i
	./minic tests/exec-fail/$i
	(java -jar Mars_4_2.jar tests/exec-fail/`basename $i .c`.s)|grep -v 'Vollmar' > tests/exec-fail/`basename $i .c`_minic.out
done

#for i in `ls tests/syntax/bad | grep \\\\.c` ; do
#	echo test_mauvais_syntaxe fichier $i
#	./minic -parse-only tests/syntax/bad/$i
#done

#for i in `ls tests/syntax/good | grep \\\\.c` ; do
#	echo test_bon_syntaxe fichier $i
#	./minic -parse-only tests/syntax/good/$i
#done

#for i in `ls tests/typing/bad | grep \\\\.c` ; do
#	echo test_mauvais_typage fichier $i
#	./minic -type-only tests/typing/bad/$i
#done

#for i in `ls tests/typing/good | grep \\\\.c` ; do
#	echo test_bon_typage fichier $i
#	./minic -type-only tests/typing/good/$i
#done
