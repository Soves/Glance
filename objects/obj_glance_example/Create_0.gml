window = glc_CreateWindow({height: 720, aspectRatio: 16/9});
glc_SetWindow(window);

window.setFullscreen(true).update();

camera = glc_CreateCamera({height: 720, aspectRatio: 16/9, strict: false});
glc_SetCamera(0, camera);
