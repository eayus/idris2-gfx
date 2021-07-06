#include <GL/glew.h>
#include <SDL2/SDL.h>

void glue_glClear(int mask) {
	glClear((GLbitfield) mask);
}

void glue_glClearColor(double red, double green, double blue, double alpha) {
	glClearColor((GLclampf)red, (GLclampf)green, (GLclampf)blue, (GLclampf)alpha);
}


int closeRequested(SDL_Window* win) {
	SDL_Event event;

	while (SDL_PollEvent(&event)) {
		if (event.type == SDL_QUIT) {
			return 1;
		}
	}

	return 0;
}
