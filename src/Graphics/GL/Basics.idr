module Graphics.GL.Basics

import Graphics


-- Raw Bindings

GL_COLOR_BUFFER_BIT : Int
GL_COLOR_BUFFER_BIT = 0x00004000

%foreign "C:SDL_GL_SwapWindow,libSDL2"
prim__SDL_SwapWindow : AnyPtr -> ()

%foreign "C:glue_glClear,glue"
prim__glClear : Int -> ()

%foreign "C:glue_glClearColor,glue"
prim__glClearColor : Double -> Double -> Double -> Double -> ()


-- High Level

export
swapBuffers : (1 _ : Window OpenGL (Just id))
           -> (1 _ : GLContext id)
           -> LPair (Window OpenGL (Just id)) (GLContext id)
swapBuffers (MkWindow winPtr) ctx =
    let _ = prim__SDL_SwapWindow winPtr
    in  MkWindow winPtr # ctx


export
glClear : (1 _ : GLContext id) -> GLContext id
glClear ctx =
    let _ = prim__glClear GL_COLOR_BUFFER_BIT
    in  ctx


export
glClearColor : (1 _ : GLContext id) -> Double -> Double -> Double -> Double -> GLContext id
glClearColor ctx r g b a =
    let _ = prim__glClearColor r g b a
    in  ctx
