module Graphics.GL.Context


export
data GLContextID = MkGLContextID


export
data GLContext : (id : GLContextID) -> Type where
    MkGLContext : GLContext id
