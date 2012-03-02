# To compile this software install the following dependencies on Ubuntu 11.10
# sudo apt-get install valac freeglut3 freeglut3-dev libxi-dev libxi6 libxmu-dev libxi6 libxmu-dev libxmu6 libsdl1.2debian-all libsdl1.2-dev libsdl-image1.2-dev libsdl-image1.2

valac --vapidir=vapi/ --pkg sdl --pkg sdl-image --pkg gl --pkg glu --pkg glut -X -lSDL -X -lSDL_image -X -lglut src/main.vala src/scene.vala src/values.vala src/io.vala src/image.vala --Xcc=-I/usr/include/SDL
