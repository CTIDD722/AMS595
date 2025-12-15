#include "Q1.h"
#include "Q2.h"
#include "Q3.h"
#include "Q4_1.h"
#include "Q4_2.h"
#include "Q4_3.h"
#include "Q5.h"

#include <iostream>
#include <vector>

int main() {

    std::cout << "---\n";
    std::cout << "Problem 1\n"; // number recognizer
    std::cout << "---\n";
    runQ1();

    std::cout << "\n---\n";
    std::cout << "Problem 2\n"; // vector printer
    std::cout << "---\n";
    std::vector<int> v1 = {1, 2, 3, 10}; // please put you own vector here
    std::vector<int> v2 = {-1, 0, 5};
    std::cout << "v1 = "; print_vector(v1);
    std::cout << "v2 = "; print_vector(v2);

    std::cout << "\n---\n";
    std::cout << "Problem 3\n"; // print fibonacci <= 4,000,000
    std::cout << "---\n";
    computeF();

    std::cout << "\n---\n";
    std::cout << "Problem 4.1\n"; // is prime
    std::cout << "---\n";
    test_isprime();

    std::cout << "\n---\n";
    std::cout << "Problem 4.2\n"; // find factor
    std::cout << "---\n";
    test_factorize();

    std::cout << "\n---\n";
    std::cout << "Problem 4.3\n"; // find prime factor
    std::cout << "---\n";
    test_prime_factorize();


    std::cout << "\n---\n";
    std::cout << "Problem 5\n"; // print n pascals triangle
    std::cout << "---\n";
    int n;
    std::cout << "Enter n: ";
    std::cin >> n;
    pascals_triangle(n);

    return 0;
}
