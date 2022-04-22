/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				HuskyRye
**
** DATE:        2020-08-23
**
**************************************************************************/

#include "imageloader.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

// Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color* evaluateOnePixel(Image* image, int row, int col)
{
    Color* color = image->image[row * image->cols + col];
    Color* result = (Color*)malloc(sizeof(Color));
    result->R = result->G = result->B = (color->B & 0b00000001) ? 255 : 0;
    return result;
}

// Given an image, creates a new image extracting the LSB of the B channel.
Image* steganography(Image* image)
{
    Image* result = (Image*)malloc(sizeof(Image));
    result->rows = image->rows;
    result->cols = image->cols;
    result->image = (Color**)malloc(result->rows * result->cols * sizeof(Color*));
    for (uint32_t i = 0; i < image->rows; ++i) {
        for (uint32_t j = 0; j < image->cols; ++j) {
            result->image[i * image->cols + j] = evaluateOnePixel(image, i, j);
        }
    }
    return result;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image,
where each pixel is black if the LSB of the B channel is 0,
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char** argv)
{
    Image* image = readData(argv[1]);
    Image* secreat = steganography(image);
    writeData(secreat);
    freeImage(image);
    freeImage(secreat);
}
