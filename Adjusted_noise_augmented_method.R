####  Adjustment of noise-augmented density based modality detection method  #####
#                 (originally proposed by Haslbeck et al., 2023)               # 
################################################################################

# ANAM function (adjusted noise-augmented method for modality detection for ordinal scales)
# Parameters:
#   X: Numeric vector representing the data whose modality is to be estimated.
#   adjust: A numeric value used to adjust the smoothness of the density estimate.
#           Higher values make the density estimate smoother. Default is 3.
#   n: The number of equally spaced points at which the density is to be estimated.
#      Default is 256.
#
# Returns:
#   A list containing the estimated modality ('M'), density estimate x values ('den_x'),
#   density estimate y values ('den_y'), and the final noise level ('noise') applied to the data.

anam <- function(X, adjust = 3, n = 256) {
  p_value = 0
  noise = .01 # initial noise level 
  
  # iteratively increase noise level until categories are sufficiently smoothed out
  while(p_value < .1){
    noise <- noise + .1  # increment noise level
    
    # augment data with normally distributed noise and estimate its density
    Xn <- X + rnorm(length(X), 0, noise) 
    den <- density(Xn, bw="SJ", adjust=adjust, n=n)
    
    # Analyze the smoothed data to check for sufficient smoothing.
    # This involves regressing the count at histogram bars against the deviation from whole integers.
    k = 5 # factor to control histogram breaks 
    h <- hist(Xn, breaks = length(Xn)/k, plot=F)
    while(var(abs(h$mids - round(h$mids))) == 0 & k > 0){ # ensure non-zero variance 
      k = k - 1
      h=hist(Xn, breaks = length(Xn)/k, plot=F)
    }
    summ=summary(lm(h$counts ~ abs(h$mids - round(h$mids)))) # linear model 
    # If insufficient data for regression, set p_value to exit loop; else, update p-value
    if(nrow(summ$coefficients)<=1) p_value=.1 else p_value=summ$coefficients[2,4] 
  }
  
  # Estimate modality by identifying the number of sign reversals in the density's derivative
  ni <- length(den$y) 
  diff <- den$y[-ni] - den$y[-1]
  sign_reversals <- sign(diff[-(ni-1)]) != sign(diff[-1])
  Nrev <- sum(sign_reversals)
  Modality <- ceiling(Nrev/2) # Estimate modality as half the number of sign reversals
  
  # Return estimated modality, density estimates, and final noise level
  outlist <- list("M" = Modality,
                  "den_x" = den$x,
                  "den_y" = den$y,
                  "noise" = noise)
  return(outlist)
}

