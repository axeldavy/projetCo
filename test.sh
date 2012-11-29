

for i in `ls test/ | grep \\\\.c` ; do
	./minic -parse-only test/$i
done
