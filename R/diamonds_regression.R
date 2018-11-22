# Clear Workspace
# ------------------------------------------------------------------------------
rm(list=ls())

# Load libraries
# ------------------------------------------------------------------------------
library('tidyverse')
library('keras')
library('cowplot')

# Define functions
# ------------------------------------------------------------------------------
mk_partitions = function(k, n){
  return( sample(x = 1:k, size = n, replace = TRUE) )
}
metric_pcc <- custom_metric("pcc", function(y_true, y_pred) {
  mu_y_true = k_mean(y_true)
  mu_y_pred = k_mean(y_pred)
  r = k_sum( (y_true - mu_y_true) * (y_pred - mu_y_pred) ) /
    ( k_sqrt(k_sum( k_square(y_true - mu_y_true) )) *
        k_sqrt(k_sum( k_square(y_pred - mu_y_pred) )) )
  return(r)
})

# Prepare data
# ------------------------------------------------------------------------------
nn_dat = diamonds %>%
  mutate(cut_num = as.numeric(cut), color_num = as.numeric(color),
         clarity_num = as.numeric(clarity)) %>% select_if(is.numeric) %>% 
  rename_all(function(x){return(str_c('feat_',x))}) %>% 
  rename(y_price = feat_price) %>%
  mutate_at(vars(contains('feat')), funs(scale))

# Setup Cross Validation
# ------------------------------------------------------------------------------
set.seed(206268) # Ensure reproducible partitions
k = 5
nn_dat = nn_dat %>% mutate(partition = mk_partitions(k = k, n = nrow(.)))

# Set hyperparameters
# ------------------------------------------------------------------------------
n_epochs      = 20
batch_size    = 200
loss          = 'mean_squared_error'
optimzer      = 'adam'
h1_activation = 'relu'
h1_n_hidden   = 3
o_activation  = 'linear'

# Train models
# ------------------------------------------------------------------------------

# Collect information on training
fold_data = tibble()

# Run k-fold cross validation
for( k_i in seq(1, k) ){
  
  # Set new sequential model
  model = keras_model_sequential()
  
  # Set architecture
  model %>% 
    layer_dense(units = h1_n_hidden, activation = h1_activation, input_shape = 9) %>% 
    layer_dense(units = 1, activation = o_activation)
  
  # Compile model
  model %>% compile(
    loss      = loss,
    optimizer = optimzer,
    metrics   = metric_pcc
  )
  
  # Set training partitions
  X_train = nn_dat %>% filter(partition %in% setdiff(1:k, k_i)) %>%
    select(contains("feat")) %>% as.matrix
  y_train = nn_dat %>% filter(partition %in% setdiff(1:k, k_i)) %>%
    pull(y_price) %>% as.numeric
  
  # Set test partitions
  X_test = nn_dat %>% filter(partition == k_i) %>%
    select(contains("feat")) %>% as.matrix
  y_test = nn_dat %>% filter(partition == k_i) %>%
    pull(y_price) %>% as.numeric
  
  # Fit model on training data
  history = model %>% fit(
    x = X_train, y = y_train,
    epochs           = n_epochs,
    batch_size       = batch_size,
    validation_split = 0
  )

  # Calculate performance on test data
  y_true = y_test
  y_pred = model %>% predict(X_test) %>% as.vector
  pcc = round(cor(y_pred, y_true, method = "pearson"), 3)
  
  # Save fold results
  fold_data = fold_data %>%
    bind_rows(tibble(k = k_i,
                     epoch = 1:history$params$epochs,
                     loss = history$metrics$loss,
                     pcc_train = history$metrics$pcc,
                     pcc_test = pcc))
}

# Report average performance
ave_perf = fold_data %>% select(pcc_test) %>% distinct %>% pull %>% mean
cat("Average performance for current setup is PCC =", ave_perf, "\n")

# Visualise data
# ------------------------------------------------------------------------------

# Set k as factor
fold_data = fold_data %>% mutate(k = factor(k))

# See training progress for performance metric
pl1 = fold_data %>%
  ggplot(aes(x = epoch, y = pcc_train, colour = k)) +
  geom_line() +
  theme_bw()

# See training progress for loss metric
pl2 = fold_data %>%
  ggplot(aes(x = epoch, y = loss, colour = k)) +
  geom_line() +
  theme_bw()

# Plot test performances as barplot
pl3 = fold_data %>% select(k, pcc_test) %>% distinct %>%
  ggplot(aes(x = k, y = pcc_test, fill = k)) +
  geom_col(alpha = 0.5) +
  theme_bw() +
  guides(fill = FALSE) +
  scale_x_discrete(breaks = NULL)

print(plot_grid(plotlist = list(pl1, pl2, pl3), nrow = 3))
