#!/bin/bash
txtrst=$(tput sgr0) # Text reset
txtred=$(tput setaf 1) # Red
txtblu=$(tput setaf 4) # Blue
txtylw=$(tput setaf 3) # Yellow
web=$(zenity --list --column="Websites" "Wikipedia" "IMDb - Actor" "IMDb - Title")
if [ "$web" = "IMDb - Actor" ];
then
name=$USER
echo "${txtylw}Hello $name. What would you like to search for today?${txtrst}"
read search
echo "${txtred}$name has asked to search for $search. Performing necessary checks.${txtrst}"
sleep 1
DIRECTORY="/home/$name/IMDb"
if [ ! -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY doesn't exist
mkdir "$DIRECTORY"
fi
mkdir "/home/$name/IMDb/$search"
echo "${txtred}Downloading IMDb search results${txtrst}"
sleep 2
wget "http://en.wikipedia.org/wiki/$search" -O "/home/$name/IMDb/$search/$search.html"
echo "${txtred}Relevant links being located and moved${txtrst}"
sleep 2
grep -i "http://www.imdb.com/name/" "/home/$name/IMDb/$search/$search.html" > "/home/$name/IMDb/$search/grep.txt"
echo "${txtred}Filtering out everything that is not a web address${txtrst}"
sleep 2
awk -F'>' '/^a href/{split($1,F,"\"");print F[2],$NF}' RS='<' "/home/$name/IMDb/$search/grep.txt" > "/home/$name/IMDb/$search/awk.txt"
echo "${txtred}Isolating most accurate link${txtrst}"
sleep 2
grep -i "http://www.imdb.com/name/" "/home/$name/IMDb/$search/awk.txt" > "/home/$name/IMDb/$search/grep_url.txt"
echo "${txtred}Deleting all blank lines and cleaning up${txtrst}"
sleep 2
sed '/^$/d' "/home/$name/IMDb/$search/grep_url.txt" > "/home/$name/IMDb/$search/wget_url.txt"
echo "${txtred}Removing surplus data from file${txtrst}"
sleep 2
awk '{print $1}' "/home/$name/IMDb/$search/wget_url.txt" > "/home/$name/IMDb/$search/new_wget.txt"
echo "${txtred}All duplicates will be detected and deleted${txtrst}"
sleep 2
awk '{
if ($0 in stored_lines)
   x=1
else
   print
   stored_lines[$0]=1
}' "/home/$name/IMDb/$search/new_wget.txt" > "/home/$name/IMDb/$search/url.txt"
echo "${txtred}Copying main link to seperate files.${txtrst}"
sleep 2
head -1 "/home/$name/IMDb/$search/url.txt" > "/home/$name/IMDb/$search/file1.txt"
echo "${txtred}Adding extensions to new links ready for further downloads.${txtrst}"
sleep 2
awk ' { print $0"bio" } ' "/home/$name/IMDb/$search/file1.txt" > "/home/$name/IMDb/$search/url1.txt"
echo "${txtred}Retrieving Main article${txtrst}"
sleep 2
wget -i "/home/$name/IMDb/$search/url.txt" -P "/home/$name/IMDb/$search/"
echo "${txtred}Cleaning up directory and preparing for next stage${txtrst}"
sleep 2
rm "/home/$name/IMDb/$search/awk.txt" "/home/$name/IMDb/$search/grep.txt" "/home/$name/IMDb/$search/grep_url.txt" "/home/$name/IMDb/$search/wget_url.txt" "/home/$name/IMDb/$search/$search.html" "/home/$name/IMDb/$search/new_wget.txt" "/home/$name/IMDb/$search/url.txt" "/home/$name/IMDb/$search/file1.txt"
echo "${txtred}Downloading internal links to flesh out database${txtrst}"
sleep 2
wget -i "/home/$name/IMDb/$search/url1.txt" -O "/home/$name/IMDb/$search/bio.html"
rm "/home/$name/IMDb/$search/url1.txt"
echo "${txtylw}Job completed. You can find your files in the directory${txtrst} ${txtblu}/home/$name/IMDb/$search${txtrst}"
read -p "${txtylw}Press enter key to exit...${txtrst}" anykey
elif [ "$web" = "IMDb - Title" ];
then
echo "${txtylw}Please enter your username.${txtrst}"
read name
echo "${txtred}Username returned as $name. Proceeding to next step.${txtrst}"
sleep 1
echo "${txtylw}Hello $name. What would you like to search for today?${txtrst}"
read search
echo "${txtred}$name has asked to search for $search. Performing necessary checks.${txtrst}"
sleep 1
DIRECTORY="/home/$name/IMDb"
if [ ! -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY doesn't exist
mkdir "$DIRECTORY"
fi
mkdir "/home/$name/IMDb/$search"
echo "${txtred}Downloading IMDb search results${txtrst}"
sleep 2
wget "http://en.wikipedia.org/wiki/$search" -O "/home/$name/IMDb/$search/$search.html"
echo "${txtred}Relevant links being located and moved${txtrst}"
sleep 2
grep -i "http://www.imdb.com/title/" "/home/$name/IMDb/$search/$search.html" > "/home/$name/IMDb/$search/grep.txt"
echo "${txtred}Filtering out everything that is not a web address${txtrst}"
sleep 2
awk -F'>' '/^a href/{split($1,F,"\"");print F[2],$NF}' RS='<' "/home/$name/IMDb/$search/grep.txt" > "/home/$name/IMDb/$search/awk.txt"
echo "${txtred}Isolating most accurate link${txtrst}"
sleep 2
grep -i "http://www.imdb.com/title/" "/home/$name/IMDb/$search/awk.txt" > "/home/$name/IMDb/$search/grep_url.txt"
echo "${txtred}Deleting all blank lines and cleaning up${txtrst}"
sleep 2
sed '/^$/d' "/home/$name/IMDb/$search/grep_url.txt" > "/home/$name/IMDb/$search/wget_url.txt"
echo "${txtred}Removing surplus data from file and preparing for main download${txtrst}"
sleep 2
awk '{print $1}' "/home/$name/IMDb/$search/wget_url.txt" > "/home/$name/IMDb/$search/new_wget.txt"
sed 's/companycredits//' "/home/$name/IMDb/$search/new_wget.txt" > "/home/$name/IMDb/$search/urls.txt"
echo "${txtred}All duplicates will be detected and deleted${txtrst}"
sleep 2
awk '{
if ($0 in stored_lines)
   x=1
else
   print
   stored_lines[$0]=1
}' "/home/$name/IMDb/$search/urls.txt" > "/home/$name/IMDb/$search/url.txt"
echo "${txtred}Copying main link to seperate files.${txtrst}"
sleep 2
head -1 "/home/$name/IMDb/$search/url.txt" > "/home/$name/IMDb/$search/file1.txt"
cp "/home/$name/IMDb/$search/file1.txt" "/home/$name/IMDb/$search/file2.txt"
cp "/home/$name/IMDb/$search/file1.txt" "/home/$name/IMDb/$search/file3.txt"
cp "/home/$name/IMDb/$search/file1.txt" "/home/$name/IMDb/$search/file4.txt"
cp "/home/$name/IMDb/$search/file1.txt" "/home/$name/IMDb/$search/file5.txt"
cp "/home/$name/IMDb/$search/file1.txt" "/home/$name/IMDb/$search/file6.txt"
echo "${txtred}Adding extensions to new links ready for further downloads.${txtrst}"
sleep 2
awk ' { print $0"episodes" } ' "/home/$name/IMDb/$search/file1.txt" > "/home/$name/IMDb/$search/url1.txt"
awk ' { print $0"plotsummary" } ' "/home/$name/IMDb/$search/file2.txt" > "/home/$name/IMDb/$search/url2.txt"
awk ' { print $0"trivia" } ' "/home/$name/IMDb/$search/file3.txt" > "/home/$name/IMDb/$search/url3.txt"
awk ' { print $0"goofs" } ' "/home/$name/IMDb/$search/file4.txt" > "/home/$name/IMDb/$search/url4.txt"
awk ' { print $0"faq" } ' "/home/$name/IMDb/$search/file5.txt" > "/home/$name/IMDb/$search/url5.txt"
awk ' { print $0"movieconnections" } ' "/home/$name/IMDb/$search/file6.txt" > "/home/$name/IMDb/$search/url6.txt"
echo "${txtred}Retrieving Main article${txtrst}"
sleep 2
wget -i "/home/$name/IMDb/$search/url.txt" -P "/home/$name/IMDb/$search/"
echo "${txtred}Cleaning up directory and preparing for next stage${txtrst}"
sleep 2
rm "/home/$name/IMDb/$search/awk.txt" "/home/$name/IMDb/$search/grep.txt" "/home/$name/IMDb/$search/grep_url.txt" "/home/$name/IMDb/$search/wget_url.txt" "/home/$name/IMDb/$search/$search.html" "/home/$name/IMDb/$search/new_wget.txt" "/home/$name/IMDb/$search/url.txt" "/home/$name/IMDb/$search/urls.txt" "/home/$name/IMDb/$search/file1.txt" "/home/$name/IMDb/$search/file2.txt" "/home/$name/IMDb/$search/file3.txt" "/home/$name/IMDb/$search/file4.txt" "/home/$name/IMDb/$search/file5.txt" "/home/$name/IMDb/$search/file6.txt"
echo "${txtred}Downloading internal links to flesh out database${txtrst}"
sleep 2
wget -i "/home/$name/IMDb/$search/url1.txt" -O "/home/$name/IMDb/$search/episodes.html"
wget -i "/home/$name/IMDb/$search/url2.txt" -O "/home/$name/IMDb/$search/plotsummary.html"
wget -i "/home/$name/IMDb/$search/url3.txt" -O "/home/$name/IMDb/$search/trivia.html"
wget -i "/home/$name/IMDb/$search/url4.txt" -O "/home/$name/IMDb/$search/goofs.html"
wget -i "/home/$name/IMDb/$search/url5.txt" -O "/home/$name/IMDb/$search/faq.html"
wget -i "/home/$name/IMDb/$search/url6.txt" -O "/home/$name/IMDb/$search/movieconnections.html"
rm "/home/$name/IMDb/$search/url1.txt" "/home/$name/IMDb/$search/url2.txt" "/home/$name/IMDb/$search/url3.txt" "/home/$name/IMDb/$search/url4.txt" "/home/$name/IMDb/$search/url5.txt" "/home/$name/IMDb/$search/url6.txt"
echo "${txtylw}Job completed. You can find your files in the directory${txtrst} ${txtblu}/home/$name/IMDb/$search${txtrst}"
read -p "${txtylw}Press enter key to exit...${txtrst}" anykey
elif [ "$web" = "Wikipedia" ];
then
echo "${txtylw}Please enter your username.${txtrst}"
read name
echo "${txtred}Username returned as $name. Proceeding to next step.${txtrst}"
sleep 1
echo "${txtylw}Hello $name. What would you like to search for today?${txtrst}"
read search
echo "${txtred}$name has asked to search for $search. Performing necessary checks.${txtrst}"
sleep 1
DIRECTORY="/home/$name/Wikipedia"
if [ ! -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY doesn't exist
mkdir "$DIRECTORY"
fi
mkdir "/home/$name/Wikipedia/$search"
echo "${txtred}Downloading main article${txtrst}"
sleep 1
wget "http://en.wikipedia.org/wiki/$search" -O "/home/$name/Wikipedia/$search/$search.html"
echo "${txtred}Extracting bodytext from html file${txtrst}"
sleep 2
sed -n '/bodytext/,/bodytext/p' "/home/$name/Wikipedia/$search/$search.html" > "/home/$name/Wikipedia/$search/sed.html"
echo "${txtred}Placing all lines with links in seperate file${txtrst}"
sleep 2
grep /wiki/ "/home/$name/Wikipedia/$search/sed.html" > "/home/$name/Wikipedia/$search/grep_wiki.html"
echo "${txtred}Deleting all unnecessary characters${txtrst}"
sleep 2
awk -F'>' '/^a href/{split($1,F,"\"");print F[2],$NF}' RS='<' "/home/$name/Wikipedia/$search/grep_wiki.html" > "/home/$name/Wikipedia/$search/awk.html"
echo "${txtred}Add beginning url to all lines in file${txtrst}"
sleep 2
awk '{ printf "http://www.en.wikipedia.org"; print }' "/home/$name/Wikipedia/$search/awk.html" > "/home/$name/Wikipedia/$search/wget.txt"
echo "${txtred}Cleaning url paths ready for download${txtrst}"
sleep 2
awk '{print $1}' "/home/$name/Wikipedia/$search/wget.txt" > "/home/$name/Wikipedia/$search/new_wget.txt"
echo "${txtred}All duplicates will be detected and deleted${txtrst}"
sleep 2
awk '{
if ($0 in stored_lines)
   x=1
else
   print
   stored_lines[$0]=1
}' "/home/$name/Wikipedia/$search/new_wget.txt" > "/home/$name/Wikipedia/$search/wget_url.txt"
echo "${txtred}Removing all links to non-relevant data${txtrst}"
sleep 2
awk '!/#cite/' "/home/$name/Wikipedia/$search/wget_url.txt" > "/home/$name/Wikipedia/$search/urls.txt"
awk '!/orghttp/' "/home/$name/Wikipedia/$search/urls.txt" > "/home/$name/Wikipedia/$search/urls2.txt"
awk '!/Wikipedia:/' "/home/$name/Wikipedia/$search/urls2.txt" > "/home/$name/Wikipedia/$search/urls3.txt"
awk '!/index.php?/' "/home/$name/Wikipedia/$search/urls3.txt" > "/home/$name/Wikipedia/$search/urls4.txt"
echo "${txtred}Downloading all related links to $search. This may take a while.${txtrst}"
sleep 2
wget -i "/home/$name/Wikipedia/$search/urls4.txt" -P "/home/$name/Wikipedia/$search"
echo "${txtred}Now cleaning up your directory and preparing your database${txtrst}"
sleep 1
rm "/home/$name/Wikipedia/$search/awk.html" "/home/$name/Wikipedia/$search/wget.txt" "/home/$name/Wikipedia/$search/grep_wiki.html" "/home/$name/Wikipedia/$search/sed.html" "/home/$name/Wikipedia/$search/new_wget.txt" "/home/$name/Wikipedia/$search/wget_url.txt" "/home/$name/Wikipedia/$search/urls.txt" "/home/$name/Wikipedia/$search/urls2.txt" "/home/$name/Wikipedia/$search/urls3.txt" "/home/$name/Wikipedia/$search/urls4.txt"
echo "${txtylw}Job completed. You can find your files in the directory${txtrst} ${txtblu}/home/$name/Wikipedia/$search${txtrst}"
read -p "${txtylw}Press enter to exit...${txtrst}" anykey
else
    echo "${txtylw}We'll see you soon. Thanks for using${txtrst}"
fi
