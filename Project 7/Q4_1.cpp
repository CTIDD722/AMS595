/*
 * Return false for n <= 1 (not prime by definition).
 * Handle n == 2 as prime.
 * Eliminate even numbers greater than 2.
 * For odd n > 2, test divisibility by odd integers
 */

#include "Q4_1.h"
#include <iostream>

bool isprime(int n) {
    bool result;
    if (n <= 1) {
        result = false;
    } else if (n == 2) {
        result = true;
    } else if (n % 2 == 0) {
        result = false;
    } else {
        result = true;
        for (int i = 3; (long long)i * i <= n; i += 2) {
            if (n % i == 0) {
                result = false;
                break;
            }
        }
    }
    return result;
}

void test_isprime() {
    std::cout << "isprime(2) = "  << isprime(2)  << "\n";
    std::cout << "isprime(10) = " << isprime(10) << "\n";
    std::cout << "isprime(17) = " << isprime(17) << "\n";
}

