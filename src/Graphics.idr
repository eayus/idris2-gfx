module Graphics

import Util.L2Pair
import Util.Nat


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

%foreign "C:SDL_Init,libSDL2"
prim__SDL_Init : Bits32 -> Int

%foreign "C:SDL_Quit,libSDL2"
prim__SDL_Quit : ()

%foreign "C:SDL_GL_SetAttribute,libSDL2"
prim__SDL_GL_SetAttribute : Int -> Int -> Int

%foreign "C:closeRequested,glue"
prim__closeRequested : AnyPtr -> Int


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


export
closeRequested : (1 _ : Window api props) -> LPair (Window api props) Bool
closeRequested (MkWindow winPtr) =
    let b = prim__closeRequested winPtr
    in MkWindow winPtr # if b == 0 then False else True
