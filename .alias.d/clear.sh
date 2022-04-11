#!/usr/bin/env bash

#alias clear='clear; seq 1 $(tput cols) | sort -R | spark | lolcat -a -d 100; clear;' # Coloured

# Coloured Chromatic Dragon
function chromatic_dragon (){
  printf "\n
+================================+\n
   Behold, The Chromatic Dragon!  \n
  ⌖                ⌖☽       ⌖     \n
  °°⌖ᚗ᚜༓ྀ☁︎ˇ̈́͡ʻ̽☁︎°༺༼⎀༽༻°☁︎ʻ̽̀͡ˇ̈☁︎༓ི᚛ᚗ⌖°° \n
" | lolcat -a -s 100;

  echo "";


  echo "  Take three seconds to calm down." | lolcat -a -s 1000;

  fortune | cowsay -f  "dragon.cow" | lolcat -a -s 1000;

  echo "+================================+"| lolcat -a -s 1000;
  sleep 3;
  clear;
}

alias clear='chromatic_dragon';
