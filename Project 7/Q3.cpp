/*
 * Initialize a = 1 and b = 2.
 * While a <= 4,000,000:
 *   Print a (with commas between terms).
 *   Compute next = a + b.
 *   Shift forward: a = b, b = next.
 */


#include "Q3.h"
#include <iostream>

void computeF() {
    const long long LIMIT = 4000000;
    long long a = 1, b = 2; // since it starts with 1 and 2
    bool first = true;
    while (a <= LIMIT) {
        if (!first) std::cout << ", ";
        std::cout << a;
        first = false;
        long long next = a + b;
        a = b;
        b = next;
    }
    std::cout << std::endl;
}
