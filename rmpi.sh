#!/bin/bash

get_setting()
{
    printf "\r$1 [$2]: "
    read result

    if [ -z $result ];
    then
        result=$2
    fi
}

project_name=''

while [ -z $project_name ]
do
    printf "\rProject name: "
    read project_name
done

get_setting "Description" "A raylib_misc game"
project_description=$result

get_setting "Author" $USER
project_author=$result

get_setting "License" "proprietary"
project_license=$result

get_setting "Copyright string" "Copyright © $(date +%Y), $project_author"
project_cp_string=$result

mkdir $project_name
cd $project_name

wget -O temp.zip https://github.com/RealDoigt/raylib_misc/archive/refs/heads/main.zip
unzip -d ./temp/ temp.zip
rm temp.zip

mkdir source

mv ./temp/raylib_misc-main/lib/ ./source/raylib_misc/
rm -r ./temp/

# mv update_rm.sh ./source/update_rm.sh
mv app.d ./source/app.d

echo 'source/raylib_misc/*' > .gitignore
echo $project_name >> .gitignore
echo '.dub' >> .gitignore

wget -O temp.tar.gz https://github.com/raysan5/raylib/releases/download/4.0.0/raylib-4.0.0_linux_amd64.tar.gz
tar -xzf temp.tar.gz
rm temp.tar.gz

mv ./raylib-4.0.0_linux_amd64/include/ ./include/
mv ./raylib-4.0.0_linux_amd64/lib/ ./lib/
rm -r ./raylib-4.0.0_linux_amd64/

rm ./lib/libraylib.so
rm ./lib/libraylib.so.4.0.0
rm ./lib/libraylib.so.400

echo "name \"$project_name\"" > dub.sdl
echo "description \"$project_description\"" >> dub.sdl
echo "authors \"$project_author\"" >> dub.sdl
echo "license \"$project_license\"" >> dub.sdl
echo "copyright \"$project_copyright\"" >> dub.sdl

dub add raylib-d

echo "libs \"raylib\"" >> dub.sdl
echo "lflags \"-L./lib\"" >> dub.sdl
