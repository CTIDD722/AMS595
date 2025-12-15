/*
 * Read integer n.
 * switch(n):
 *    case -1 -> print "negative one"
 *    case  0 -> print "zero"
 *    case  1 -> print "positive one"
 *    default -> print "other value"
 * Use break after each case to prevent fall-through.
 */

#include <iostream>
#include "Q1.h"

void runQ1() {
    int n;
    std::cout << "Enter a number: ";
    std::cin >> n;

    switch (n) {
        case -1: std::cout << "negative one\n"; break;
        case 0:  std::cout << "zero\n"; break;
        case 1:  std::cout << "positive one\n"; break;
        default: std::cout << "other value\n"; break;
    }
}
