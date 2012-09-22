suppressPackageStartupMessages(require("Rcpp")  )
suppressPackageStartupMessages(require("RcppArmadillo"))
suppressPackageStartupMessages(require("inline"))


code <- 
  'using namespace Rcpp;
  using namespace arma;
  mat X = as<mat>(mX);
  Rcpp::NumericVector z = Rcpp::NumericVector(zs);
  
  float threshold = X.n_cols/4;
  float learningRate = 2.5;
  double b ;
  int n = X.n_rows;
  int c = X.n_cols;
  vec out = randu<vec>(X.n_cols);
  out.ones();
  rowvec weightVector =  conv_to< rowvec >::from(out.t());

  for(int i = 0; i < n; i++)
  {
      b = accu(X.row(i) % weightVector);
  
      if (b > threshold & z(i) == 0 )
      {
      //std::cout << "Demotion step" << threshold << " :";
           for(int j = 0; j < c; j++)
           {
               // std::cout << "Demotion step - loop";
                   if(X(i,j) == 1 )
                   {
                     weightVector(j) =  weightVector(j) / 2;
                   }
           }
      }
      else if(b < threshold & z(i) == 1 )
      {
     // std::cout << "Promotion step";
          for(int j = 0; j < c; j++)
          {
          //std::cout << "Fied " << X(i,j) <<" :  "<< j << "  --";
              if(  X(i,j) == 1 )
              {
                weightVector(j) =  weightVector(j) * learningRate;
              }
          }
      }
  //std::cout << "In loop" << b <<" : ";
  }


  return Rcpp::List::create(Rcpp::Named("weightVector")=weightVector,
                            Rcpp::Named("threshold")=threshold);
    ;'
  
   fastWinnow <- cxxfunction(signature(mX="numeric", zs="numeric"),
                     body=code, plugin="RcppArmadillo")
  
  

trainFastWinnow <- function (newData, classification) {
  winnowOut<- fastWinnow(newData, classification)
  dimnames(winnowOut$weightVector)[[2]] <- dimnames(as(newData, "matrix"))[[2]]
  winnowOut$weightVector<-winnowOut$weightVector[1,]
  
  
  out <-data.frame(name =   names(which(winnowOut$weightVector != 1))  , importance = winnowOut$weightVector[winnowOut$weightVector != 1], stringsAsFactors=FALSE)
  winnowOut$variableImp<- out[order(-out$importance),]

  return(winnowOut)

}



