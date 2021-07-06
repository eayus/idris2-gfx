module Graphics.Window

import Graphics.Handle
import Util.L2Pair
import Util.Nat


-- Raw Bindings

SDL_WINDOWPOS_CENTERED : Int
SDL_WINDOWPOS_CENTERED = 0x2FFF0000

SDL_WINDOW_OPENGL : Bits32
SDL_WINDOW_OPENGL = 0x00000002

%foreign "C:SDL_CreateWindow,libSDL2"
prim__SDL_CreateWindow : String -> Int -> Int -> Int -> Int -> Bits32 -> AnyPtr

%foreign "C:SDL_DestroyWindow,libSDL2"
prim__SDL_DestroyWindow : AnyPtr -> ()

%foreign "C:SDL_GL_CreateContext,libSDL2"
prim__SDL_GL_CreateContext : AnyPtr -> AnyPtr

%foreign "C:SDL_GL_DeleteContext,libSDL2"
prim__SDL_GL_DeleteContext : AnyPtr -> ()


-- High Level

export
data GLContextID = MkGLContextID


export
data GLContext : (id : GLContextID) -> Type where
    MkGLContext : AnyPtr -> GLContext id


public export
data API : Type where
    OpenGL : API -- Fixed at version 3.3


public export
WindowState : API -> Type
WindowState OpenGL = Maybe GLContextID


export
record Window (0 api : API) (0 state : WindowState api) where
    constructor MkWindow
    winPtr : AnyPtr


public export
defaultWindowState : (api : API) -> WindowState api
defaultWindowState OpenGL = Nothing


export
createWindow : (1 _ : Handle)
            -> (api : API)
            -> (width : Nat)
            -> (height : Nat)
            -> (title : String)
            -> LPair Handle (Window api (defaultWindowState api))
createWindow gfx OpenGL width height title =
    let winPtr = prim__SDL_CreateWindow title SDL_WINDOWPOS_CENTERED SDL_WINDOWPOS_CENTERED (natToInt width) (natToInt height) SDL_WINDOW_OPENGL
    in  gfx # MkWindow winPtr


export
destroyWindow : (1 _ : Handle) -> (1 _ : Window api state) -> Handle
destroyWindow gfx (MkWindow winPtr) =
    let _ = prim__SDL_DestroyWindow winPtr
    in  gfx


export
createGLContext : (1 _ : Window OpenGL Nothing) -> L2Pair GLContextID (\id => LPair (Window OpenGL (Just id)) (GLContext id))
createGLContext (MkWindow winPtr) =
    let ctxPtr = prim__SDL_GL_CreateContext winPtr
    in MkGLContextID ~~ (MkWindow winPtr) # (MkGLContext ctxPtr)


export
destroyGLContext : (1 _ : Handle) -> (1 _ : GLContext id) -> Handle
destroyGLContext gfx (MkGLContext ctxPtr) =
    let _ = prim__SDL_GL_DeleteContext ctxPtr
    in gfx
