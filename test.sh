

for i in `ls test/ | grep \\\\.c` ; do
	./minic test/$i
done
