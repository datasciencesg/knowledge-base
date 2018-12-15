pollutantmean <- function(directory, pollutant, id = 1:332) {
    # create list of filenames
    filenames <- list.files(directory)
    # subset filenames based on id argument
    filenames <- filenames[id]
    # create full length filenames based on directory argument
    filenames <- paste(directory, "//", filenames, sep = "")
    
    all_data <- data.frame(Date = numeric(), sulphate = numeric(), nitrate = numeric(), ID = numeric())
    for (i in 1:length(id)) {
        all_data <- rbind(all_data, read.csv(filenames[i]))
    }
    mean(all_data[, pollutant], na.rm = T)   
}
