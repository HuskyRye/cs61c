#include "lfsr.h"

void lfsr_calculate(uint16_t* reg)
{
    uint16_t x = *reg;
    x = ((x >> 0) ^ (x >> 2) ^ (x >> 3) ^ (x >> 5)) & 1;
    *reg >>= 1;
    *reg |= x << 15;
}
