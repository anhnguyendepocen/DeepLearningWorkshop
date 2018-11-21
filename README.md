Micro Workshop on Deep Learning in R
================

Before the Workshop
-------------------

Due to time constraints, please make sure, that you have successfully completed the following steps:

### Installing R and RStudio

Please install the latest versions of [`R`](https://mirrors.dotsrc.org/cran/) and [`RStudio`](https://www.rstudio.com/products/rstudio/download/#download). If you have another workflow for interacting with `R`, please feel free to utilise this. I personally prefer `RStudio` for my `R` projects.

### Installing tidyverse

[The tidyverse is an opinionated collection of R packages designed for data science. All packages share an underlying design philosophy, grammar, and data structures.](https://www.tidyverse.org/) We will use the tidyverse for data manipulations.

``` r
install.packages('tidyverse')
```

### Installing Keras and TensorFlow

Keras allows us to seamlessly interact with TensorFlow. We will use Keras to build our deep learning architectures:

``` r
install.packages('devtools')
devtools::install_github('rstudio/keras')
library('keras')
install_keras()
```

Congratulations! That's it! Now you're ready for the workshop!

At the Workshop
---------------

### Schedule

14.00 - 14.20 Session 1, part I: Introduction to Neural Networks \[[slides]()\]
14.20 - 14.45 Session 1, part II: Exercises \[[Link]()\]
14.45 - 15.00 Break
15.00 - 15.15 Session 2, part I: Introduction to TensorFlow \[[slides]()\]
15.15 - 15.45 Session 2, part II: Exercises \[[Link]()\]
15.45 - 16.00 Break
16.00 - 16.15 Session 3, part I: Introduction to model training \[[slides]()\]
16.15 - 16.45 Session 3, part II: Exercises \[[Link]()\]
16.45 - 17.00 Q&A and workshop wrap up

Resources
---------

### Web

-   [R Interface to TensorFlow](https://tensorflow.rstudio.com/)
-   [R interface to Keras](https://keras.rstudio.com/)
-   [Learning Resources](https://tensorflow.rstudio.com/learn/resources.html)
-   [RStudio Community](https://community.rstudio.com/)
-   [RStudio Cloud](https://rstudio.cloud/)

### Cheat Sheets

-   [Deep Learning with Keras Cheatsheet](https://github.com/rstudio/cheatsheets/raw/master/keras.pdf)
-   [RStudio IDE](https://github.com/rstudio/cheatsheets/raw/master/rstudio-ide.pdf)
-   [Data Import with readr](https://github.com/rstudio/cheatsheets/raw/master/data-import.pdf)
-   [Data Transformation with dplyr](https://github.com/rstudio/cheatsheets/raw/master/data-transformation.pdf)
-   [Data Visualization with ggplot2](https://github.com/rstudio/cheatsheets/raw/master/data-visualization-2.1.pdf)

### Books

-   [Deep Learning with R](https://www.manning.com/books/deep-learning-with-r)
-   [Free: Deep Learning book](https://www.deeplearningbook.org/)
-   [Free: R for Data Science by Garrett Grolemund and Hadley Wickham](https://r4ds.had.co.nz/)
-   [ModernDive - An Introduction to Statistical and Data Sciences via R](https://moderndive.com/)
