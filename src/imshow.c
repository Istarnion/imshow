#include "imshow.h"

#include <stdlib.h>
#include <stdio.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

typedef struct
{
    int width;
    int height;
    uint32_t *pixels;
} image;

static image *images;
static int num_images;
static int current_image;

#ifdef __cplusplus
extern "C"
{
#endif

int
imshow_init(int num_args, char *args[])
{
    if(num_args <= 1) return 0;

    images = (image *)malloc((num_args - 1) * sizeof(image));

    for(int i=1; i<num_args; ++i)
    {
        image *img = &images[num_images];
        img->pixels = (uint32_t *)stbi_load(args[i], &(img->width), &(img->height), NULL, 4);
        if(img->pixels)
        {
            ++num_images;
        }
        else
        {
            printf("Failed to load image %s\n", args[i]);
        }
    }

    current_image = num_images;

    return num_images;
}

void
imshow_quit()
{
    for(int i=0; i<num_images; ++i)
    {
        free(images[i].pixels);
    }

    free(images);
    images = NULL;
}

uint32_t *
imshow_get_next_image(int *width, int *height)
{
    if(num_images)
    {
        if((++current_image) >= num_images)
        {
            current_image = 0;
        }

        image *i = &images[current_image];

        *width = i->width;
        *height = i->height;
        return i->pixels;
    }
    else return NULL;
}

uint32_t *
imshow_get_prev_image(int *width, int *height)
{
    if(num_images)
    {
        if((--current_image) < 0)
        {
            current_image = num_images-1;
        }

        image *i = &images[current_image];

        *width = i->width;
        *height = i->height;
        return i->pixels;
    }
    else return NULL;
}

#ifdef __cplusplus
}
#endif

