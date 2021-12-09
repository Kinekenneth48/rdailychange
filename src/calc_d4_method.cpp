#include <Rcpp.h>
using namespace Rcpp;

// This is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp
// function (or via the Source button on the editor toolbar). Learn
// more about Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//   http://gallery.rcpp.org/
//

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
