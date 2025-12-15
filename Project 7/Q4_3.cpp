/*
 * If n <= 1, return an empty vector.
 * If 2 divides n, record 2 once and divide out all factors of 2.
 * For odd to sqrt(n): if p divides n, record p once and divide out all factors of p.
 * for each prime factor, we only record once
 */

#include "Q4_3.h"
#include "Q2.h"

std::vector<int> prime_factorize(int n) {
    std::vector<int> answer;
    if (n <= 1) return answer;

    // factor out 2x
    if (n % 2 == 0) {
        answer.push_back(2);
        while (n % 2 == 0) n /= 2;
    }

    // factor out odd primes
    for (int p = 3; (long long)p * p <= n; p += 2) {
        if (n % p == 0) {
            answer.push_back(p);
            while (n % p == 0) n /= p;
        }
    }
    if (n > 1) answer.push_back(n);
    return answer;
}

void test_prime_factorize() {
    print_vector(prime_factorize(2));
    print_vector(prime_factorize(72));
    print_vector(prime_factorize(196));
}
