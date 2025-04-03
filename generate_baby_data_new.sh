 if [ `ls -1 names[12][890][0-9]0s.html | wc -l` -eq 14 ]; then
     echo "14 data source input files in html detected. Converting files to
 text in Python."
     for decade in {188..201}0; do
         html="names${decade}s.html";
         text="names${decade}s.txt";
         python -c 'import sys, html2text; print(html2text.html2text(sys.stdin.read()))' < $html > $text
     done;
 else
     echo "Downloading source data and converting files to text in Python."
     for decade in {188..201}0; do
         html="names${decade}s.html";
         text="names${decade}s.txt";
         if [ -e $html ]; then
             echo "file $html exists. Skipping."
         else
             sleep 1;
             wget --no-check-certificate "https://www.ssa.gov/oact/babynames/decades/names${decade}s.html";
             python -c 'import sys, html2text; print(html2text.html2text(sys.stdin.read()))' < $html > $text
         fi;
     done;
 fi;


 perl -ne 'print "$ARGV:$_" if (/^\d+\s\|/)' names[12][890][0-9]0s.txt | cut -c 6-10,15- | tr -d " ," | tr ":|" , > baby_clean.csv
 
 echo "Computing Frequency Distribution of First Letters Among Top-Ranked Boys'
 Names Over 14 Decades Sorted by Letter:"
 cut -d, -f3 baby_clean.csv | tr -d a-z | sort | uniq -c | tr -s ' ' | cut -c2- | tr ' ' '\t' > boys_letters_obs.txt
 echo "Saved to file \"boys_letters_obs.txt\""

 # Compute population-level frequencies of first letters
 echo "Computing Birth-Weighted Frequency Distribution of First Letters Among
 Top-Ranked Boys' Names Over 14 Decades:"
 cut -d, -f3,4 baby_clean.csv | tr -d a-z |
 perl -F, -ane '$f{$F[0]} += $F[1];END{foreach my $k (sort keys %f) { print "$f{$k} $k\n"}}' |
 tr ' ' '\t'  > boys_letters_pop.txt
 echo "Saved to file \"boys_letters_pop.txt\""


 # Compute observation-level frequency distribution of first letters of girls' names
 echo "Computing Frequency Distribution of First Letters Among Top-Ranked
 Girls' Names Over 14 Decades:"
 cut -d, -f5 baby_clean.csv | tr -d a-z | sort | uniq -c | tr -s ' ' | cut -c2- | tr ' ' '\t' > girls_letters_obs.txt
 echo "Saved to file \"girls_letters_obs.txt\""

 # Compute population-level frequencies of first letters
 echo "Computing Birth-Weighted Frequency Distribution of First Letters Among
 Top-Ranked Girls' Names Over 14 Decades:"
 cut -d, -f5,6 baby_clean.csv | tr -d a-z |
 perl -F, -ane '$f{$F[0]} += $F[1];END{foreach my $k (sort keys %f) { print "$f{$k} $k\n"}}' |
 tr ' ' '\t' > girls_letters_pop.txt
 echo "Saved to file \"girls_letters_pop.txt\""


 # Compute observation-level frequency distribution of first letters of boys'
  echo "Computing Frequency Distribution of First Letters Among Top-Ranked Names
 Over Both Sexes and 14 Decades:"
 cut -d, -f3,5 baby_clean.csv | tr , '\n' | tr -d a-z | sort | uniq -c | tr -s ' ' | cut -c2- | tr ' ' '\t' > both_letters_obs.txt
 echo "Saved to file \"both_letters_obs.txt\""

 # Compute population-level frequencies of first letters
 echo "Computing Birth-Weighted Frequency Distribution of First Letters Among
 Top-Ranked Names Over Both Sexes and 14 Decades:"
 cut -d, -f3,4,5,6 baby_clean.csv | tr -d a-z |
 perl -F, -ane '$f{$F[0]} += $F[1];$f{$F[2]} += $F[3];END{foreach my $k (sort keys %f) { print "$f{$k} $k\n"}}' |
 sort -nr -k1,1 > both_letters_pop.txt
 echo "Saved to file \"both_letters_pop.txt\""


 ls -1 *_letters_*.txt # should be exactly six files
 wc -l *_letters_*.txt # of 23 and 25 lines


 paste boys_letters_pop.txt boys_letters_obs.txt | perl -ane 'print join "\t",@F[1,0,2];print "\n"' > boys_paste.txt

 paste girls_letters_pop.txt girls_letters_obs.txt both_letters_pop.txt both_letters_obs.txt |  perl -ane 'print join "\t",@F[1,0,2,4,6];print "\n"' > other_paste.txt

 join -j 1 -a 2 -e '0' -o '0,1.2,1.3,2.2,2.3,2.4,2.5' boys_paste.txt other_paste.txt > baby_letters.txt
