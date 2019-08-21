#!/bin/bash
INSTALL_DIR=$HOME/.nono
nono_has () {
  type "$1" > /dev/null 2>&1
}

nono_download() {
  if nono_has "curl"; then
    curl --compressed -q "$@"
  elif nono_has "wget"; then
    ARGS=$(echo "$*" | command sed -e 's/--progress-bar /--progress=bar /' \
                            -e 's/-L //' \
                            -e 's/--compressed //' \
                            -e 's/-I /--server-response /' \
                            -e 's/-s /-q /' \
                            -e 's/-o /-O /' \
                            -e 's/-C - /-c /')
    eval wget $ARGS
  fi
}

create_install_dir () {
  if [ ! -d $INSTALL_DIR ]
  then
    mkdir $INSTALL_DIR
  fi
}

create_install_dir
nono_download -s https://raw.githubusercontent.com/phuonghau98/nono/master/nono.sh -o $INSTALL_DIR/nono.sh
chmod a+x $INSTALL_DIR/nono.sh
echo -e "alias nono=$INSTALL_DIR/nono.sh" >> /home/$USER/.bashrc
source $HOME/.bashrc
