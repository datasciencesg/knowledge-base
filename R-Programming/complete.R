complete <- function(directory, ids = 1:332) {
    filenames <- list.files(directory)
    filenames <- filenames[ids]
    filenames <- paste(directory, "//", filenames, sep = "")
    id <- numeric(length(ids))
    nobs <- numeric(length(ids))
    for (i in 1:length(ids)) {
        id[i] <- ids[i]
        nobs[i] <- sum(complete.cases(read.csv(filenames[i])))
    }
    data.frame(id, nobs, stringsAsFactors = F)
}

