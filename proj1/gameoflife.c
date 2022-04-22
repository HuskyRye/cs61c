/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				HuskyRye
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include "imageloader.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

// Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
// Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
// and the left column as adjacent to the right column.
Color* evaluateOneCell(Image* image, int row, int col, uint32_t rule)
{
    int rows = image->rows;
    int cols = image->cols;

    Color* center = image->image[row * cols + col];
    Color* left = image->image[row * cols + (col - 1 + cols) % cols];
    Color* right = image->image[row * cols + (col + 1) % cols];
    Color* top = image->image[(row - 1 + rows) % rows * cols + col];
    Color* bottom = image->image[(row + 1) % rows * cols + col];
    Color* top_left = image->image[(row - 1 + rows) % rows * cols + (col - 1 + cols) % cols];
    Color* top_right = image->image[(row - 1 + rows) % rows * cols + (col + 1) % cols];
    Color* bottom_left = image->image[(row + 1) % rows * cols + (col - 1 + cols) % cols];
    Color* bottom_right = image->image[(row + 1) % rows * cols + (col + 1) % cols];
    Color* result = (Color*)malloc(sizeof(Color));
    for (int i = 0; i < 3; ++i) {
        ((uint8_t*)result)[i] = 0;
        for (int j = 0; j < 8; ++j) {
            uint8_t alive_neighbors = ((((uint8_t*)left)[i] >> j) & 1)
                + ((((uint8_t*)right)[i] >> j) & 1)
                + ((((uint8_t*)top)[i] >> j) & 1)
                + ((((uint8_t*)bottom)[i] >> j) & 1)
                + ((((uint8_t*)top_left)[i] >> j) & 1)
                + ((((uint8_t*)top_right)[i] >> j) & 1)
                + ((((uint8_t*)bottom_left)[i] >> j) & 1)
                + ((((uint8_t*)bottom_right)[i] >> j) & 1);
            uint8_t alive = (((uint8_t*)center)[i] >> j) & 1;
            uint8_t next_state = (rule >> (alive_neighbors + 9 * alive)) & 1;
            ((uint8_t*)result)[i] |= (next_state << j);
        }
    }
    return result;
}

// The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
// You should be able to copy most of this from steganography.c
Image* life(Image* image, uint32_t rule)
{
    Image* result = (Image*)malloc(sizeof(Image));
    result->rows = image->rows;
    result->cols = image->cols;
    result->image = (Color**)malloc(result->rows * result->cols * sizeof(Color*));
    for (uint32_t i = 0; i < image->rows; ++i) {
        for (uint32_t j = 0; j < image->cols; ++j) {
            result->image[i * image->cols + j] = evaluateOneCell(image, i, j, rule);
        }
    }
    return result;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char** argv)
{
    if (argc != 3) {
        printf("    usage: ./gameOfLife filename rule\n");
        printf("    filename is an ASCII PPM file (type P3) with maximum value 255.\n");
        printf("    rule is a hex number beginning with 0x; Life is 0x1808.\n");
        return -1;
    }
    Image* image = readData(argv[1]);
    uint32_t rule = strtol(argv[2], NULL, 16);
    Image* result = life(image, rule);
    writeData(result);
    freeImage(image);
    freeImage(result);
    return 0;
}
