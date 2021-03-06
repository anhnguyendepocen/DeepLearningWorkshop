Session 1, part II: Exercise - Simple Artificial Neural Network in Base R
================

Simple Artificial Neural Network in Base R
------------------------------------------

Below here, you will find a simple Aritifical Neural Network implemented in base R.

*Your task is to copy the code to your editor of choice, make the script run and tune the hyperparameters to get a working model*

We start by clearing the workspace to avoid unintentional reuse of old variables

``` r
# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())
```

The we define the function needed to implement the ANN:

``` r
# Define functions
# ------------------------------------------------------------------------------

# Dot product between two vectors
dot_prod = function(a, b){
  stopifnot( is.numeric(a) & is.numeric(b) & length(a) == length(b) )
  ab = 0
  for( i in seq(from = 1, to = length(a)) ){
    ab = ab + (a[i] * b[i])
  }
  return(ab)
}

# Matrix multiplication
mat_mult = function(A, B){
  stopifnot( is.numeric(A) & is.numeric(B) & ncol(A) == nrow(B) )
  AB = matrix(nrow = nrow(A), ncol = ncol(B))
  for( i in 1:nrow(A) ){
    for( j in 1:ncol(B) ){
      AB[i,j] = dot_prod(A[i,],B[,j])
    }
  }
  return(AB)
}

# Sigmoid activation function
s = function(x){ 1 / (1 + exp(-x)) }

# Mean squared error function
mse = function(O, t){
  return( 1/2 * (O - t) ** 2 )
}

# Feed forward algorithm
feed_forward = function(x, v, w){
  x = matrix(c(x, 1)) # Add bias neuron
  h = rbind(mat_mult(v, x), 1) # Add bias neuron
  H = s(h)
  o = mat_mult(w, H)[1,1]
  O = s(o)
  return(O)
}
```

Now that we have the necessary functions, we can prepare the data we will be working on. Since we are using `R`, naturally we will be using the `iris` dataset

``` r
# Prepare data
# ------------------------------------------------------------------------------
X = iris[,-5]
colnames(X) = paste0('x', seq(1, ncol(X)))
X = apply(X, 2, function(x){ return( as.numeric(scale(x)) ) })
y = ifelse(iris$Species == 'setosa', 1, 0)
i = sample(seq(1, length(y)))
X = X[i,]
y = y[i]
```

The prepared data looks like so:

``` r
dim(X)
```

    ## [1] 150   4

``` r
length(y)
```

    ## [1] 150

``` r
head(X)
```

    ##              x1         x2         x3         x4
    ## [1,] -1.1392005 -0.1315388 -1.3357516 -1.3110521
    ## [2,]  0.7930124  0.3273175  0.7602115  1.0504160
    ## [3,]  0.9137757 -0.3609670  0.4769732  0.1320673
    ## [4,]  2.1214087 -0.1315388  1.6099263  1.1816087
    ## [5,]  0.5514857 -1.7375359  0.3636779  0.1320673
    ## [6,] -0.4146207 -1.2786796  0.1370873  0.1320673

``` r
head(y)
```

    ## [1] 1 0 0 0 0 0

Now we are ready to train the network, we start by setting the hyperparameters:

``` r
# Set hyper parameters
n_hidden = 1    # Number of hidden neurons
epochs   = 5    # Number of epochs
epsilon  = 1000 # Learning rate
```

And define and initialise the the needed weight matrices

``` r
# Set dimensions for weight matrices
v_n_row = n_hidden     # to hidden layer
v_n_col = ncol(X) + 1  # From input layer
w_n_row = 1            # to output layer
w_n_col = n_hidden + 1 # From hidden layer

# Initialise weight matrices
v = matrix(data = rnorm(v_n_row * v_n_col), nrow = v_n_row, ncol = v_n_col)
w = matrix(data = rnorm(w_n_row * w_n_col), nrow = w_n_row, ncol = w_n_col)
```

Now we're finally ready to run the training

``` r
# Run training
# ------------------------------------------------------------------------------
# Run back propagation
training = matrix(NA, nrow = epochs, ncol = 2)
for( l in seq(1, epochs) ){
  
  errors = rep(NA, nrow(X))
  
  for( i in seq(1, nrow(X)) ){
    
    # Feed Forward
    x_i = matrix(c(X[i,], 1)) # Add bias neuron
    h   = rbind(mat_mult(v, x_i), 1) # Add bias neuron
    H   = s(h)
    o   = mat_mult(w, H)[1,1]
    O   = s(o)
    
    # Calculate error of current prediction
    y_i = y[i]
    err = mse(O, y_i)
    errors[i] = err
    
    # Calculate value of delta function
    s_prime_o = (1 - O) * O
    delta = (O - y_i) * s_prime_o
    
    # Compute w-weights changes
    dE_dw = t(delta * H)
    
    # Compute v-weights changes
    s_prime_h = (1 - H) * H
    dE_dv = matrix(data = NA, nrow = nrow(v), ncol = ncol(v))
    for( j in 1:nrow(dE_dv) ){
      for( k in 1:ncol(dE_dv) ){
        dE_dv[j,k] = delta * w[1,j] * s_prime_h[j,1] * x_i[k,1]
      }
    }
    
    # Update weight matrices
    w = w - epsilon * dE_dw
    v = v - epsilon * dE_dv
    
  }
  
  # Calculate mean errors for current epoch
  training[l,] = c(l, mean(errors))
  
}
```

With the model we trained, we can predict on the training data and compare with the target values

``` r
# Run predictions
# ------------------------------------------------------------------------------
y_true = y
y_pred = rep(NA, nrow(X))
for( i in seq(1, nrow(X)) ){
  y_pred[i] = feed_forward(X[i,], v, w)
}
```

Lastly, we can visualise the training and the final performance of the model:

``` r
# Plot results
# ------------------------------------------------------------------------------
par(mfrow=c(1,2))
plot(training, type = "l", xlab="epoch", ylab = "MSE")
plot(cbind(y_pred, y_true))
abline(v = 0.5, lty = 2)
```

<img src="01_exercises_files/figure-markdown_github/unnamed-chunk-9-1.png" width="600px" style="display: block; margin: auto;" />
