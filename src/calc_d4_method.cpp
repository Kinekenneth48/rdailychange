#include <Rcpp.h>
using namespace Rcpp;

//' Calculate Day-4 Method
//'
//' @description Takes a numeric vector of daily snow changes, as well as
//'   a logical vector of possible indices to include in the Day-4 method,
//'   and returns the vector of the Day-4 method.
//'
//' @param dx A numeric vector of daily snow changes.
//'
//' @param d4_cands A logical vector of indices associated with dx.
//'   d4_cands(i) is TRUE if and only if dx(i) and dx(i + 3) are positive,
//'   and at most one of dx(i + 1) or dx(i + 2) are negative.
//'
//' @return A numeric vector of the Day-4 method. See details.
//'
//' @section Details:
//' An observation of the Day-4 method consists of the sum of four
//'   consecutive elements of dx, the first and last of which must be
//'   positive, only one negative observation in the middle,
//'   and the sum of the four observations must be positive.
//'   The d4_cands logical vector is TRUE when the first and fourth
//'   observations are positive, and at most one of the second and third
//'   observation is negative. At the indices where d4_cands is TRUE,
//'   this function sums the dx(i), dx(i + 1), dx(i + 2), and dx(i + 3).
//'   If that sum is positive, it is added as a value of the Day-4 method.
//'   The function would then falsify d4_cands(i + 1), d4_cands(i + 2),
//'   and d4_cands(i + 3) as an index of dx can be used in a sum only once.
//'
//' @examples
//' dx <- c(1, -3, 3, 1, 2, 3, 1, -7, 2, -1, -2, 3)
//' d4_cands <- c(TRUE, FALSE, TRUE, TRUE, FALSE,
//'               TRUE, FALSE, FALSE, TRUE)
//' rdailychange:::calc_d4_method(d4_cands, dx)
//'
// [[Rcpp::export]]
NumericVector calc_d4_method(LogicalVector d4_cands,
                             NumericVector dx) {
  int n = 4;
  float sum = 0;
  NumericVector result;
  for (int i = 0; i < (d4_cands.size()-3); i++) {
    if (d4_cands[i] == true) {
       sum = 0;
      for (int j = i; j < i + n; j++) {
        sum += dx[j];
      }
      if (sum > 0) {
        result.push_back(sum);
        for (int j = i + 1; j < i + n; j++) {
          d4_cands[j] = false;
        }
      }
    }
  }
  return result;
}
