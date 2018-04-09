#ifndef IMSHOW_H_
#define IMSHOW_H_

#include <stdint.h>

#ifdef __cplusplus
extern "C"
{
#endif

int
imshow_init(int num_args, char *args[]);

void
imshow_quit();

uint32_t *
imshow_get_next_image(int *width, int *height);

uint32_t *
imshow_get_prev_image(int *width, int *height);

#ifdef __cplusplus
}
#endif

#endif /* end of include guard: IMSHOW_H_ */

