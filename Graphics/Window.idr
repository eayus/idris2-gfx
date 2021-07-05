module Graphics.Window

import Graphics.Handle
import Graphics.GL.Context
import Util.L2Pair


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
createWindow gfx api width height title = ?createWindow_rhs


export
destroyWindow : (1 _ : Handle) -> (1 _ : Window api state) -> Handle
destroyWindow gfx win = ?destroyWindow_rhs


export
createGLContext : (1 _ : Window OpenGL Nothing) -> L2Pair GLContextID (\id => LPair (Window OpenGL (Just id)) (GLContext id))


export
destroyGLContext : (1 _ : Handle) -> (1 _ : GLContext id) -> Handle
