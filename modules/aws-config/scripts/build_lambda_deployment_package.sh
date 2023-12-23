#! /bin/bash

requirements_file=requirements.txt
folder=''

print_usage() {
  printf "Usage: use -f and pass the path of the folder in which the lambda and the requirements.txt is placed"
}

while getopts 'f:' flag; do
  case "${flag}" in
    f) folder="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done


cd $folder

# Cleanup
rm -rf function.zip
rm -rf package


# Install requirements
if test -f "$requirements_file"; then
    pip3 install --target ./package -r $requirements_file
    cd package/ && zip -r ../function.zip . && cd ..
fi

# Add Python code
zip function.zip *.py

# Cleanup
rm -rf package
