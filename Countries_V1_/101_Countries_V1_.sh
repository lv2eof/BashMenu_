#!/bin/bash

##############################################################################################################
### function f_Execute_
###
### $1: Label after which begins to execute commands.
### $2: File from which read commands.
### $3: Stop after each command executed [StopYes / StopNo].
##############################################################################################################

function f_Execute_ {
   s_InitComm_="0_"
   clear
   echo

   while read s_FileCommLine_;do
      if [ "$s_FileCommLine_" == "$1End_" ]; then
         break
      fi
      if [ "$s_InitComm_" == "1_" ]; then
         eval $s_FileCommLine_
         if [ "$3" == "StopYes" ]; then
            echo
            printf "$s_MessageComm_"
            read </dev/tty
         fi
      fi
      if [ "$s_FileCommLine_" == "$1" ]; then
         s_InitComm_="1_"
      fi
   done < "$2"
}

##############################################################################################################
### function f_DisplayMenu_
###
### $1: Label after which begins to display lines readed.
##############################################################################################################

function f_DisplayMenu_ {
   s_InitMenu_="0_"
   clear
   echo

   while read s_FileTextLine_;do
      if [ "$s_FileTextLine_" == "$1End_" ]; then
         break
      fi
      if [ "$s_InitMenu_" == "1_" ]; then
         s_OpcText_=${s_FileTextLine_:00:63}
         echo $s_OpcText_
      fi
      if [ "$s_FileTextLine_" == "$1" ]; then
         s_InitMenu_="1_"
      fi
   done < "$s_FileWithMenu_"

   read -p "$s_Question_" s_OpcAnswer_
   s_OpcAnswer_="$(echo "$s_OpcAnswer_" | awk '{print toupper($0)}')"

   s_InitMenu_="0_"

   while read s_FileTextLine_;do
      if [ "$s_InitMenu_" == "1_" ]; then
         s_ReadNum_=${s_FileTextLine_:$n_ColForMenu_Last_:$n_ColForMenu_First_}
         if [ "$s_ReadNum_" == "$s_OpcAnswer_" ]; then
            l_OpcMenu_=${s_FileTextLine_:$n_ColForCommands_Init_}
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

s_ThisFileWithExt_=$(basename "$0")
s_ThisFileWithoutExt_="${s_ThisFileWithExt_%.*}"
s_FileWithVars_="$s_ThisFileWithoutExt_"".txt"
f_Execute_ VarsDef_ "$s_FileWithVars_" StopNo

f_Execute_ "Init_" "$s_FileWithCommands_" StopNo

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
      f_Execute_ "$l_OpcMenu_" "$s_FileWithCommands_" StopYes
      f_DisplayMenu_ "$l_OpcMenu_OLD_"
   fi
done

##############################################################################################################
##############################################################################################################
##############################################################################################################

