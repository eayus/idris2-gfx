module Graphics.Example

import Graphics
import Graphics.GL.Basics
import Util.L2Pair

(>>=) : (1 _ : IO a) -> (1 _ : a -> IO b) -> IO b
(>>=) = io_bind


wait : IO ()
wait = wait


main : IO ()
main = createGraphics $ \gfx => do
           let gfx # win = createWindow gfx OpenGL 960 640 "Title!"
           let ctxID ~~ win # ctx = createGLContext win
           let ctx = glClear ctx
           let win # ctx = swapBuffers win ctx
           wait
           let gfx = destroyGLContext gfx ctx
           let gfx = destroyWindow gfx win
           destroyGraphics gfx
