/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				HuskyRye
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include "imageloader.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Opens a .ppm P3 image file, and constructs an Image object.
// You may find the function fscanf useful.
// Make sure that you close the file with fclose before returning.
Image* readData(char* filename)
{
    FILE* fp = fopen(filename, "r");
    char buf[3];
    fscanf(fp, "%s", buf);

    Image* image = (Image*)malloc(sizeof(Image));
    fscanf(fp, "%" SCNu32 "%" SCNu32, &(image->cols), &(image->rows));
    image->image = (Color**)malloc(image->rows * image->cols * sizeof(Color*));

    uint8_t scale;
    fscanf(fp, "%" SCNu8, &scale);

    for (uint32_t i = 0; i < image->rows; ++i) {
        for (uint32_t j = 0; j < image->cols; ++j) {
            Color* color = (Color*)malloc(sizeof(Color));
            fscanf(fp, "%" SCNu8 "%" SCNu8 "%" SCNu8, &(color->R), &(color->G), &(color->B));
            image->image[i * image->cols + j] = color;
        }
    }

    fclose(fp);
    return image;
}

// Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image* image)
{
    printf("P3\n");
    printf("%" SCNu32 " %" SCNu32 "\n", image->cols, image->rows);
    printf("255\n");
    for (uint32_t i = 0; i < image->rows; ++i) {
        for (uint32_t j = 0; j < image->cols; ++j) {
            Color* color = image->image[i * image->cols + j];
            if (j == 0)
                printf("%3" SCNu8 " %3" SCNu8 " %3" SCNu8, color->R, color->G, color->B);
            else
                printf("   %3" SCNu8 " %3" SCNu8 " %3" SCNu8, color->R, color->G, color->B);
        }
        printf("\n");
    }
}

// Frees an image
void freeImage(Image* image)
{
    for (uint32_t i = 0; i < image->rows * image->cols; ++i)
        free(image->image[i]);
    free(image->image);
    free(image);
}
