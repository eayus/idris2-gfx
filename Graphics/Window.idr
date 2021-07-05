module Graphics.Window

import Graphics.Handle


public export
data API : Type where
    OpenGL : (major : Nat) -> (minor : Nat) -> API


export
record Window (api : API) where
    constructor MkWindow
    winPtr : AnyPtr


export
createWindow : (1 _ : Handle)
            -> (api : API)
            -> (width : Nat)
            -> (height : Nat)
            -> (title : String)
            -> LPair Handle (Window api)
createWindow gfx api width height title = ?createWindow_rhs


export
destroyWindow : (1 _ : Handle) -> (1 _ : Window api) -> Handle
destroyWindow gfx win = ?destroyWindow_rhs
