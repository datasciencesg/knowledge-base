corr <- function(directory, threshold = 0) {
    filenames <- list.files(directory)
    filenames <- paste(directory, "//", filenames, sep = "")
    all_files <- complete(directory)
    cor_vector <- numeric()
    for (i in 1:nrow(all_files)) {
        if (all_files[i,2] > threshold) {
            cor_vector <- c(cor_vector, cor(read.csv(filenames[i])$sulfate, read.csv(filenames[i])$nitrate, use = "pairwise.complete.obs")) 
        }
    }
    cor_vector
}