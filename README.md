##fastWinnow

This is a simple impelementation of the [Winnow Algorithm](http://en.wikipedia.org/wiki/Winnow_\(algorithm\)) in R and C++. I looked for and implementation on CRAN and couldn't find one. My use case was for binary classification so it will only accept a classification vector of 0/1. 

Winnow is a classic algorithm, great for learning simple disjunctions and can help in weeding out irrelavant features in large feature space. 

fastWinnow is the direct Cpp function and takes a matrix of training data and the classification vector.
trainFastWinnow is a simple wrapper to relabel the weight vector with column names.

Again this was built with a very specific use case in mind. You may want to tweak the threshold and learningRate in the Cpp code.

###Requires Packages
* [Rcpp](http://dirk.eddelbuettel.com/code/rcpp.html)
* [RcppArmadillo](http://dirk.eddelbuettel.com/code/rcpp.armadillo.html)
* [inline](http://cran.r-project.org/web/packages/inline/index.html)
