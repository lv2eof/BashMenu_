#!/bin/bash

##############################################################################################################
### Variables definition
##############################################################################################################

n_MenuLineLenght_=63
n_MenuLineColOpt_=62
n_CommandColInit_=64
s_FileWithMenu_="102_Bu_V1_Menu_.txt"
s_FileWithCommands_="103_Bu_V1_Commands_.txt"
s_Question_="Option........................................................? "

##############################################################################################################
### function f_Execute_
###
### $1: Label after which the command is.
### $2: File from where read commands.
##############################################################################################################

function f_Execute_ {

    while read s_FileCommLine_; do
        if [ "$s_FileCommLine_" == "$1" ]; then
            read s_FileCommLine_
            break
        fi
    done < "$2"

    $s_FileCommLine_
}

##############################################################################################################
### function f_DisplayMenu_
###
### $1: Label after which begins lines to be displayed.
##############################################################################################################

function f_DisplayMenu_ {
   s_InitMenu_="0_"
   clear
   echo

   while read s_FileTextLine_; do
      if [ "$s_FileTextLine_" == "$1End_" ]; then
         break
      fi
      if [ "$s_InitMenu_" == "1_" ]; then
         s_OpcText_=${s_FileTextLine_:00:$n_MenuLineLenght_}
         echo $s_OpcText_
      fi
      if [ "$s_FileTextLine_" == "$1" ]; then
         s_InitMenu_="1_"
      fi
   done < "$s_FileWithMenu_"

   read -p "$s_Question_" s_OpcAnswer_
   s_OpcAnswer_="$(echo "$s_OpcAnswer_" | awk '{print toupper($0)}')"

   s_InitMenu_="0_"

   while read s_FileTextLine_; do
      if [ "$s_InitMenu_" == "1_" ]; then
         s_ReadNum_=${s_FileTextLine_:$n_MenuLineColOpt_:01}
         if [ "$s_ReadNum_" == "$s_OpcAnswer_" ]; then
            l_OpcMenu_=${s_FileTextLine_:$n_CommandColInit_}
            break;
         fi
      fi
      if [ "$s_FileTextLine_" == "$1" ]; then
         s_InitMenu_="1_"
      fi
   done < "$s_FileWithMenu_"
}

##############################################################################################################
### Main loop
##############################################################################################################

l_OpcMenu_="Menu_Home_"

while true; do
   if [ "$l_OpcMenu_" == "Menu_Quit_" ]; then
      clear
      break
   fi
   s_OpcType_=${l_OpcMenu_:00:05}
   if [ "$s_OpcType_" == "Menu_" ]; then
      l_OpcMenu_OLD_="$l_OpcMenu_"
      f_DisplayMenu_ "$l_OpcMenu_"
   fi
   if [ "$s_OpcType_" == "Comm_" ]; then
      f_Execute_ "$l_OpcMenu_" "$s_FileWithCommands_"
      f_DisplayMenu_ "$l_OpcMenu_OLD_"
   fi
done

##############################################################################################################
##############################################################################################################
##############################################################################################################

