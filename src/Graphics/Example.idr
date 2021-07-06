module Graphics.Example

import Graphics
import Graphics.GL.Basics
import Util.L2Pair

(>>=) : (1 _ : IO a) -> (1 _ : a -> IO b) -> IO b
(>>=) = io_bind


nextColor : (Double, Double, Double, Double) -> (Double, Double, Double, Double)
nextColor (r, g, b, a) = (if r > 0.99 then 0.0 else r + 0.01, if g > 0.993 then 0.0 else g + 0.007, if b > 0.995 then 0.0 else b + 0.005, a)


mainLoop : (1 _ : Window OpenGL (Just id))
        -> (1 _ : GLContext id)
        -> (col : (Double, Double, Double, Double))
        -> LPair (Window OpenGL (Just id)) (GLContext id)
mainLoop win ctx (r, g, b, a) =
    let win # closeReq = closeRequested win
    in  if closeReq
           then win # ctx
           else let ctx = glClearColor ctx r g b a
                    ctx = glClear ctx
                    win # ctx = swapBuffers win ctx
                in mainLoop win ctx (nextColor (r, g, b, a))


main : IO ()
main = createGraphics $ \gfx => do
           let gfx # win = createWindow gfx OpenGL 960 640 "Title!"
           let ctxID ~~ win # ctx = createGLContext win

           let win # ctx = mainLoop win ctx (0.0, 0.5, 1.0, 1.0)

           let gfx = destroyGLContext gfx ctx
           let gfx = destroyWindow gfx win
           destroyGraphics gfx
