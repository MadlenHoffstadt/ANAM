# Adjusted Noise-Augmented Modality detection method (ANAM)

This repo contains the code of the adjusted noise-augmented density-based modality estimation method, initially proposed by Haslbeck and colleagues (2023). 

This function is specifically adapted to categorical variables of large sample size. Original kernel density estimation methods are prone to overfitting under these conditions, detecting a single mode at each ordinal category. Do to the high prevalence of ordinal scales in behavioral & social sciences (e.g., response scales), we propose a noise-augmented method. 

The present method incrementally adds Gaussian noise to the data until the categorical effect can no longer be detected. This is assessed by regressing the the count at histogram bars against the deviation from whole integers. Noise is added until this deviation no longer predicts the count of bars, indicating that observations are no longer mainly clustered around the categorical response variables. 
We then estimate the density of the noise augmented data and derive the number of modes identifying the number of sign reversals in the density's derivative (divided by 2). 

To enhance robustness of results, we suggest applying this method various times and taking the most frequently detected number of modes as the modality estimate. 

### References:
Haslbeck, Jonas, Oisín Ryan, and Fabian Dablander. "Multimodality and skewness in emotion time series." Emotion (2023).
