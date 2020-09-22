window = glc_CreateWindow({height: 640, aspectRatio: 3/2});
glc_SetWindow(window);

camera = glc_CreateCamera({height: 320, aspectRatio: 3/2});
glc_SetCamera(0, camera);

show_debug_overlay(true);