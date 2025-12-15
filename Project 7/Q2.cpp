/*
 * Print the opening bracket '['.
 * Loop through all elements in v:
 *    print v[i]
 *    if not the last element, print ", " as a separator
 */


#include "Q2.h"
#include <iostream>

void print_vector(std::vector<int> v) {
    std::cout << "[";
    for (size_t i = 0; i < v.size(); ++i) {
        std::cout << v[i];
        if (i + 1 < v.size()) std::cout << ", ";
    }
    std::cout << "]" << std::endl;
}
