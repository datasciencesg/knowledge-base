best <- function(State, Outcome) {
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
    state_outcome <- subset(outcome, state == State)
    
    # create score column based on Outcome (i.e, ailment) indicated
    score <- state_outcome[,Outcome]
    
    # find index of lowest score; suppress warnings of 'NAs introduced by coercion'
    hospital_row <- suppressWarnings(which.min(score))
    
    # return hopital name based on lowest score index
    state_outcome$hospital[hospital_row] 
}
