#include <GL/glew.h>

void glue_glClear(int mask) {
	glClear((GLbitfield) mask);
}
