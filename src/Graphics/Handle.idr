module Graphics.Handle


-- Raw Bindings

SDL_INIT_VIDEO : Bits32
SDL_INIT_VIDEO = 0x00000020

SDL_GL_CONTEXT_MAJOR_VERSION : Int
SDL_GL_CONTEXT_MAJOR_VERSION = 17

SDL_GL_CONTEXT_MINOR_VERSION : Int
SDL_GL_CONTEXT_MINOR_VERSION = 18

SDL_GL_CONTEXT_PROFILE_MASK : Int
SDL_GL_CONTEXT_PROFILE_MASK = 21

SDL_GL_CONTEXT_PROFILE_CORE : Int
SDL_GL_CONTEXT_PROFILE_CORE = 1


%foreign "C:SDL_Init,libSDL2"
prim__SDL_Init : Bits32 -> Int

%foreign "C:SDL_Quit,libSDL2"
prim__SDL_Quit : ()

%foreign "C:SDL_GL_SetAttribute,libSDL2"
prim__SDL_GL_SetAttribute : Int -> Int -> Int


-- High level


export
data Handle = MkHandle


export
createGraphics : HasIO io => (1 _ : (1 _ : Handle) -> io a) -> io a
createGraphics cont = let _ = prim__SDL_Init SDL_INIT_VIDEO
                          _ = prim__SDL_GL_SetAttribute SDL_GL_CONTEXT_MAJOR_VERSION 3
                          _ = prim__SDL_GL_SetAttribute SDL_GL_CONTEXT_MINOR_VERSION 3
                          _ = prim__SDL_GL_SetAttribute SDL_GL_CONTEXT_PROFILE_MASK SDL_GL_CONTEXT_PROFILE_CORE
                      in cont MkHandle


export
destroyGraphics : HasIO io => (1 _ : Handle) -> io ()
destroyGraphics MkHandle = pure prim__SDL_Quit
