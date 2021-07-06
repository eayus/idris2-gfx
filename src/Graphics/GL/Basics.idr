module Graphics.GL.Basics

import Graphics


-- Raw Bindings

%foreign "C:SDL_GL_SwapWindow,libSDL2"
prim__SDL_SwapWindow : AnyPtr -> ()


-- High Level

export
swapBuffers : (1 _ : Window OpenGL (Just id))
           -> (1 _ : GLContext id)
           -> LPair (Window OpenGL (Just id)) (GLContext id)
swapBuffers (MkWindow winPtr) ctx =
    let _ = prim__SDL_SwapWindow winPtr
    in  MkWindow winPtr # ctx
