all:
	idris2 --build idris2-gfx.ipkg
	build/exec/graphics-test

glue: glue/glue.c
	gcc glue/glue.c -shared -o glue/glue.so -lGL -lSDL2
