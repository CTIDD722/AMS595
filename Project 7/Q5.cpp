/*
 * If n <= 0, do nothing.
 * For each row index:
 *    1) Create a new vector 'next' of length i+1, initialized to 1.
 *    2) For interior positions j: next[j] = row[j-1] + row[j]
 *    3) Assign row = next and print row elements separated by spaces.
 */

#include "Q5.h"
#include <iostream>
#include <vector>

void pascals_triangle(int n) {
    if (n <= 0) return;
    std::vector<long long> row;
    for (int i = 0; i < n; ++i) {
        std::vector<long long> next(i + 1, 1);  // edges
        for (int j = 1; j < i; ++j) {
            next[j] = row[j - 1] + row[j];      // Pascal rule
        }
        row = next;
        for (size_t k = 0; k < row.size(); ++k) {
            std::cout << row[k];
            if (k + 1 < row.size()) std::cout << " ";
        }
        std::cout << "\n";
    }
}
