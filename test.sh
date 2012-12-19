

for i in `ls test/ | grep \\\\.c` ; do
	./minic -type-only test/$i
done
