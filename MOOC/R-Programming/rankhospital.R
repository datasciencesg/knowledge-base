rankhospital <- function(State, Outcome, Num = 'best') {
    # read outcome data
    outcome_data <- read.csv('outcome-of-care-measures.csv', colClasses = 'character', )
    
    # subset outcome data to only keep hospital, state, and ailment data
    outcome_data <- outcome_data[c(2, 7, 11, 17, 23)]
    names(outcome_data) <- c('hospital', 'state', 'heart attack', 'heart failure', 'pneumonia')
    
    # create vector to check input Outcome against
    disease <- c('heart attack', 'heart failure', 'pneumonia')
    
    # validation for State
    if (!State %in% outcome_data$state) { stop('invalid state') }
    
    # validation for Outcome
    if (!Outcome %in% disease) { stop ('invalid outcome') }
    
    # subset selected State from outcome data
    outcome_data <- subset(outcome_data, state == State)
    
    # order the data by hospital and score
    outcome_data[Outcome] <- suppressWarnings(as.data.frame(sapply(outcome_data[Outcome], as.numeric)))
    outcome_data <- outcome_data[order(outcome_data$hospital, decreasing = FALSE), ]
    outcome_data <- outcome_data[order(outcome_data[Outcome], decreasing = FALSE), ]
    
    # create score column based on Outcome (i.e, ailment) indicated
    score <- outcome_data[,Outcome]
    
    # create index of hospital_row based on Num
    if (Num == 'best') {
        hospital_row <- suppressWarnings(which.min(score))
    } else if (Num == 'worst') {
        hospital_row <- suppressWarnings(which.max(score))
    } else {
        hospital_row <- Num
    }
    
    # return hopital name based on lowest score index
    outcome_data$hospital[hospital_row] 
}
