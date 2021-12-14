#include <Rcpp.h>
using namespace Rcpp;

//' Get Indices For Day-2 Method
//'
//' @description Takes a logical vector of possible indices to sum for the
//'   Day-2 method, and cleans it to the exact indices to sum for
//'   the Day-2 method. See Details below for more information.
//'
//' @param d2_cands A logical vector of indices associated with the vector of
//'   daily snow change observations, dx. d2_cands(i) is TRUE if and only
//'   if dx(i) and dx(i + 1) are positive.
//'
//' @return A logical vector, where TRUE indicates that that index
//'   is to be summed with the following index for the Day-2 method vector dx.
//'   As described, an index cannot be used twice. As such, there should
//'   be no two consecutive TRUE values.
//'
//' @section Details:
//' Given a vector of snow changes, dx, the Day-2 method needs to sum
//'   consecutive positive values. But once an index is part of a sum
//'   it cannot be used again. As such d2_cands is the logical
//'   vector where an index is TRUE if dx(i) and dx(i + 1) are both
//'   positive. Because an index cannot be used in multiple sums
//'   this function falsifies indices that follow TRUEs in the d2_cands
//'   logical vector.
//'
//' @examples
//' d2_cands <- c(TRUE, FALSE, TRUE, TRUE, TRUE, TRUE,
//'               TRUE, FALSE, TRUE, TRUE, FALSE)
//' purge_d2_cands(d2_cands)
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



