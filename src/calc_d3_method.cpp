#include <Rcpp.h>
using namespace Rcpp;

//' Calculate Day-3 Method
//'
//' @description Takes a numeric vector of daily snow changes, as well as
//'   a logical vector of possible indices to include in the Day-3 method,
//'   and returns the vector of the Day-3 method.
//'
//' @param dx A numeric vector of daily snow changes.
//'
//' @param d3_cands A logical vector of indices associated with dx.
//'   d3_cands(i) is TRUE if and only if dx(i) and dx(i + 2) are positive.
//'
//' @return A numeric vector of the Day-3 method. See details.
//'
//' @section Details:
//' An observation of the Day-3 method consists of the sum of three
//'   consecutive elements of dx, the first and last of which must be
//'   positive, and the sum of the three observations must be positive.
//'   The d3_cands logical vector is TRUE when the first and third
//'   observations are positive. At the indices where d3_cands is TRUE,
//'   this function sums the dx(i), dx(i + 1), and dx(i + 2). If that sum
//'   is positive, it is added as a value of the Day-3 method.
//'   The function would then falsify d3_cands(i + 1) and d3_cands(i + 2)
//'   as an index of dx can be used in a sum only once.
//'
//' @examples
//' dx <- c(1, -3, 3, 1, 2, 3, 1, -7, 2, -1, -2, 3)
//' d3_cands <- c(TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE,
//'  FALSE)
//' rdailychange:::calc_d3_method(d3_cands, dx)
//'
// [[Rcpp::export]]
NumericVector calc_d3_method(LogicalVector d3_cands,
                             NumericVector dx) {
  int n = 3;
  float sum = 0;
  NumericVector result;
  for (int i = 0; i < (d3_cands.size()-2); i++) {
    if (d3_cands[i] == true) {
      sum = 0;
      for (int j = i; j < i + n; j++) {
        sum += dx[j];
      }
      if (sum > 0) {
        result.push_back(sum);
        for (int j = i + 1; j < i + n; j++) {
          d3_cands[j] = false;
        }
      }
    }
  }
  return result;
}
