module Graphics.Handle


export
data Handle = MkHandle


export
createGraphics : HasIO io => (1 _ : (1 _ : Handle) -> io a) -> io a
createGraphics cont = ?createGraphics_rhs


export
destroyGraphics : HasIO io => (1 _ : Handle) -> io a
destroyGraphics MkHandle = ?destroyGraphics_rhs_1
