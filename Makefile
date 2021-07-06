all:
	idris2 --build idris2-gfx.ipkg
	build/exec/graphics-test
