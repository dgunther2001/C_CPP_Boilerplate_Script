### General Purpose C/CPP Project Boilerplate Generator
Utilizes **CMake** and **Docker**, so make sure you have those installed and enabled.  

#### How to Use
- Clone the repo: `git clone https://github.com/dgunther2001/C_CPP_Boilerplate_Script`  
- Move `c_cpp_boilerplate_gen.sh` into the directory you want to create your project.  
- Update permissions: `chmod u+x c_cpp_boilerplate_gen.sh`  
- Run the script! `./c_cpp_boilerplate_gen.sh`  
    - You will be prompted to specify whether it is a C or CPP project ["y" = C; any other value = C++]  
    - You will then need to specify a name. It can be whatever you want, and even ensures that you won't accidntally overwrite existing directories!  
    - You will then be prompted to create as many components as you want ["y" = create a new component; any other value = end script]  
- Enter the new directory created by the script.
- To execute the new project, simply run: `./run.sh`, which will spin up and run the docker container.

I hope you get a lot of use out of this, and are able to avoid the cumbersome process of CMake and Docker Boilerplate Code!  

**Note:** This will only work on **Unix** based systems. Sorry Windows users who don't use **WSL**.