#!/usr/bin/env bash

CPP_OR_C
read -p "Is this a C or CPP Project [y/n]: " CPP_OR_C

create_component() {
  read -p "Enter Component Name: " COMPONENT_NAME
  if [ -d "$COMPONENT_NAME" ]; then
    echo "$COMPONENT_NAME already exists"
    return
  fi

  cd include
  mkdir $COMPONENT_NAME
  cd $COMPONENT_NAME
  
  touch $COMPONENT_NAME.h

  cd ..
  cd ..

  cd src
  if [[ "$CPP_OR_C" = "y" ]]; then
    touch $COMPONENT_NAME.c
    echo "#include \"../include/$COMPONENT_NAME/$COMPONENT_NAME.h\"" >> $COMPONENT_NAME.c
    cd ..
    echo "    src/$COMPONENT_NAME.c" >> CMakeLists.txt
  else 
    touch $COMPONENT_NAME.cpp
    echo "#include \"../include/$COMPONENT_NAME/$COMPONENT_NAME.h\"" >> $COMPONENT_NAME.cpp
    cd ..
    echo "    src/$COMPONENT_NAME.cpp" >> CMakeLists.txt
  fi

}


read -p "Enter Project Name: " PROJECT_NAME

if [ -d "$PROJECT_NAME" ]; then
  echo "$PROJECT_NAME already exists"
  exit 1
fi

mkdir $PROJECT_NAME
cd $PROJECT_NAME

touch CMakeLists.txt
cat <<EOT >> CMakeLists.txt
cmake_minimum_required(VERSION 3.15)
project ($PROJECT_NAME)
set(CMAKE_CXX_STANDARD 17)

add_subdirectory(include)
add_subdirectory(src)

add_executable(driver 
EOT

if [[ "$CPP_OR_C" = "y" ]]; then
  echo "    src/driver.c" >> CMakeLists.txt
else
  echo "    src/driver.cpp" >> CMakeLists.txt
fi

touch Dockerfile
cat <<EOT >> Dockerfile
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \  
    build-essential \  
    clang \  
    libc++-dev \  
    libc++abi-dev \  
    cmake \  
    && rm -rf /var/lib/apt/lists/*  

WORKDIR /  

COPY . .  

RUN mkdir build && cd build && \  
    cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_CXX_FLAGS="-stdlib=libc++" .. && \  
    make  

CMD ["./build/driver"]  
EOT


mkdir src
cd src
echo "project ($PROJECT_NAME)" >> CMakeLists.txt 
if [[ "$CPP_OR_C" = "y" ]]; then
  touch driver.c
  cat <<EOT >> driver.c
#include <stdio.h>

int main(int argc, char** argv) {
    printf("%s\n", "Hello World");
    return 0;
}
EOT
else
  touch driver.cpp
  cat <<EOT >> driver.cpp
#include <iostream>

int main(int argc, char** argv) {
    std::cout << "Hello World\n";
    return 0;
}
EOT
fi
cd ..

mkdir include
cd include
echo "project ($PROJECT_NAME)" >> CMakeLists.txt 
cd ..

read -p "Would you like to create a new component [y/n]: " NEW_COMP

while [[ $NEW_COMP = "y" ]]
do 
  create_component
  read -p "Would you like to create a new component [y/n]: " NEW_COMP
done

echo ")" >> CMakeLists.txt 

touch run.sh
cat <<EOT >> run.sh
#!/usr/bin/env bash

docker build -t $PROJECT_NAME .
docker run -it --rm $PROJECT_NAME
EOT

chmod u+x run.sh

