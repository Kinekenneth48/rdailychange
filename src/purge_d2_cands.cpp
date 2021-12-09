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
LogicalVector purge_d2_cands(LogicalVector d2_cands) {
  int skip = 1;
  for (int i = 0; i < (d2_cands.size()-1); i++) {
    if (d2_cands[i] == true) {
      d2_cands[i + skip] = false;
    }
  }
  return d2_cands;
}



