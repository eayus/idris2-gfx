module Graphics.Example

import Graphics.Window
import Graphics.Handle
import Graphics.GL.Context
import Util.L2Pair


main : IO ()
main = createGraphics $ \gfx =>
       let gfx # win = createWindow gfx OpenGL 960 640 "Title!"
           ctxID ~~ win # ctx = createGLContext win
           gfx = destroyGLContext gfx ctx
           gfx = destroyWindow gfx win
       in  destroyGraphics gfx
