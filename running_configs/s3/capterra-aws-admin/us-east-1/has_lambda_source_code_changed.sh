#!/bin/bash


for name in $@;
do
  tmp_dir=tmp$(date +%s)

  if [[ -f "$name.zip" ]]; then
    mkdir $tmp_dir
    unzip $name.zip -d $tmp_dir >/dev/null
    diff $tmp_dir/$name.py $name.py > /dev/null
    if [ "$?" -eq 1 ]; then
      # source code has been changed
      echo "Source code has been changed"
      zip $name.zip $name.py
    else
      echo "No change"
    fi
    rm -rf $tmp_dir/
  else
    echo "Zip archive does not exists"
    echo "Creating archive"
    zip $name.zip $name.py
  fi
done
