#!/bin/bash
 
echo No Node_Modules v0.0.1

EXIT_KEY=0
SCAN_KEY=1
C=99
SELECT_PREFIX='   '
ANSI_UP_KEYCODE=$'\x1b[A'
ANSI_DOWN_KEYCODE=$'\x1b[B'
ANSI_LEFT_KEYCODE=$'\x1b[D'
ANSI_RIGHT_KEYCODE=$'\x1b[C'
ENTER_KEYCODE=$''

print_menu () {
  echo "NONO v0.0.1"
  echo -e "\n"
  echo "$EXIT_KEY. Exit"
  echo "$SCAN_KEY. Scan"
  echo -e "\n"
}

clear_screen () {
  clear
}

scan_for_node_modules () {
  local list=(`find /home/$USER -type d -regex '.[^.]*/node_modules*' -prune`)
  return $list
}

print_table_title () {
  cols='SIZE \t PATH'
  echo -e "$SELECT_PREFIX$cols"
}

router () {
  case $1 in
    $EXIT_KEY)
      echo "Exit"
      ;;
    $SCAN_KEY)
      scan_for_node_modules
      ;;
    *)
      echo "Unknown option"       
      ;;
  esac
}

app () {
  clear_screen
  print_table_title
  scan_for_node_modules
}

print_table () {
  size_list=$1
  path_list=$2
  current_pointer=$3
  prefix=$SELECT_PREFIX
  for i in ${!size_list[@]}
  do
    if [ $i -eq $current_pointer ]; then prefix='-> '; fi
    echo -e "$prefix${size_list[$i]} \t ${path_list[$i]}"
    prefix=$SELECT_PREFIX
  done
}

delete_path () {
  id=$1
  echo "Delete $id"
}

main () {
  #scan_for_node_modules
  path_list=(`find /home/$USER -type d -regex '.[^.]*/node_modules*' -prune`)
  #get_folder_size
  size_list=()
  current_pointer=0
  for path in ${path_list[@]}
  do
    size=`echo $(du -hs $path) | cut -d ' ' -f 1`
    size_list+=($size)
  done
  if [ ${#path_list[@]} -eq 0 ]
  then
    echo "No node_modules found, have nice day"
  else
    while true
    do
      clear_screen
      if [ ${#path_list[@]} -gt 0 ]; then print_table_title; fi
      print_table $size_list $path_list $current_pointer
      read -sn3 x
      case "$x" in
      $ANSI_UP_KEYCODE)
        if [ $current_pointer -eq 0 ]
        then
          current_pointer=$((${#path_list[@]}-1))
        else
          current_pointer=$((current_pointer-1))
        fi
        ;;
      $ANSI_DOWN_KEYCODE)
        if [ $current_pointer -eq $((${#path_list[@]}-1)) ]
        then
          current_pointer=0
        else
          current_pointer=$((current_pointer+1))
        fi
        ;;
      $ENTER_KEYCODE)
        delete_path ${path_list[$current_pointer]}
        size_list[$current_pointer]="Deleted"
        rm -rf ${path_list[$current_pointer]}
        sleep 1
        ;;
      esac
    done
  fi
}

main
