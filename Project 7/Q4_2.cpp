/*
 * Iterate i from 1 to floor(sqrt(n)).
 * If i divides n, then i is a factor and n/i is the paired factor.
 * Store both factors (avoid duplicates when i*i == n).
 * Sort the collected factors in ascending order before returning.
 */

#include "Q4_2.h"
#include "Q2.h"
#include <algorithm>

std::vector<int> factorize(int n) {
    std::vector<int> answer;
    if (n <= 0) return answer;  // optional: non-positive -> empty
    for (int i = 1; (long long)i * i <= n; ++i) {
        if (n % i == 0) {
            answer.push_back(i);
            int j = n / i;
            if (j != i) answer.push_back(j);
        }
    }
    std::sort(answer.begin(), answer.end()); // print in increasing order
    return answer;
}

void test_factorize() {
    print_vector(factorize(2));
    print_vector(factorize(72));
    print_vector(factorize(196));
}
