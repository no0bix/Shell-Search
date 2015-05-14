#!/bin/bash
txtrst=$(tput sgr0) # Text reset
txtred=$(tput setaf 1) # Red
txtblu=$(tput setaf 4) # Blue
txtylw=$(tput setaf 3) # Yellow
web=$(zenity --list --column="Google" "Web" "Images")
if [ "$web" = "Web" ];
then
echo "${txtylw}Please enter your username.${txtrst}"
read name
echo "${txtred}Username returned as $name. Proceeding to next step.${txtrst}"
sleep 1
echo "${txtylw}Hello $name. What would you like to search for today?${txtrst}"
read search
echo "${txtred}$name has asked to search for $search. Performing necessary checks.${txtrst}"
DIRECTORY="/home/$name/$search"
if [ ! -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY doesn't exist
mkdir "$DIRECTORY"
fi
wget -U "Chrome" "http://www.google.co.uk/search?hl=en&source=hp&ie=ISO-8859-1&q=$search" -O "/home/$name/$search/$search.html"
awk -F'>' '/^a href/{split($1,F,"\"");print F[2],$NF}' RS='<' "/home/$name/$search/$search.html" > "/home/$name/$search/awk.html"
awk '!/Bell&amp/' "/home/$name/$search/awk.html" > "/home/$name/$search/clean.txt"
awk '!/google.co/' "/home/$name/$search/clean.txt" > "/home/$name/$search/new.txt"
awk '!/en&amp/' "/home/$name/$search/new.txt" > "/home/$name/$search/new2.txt"
awk '!/preferences/' "/home/$name/$search/new2.txt" > "/home/$name/$search/new3.txt"
awk '!/q=h/' "/home/$name/$search/new3.txt" > "/home/$name/$search/new4.txt"
awk '!/#/' "/home/$name/$search/new4.txt" > "/home/$name/$search/new5.txt"
sed '18,$ d' "/home/$name/$search/new5.txt" > "/home/$name/$search/sed.txt"
awk '{print $1}' "/home/$name/$search/sed.txt" > "/home/$name/$search/wget.txt"
wget -i "/home/$name/$search/wget.txt" -P "/home/$name/$search/"
rm "/home/$name/$search/$search.html" "/home/$name/$search/awk.html" "/home/$name/$search/clean.txt" "/home/$name/$search/new.txt" "/home/$name/$search/new2.txt" "/home/$name/$search/new3.txt" "/home/$name/$search/new4.txt" "/home/$name/$search/new5.txt" "/home/$name/$search/sed.txt" "/home/$name/$search/wget.txt"
echo "${txtylw}Job completed. You can find your files in the directory${txtrst} ${txtblu}/home/$name/$search${txtrst}"
read -p "${txtylw}Press enter key to exit...${txtrst}" anykey
elif [ "$web" = "Images" ]
then
echo "${txtylw}Images is not yet ready...${txtrst}"
else
echo "${txtylw}We'll see you soon. Thanks for using${txtrst}"
fi
