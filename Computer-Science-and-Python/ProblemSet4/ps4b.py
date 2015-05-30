from ps4a import *
import time


#
#
# Problem #6: Computer chooses a word
#
#
def loadWords():
    """
    Returns a list of valid words. Words are strings of lowercase letters.
    
    Depending on the size of the word list, this function may
    take a while to finish.
    """
    print "Loading word list from file..."
    # inFile: file
    inFile = open(WORDLIST_FILENAME, 'r', 0)
    # wordList: list of strings
    wordList = []
    for line in inFile:
        wordList.append(line.strip().lower())
    print "  ", len(wordList), "words loaded."
    return wordList

def isValidWord(word, hand, wordList):
    """
    Returns True if word is in the wordList and is entirely
    composed of letters in the hand. Otherwise, returns False.

    Does not mutate hand or wordList.

    word: string
    hand: dictionary (string -> int)
    wordList: list of lowercase strings
    """
    # creates a copy of the hand for the function
    current_hand = hand.copy()
        
    # for each char in word, check if the value of the corresponding char in
    # current_hand is > 0.  If the char is 0, return False.  If the char is
    # not in current hand, which results in a KeyError, return False.  
    # Otherwise, return True
    for char in word:
        try:
            if current_hand[char] > 0:
                current_hand[char] -= 1
                # print 'key : ' + char + ', value :' + str(current_hand[char])
            elif current_hand[char] == 0:
                return False
        except KeyError, e:
            return False
    return True

def getWordScore(word, n):
    """
    Returns the score for a word. Assumes the word is a valid word.

    The score for a word is the sum of the points for letters in the
    word, multiplied by the length of the word, PLUS 50 points if all n
    letters are used on the first turn.

    Letters are scored as in Scrabble; A is worth 1, B is worth 3, C is
    worth 3, D is worth 2, E is worth 1, and so on (see SCRABBLE_LETTER_VALUES)

    word: string (lowercase letters)
    n: integer (HAND_SIZE; i.e., hand size required for additional points)
    returns: int >= 0
    """
    # initialize score to be 0
    score = 0
    
    # find the score for each char in word    
    for char in word:
        score += SCRABBLE_LETTER_VALUES[char]
        
    # multiply the current score by length of the word
    score *= len(word)
    
    # if all n letters used, add 50 to score
    if len(word) == n:
        score += 50
        
    return score

def compChooseWord(hand, wordList, n):
    """
    Given a hand and a wordList, find the word that gives 
    the maximum value score, and return it.

    This word should be calculated by considering all the words
    in the wordList.

    If no words in the wordList can be made from the hand, return None.

    hand: dictionary (string -> int)
    wordList: list (string)
    n: integer (HAND_SIZE; i.e., hand size required for additional points)

    returns: string or None
    """
    # Create a new variable to store the maximum score seen so far (initially 0)
    max_score = 0
    # print 'init_max_score :' + str(max_score)

    # Create a new variable to store the best word seen so far (initially None)  
    best_word = None
    # print 'init_best_word: ' + str(best_word)
    
    # For each word in the wordList
    for word in wordList:
        # print 'loop_running...'

        # If you can construct the word from your hand
        # (hint: you can use isValidWord, or - since you don't really need to test if the word is in the wordList - you can make a similar function that omits that test)
        if isValidWord(word, hand, wordList):
            # print 'is_valid_word_running = True'
    
            # Find out how much making that word is worth
            score = getWordScore(word, n)
            # print 'current_score: ' + str(score)

            # If the score for that word is higher than your best score
            if score > max_score:

                # Update your best score, and best word accordingly
                max_score = score
                best_word = word
                # print 'max_score: ' + str(max_score)
                # print 'best_word: ' + str(best_word)

    # return the best word you found.
    return best_word

#
# Problem #7: Computer plays a hand
#
def compPlayHand(hand, wordList, n):
    """
    Allows the computer to play the given hand, following the same procedure
    as playHand, except instead of the user choosing a word, the computer 
    chooses it.

    1) The hand is displayed.
    2) The computer chooses a word.
    3) After every valid word: the word and the score for that word is 
    displayed, the remaining letters in the hand are displayed, and the 
    computer chooses another word.
    4)  The sum of the word scores is displayed when the hand finishes.
    5)  The hand finishes when the computer has exhausted its possible
    choices (i.e. compChooseWord returns None).
 
    hand: dictionary (string -> int)
    wordList: list (string)
    n: integer (HAND_SIZE; i.e., hand size required for additional points)
    """
    # Keep track of the total score (initialize score to 0)
    total_score = 0
    
    # As long as there are still letters left in the hand:
    while calculateHandlen(hand) > 0:
        
        # Display the hand
        print 'Current Hand:', 
        displayHand(hand)
        print 
        
        # check if the computer can still choose a word; if None, that means
        # no words available
        if compChooseWord(hand, wordList, n) == None:
            break
        
        # if not None, means there are words available
        else: 
        # computer chooses a word
            word = compChooseWord(hand, wordList, n)
            word_score = getWordScore(word, n)
            total_score += word_score
            print '"' + word + '"' + ' earned ' + str(word_score) +' points. Total: ' + str(total_score) + ' points.' 
            print
                    
            # Update the hand 
            hand = updateHand(hand, word)
        
    print 'Total score: ' + str(total_score) + ' points.'
#
# Problem #8: Playing a game
#
#
def playGame(wordList):
    """
    Allow the user to play an arbitrary number of hands.
 
    1) Asks the user to input 'n' or 'r' or 'e'.
        * If the user inputs 'e', immediately exit the game.
        * If the user inputs anything that's not 'n', 'r', or 'e', keep asking them again.

    2) Asks the user to input a 'u' or a 'c'.
        * If the user inputs anything that's not 'c' or 'u', keep asking them again.

    3) Switch functionality based on the above choices:
        * If the user inputted 'n', play a new (random) hand.
        * Else, if the user inputted 'r', play the last hand again.
      
        * If the user inputted 'u', let the user play the game
          with the selected hand, using playHand.
        * If the user inputted 'c', let the computer play the 
          game with the selected hand, using compPlayHand.

    4) After the computer or user has played the hand, repeat from step 1

    wordList: list (string)
    """
    # initialize empty hand
    hand = {}
      
    while True:
        
        # initialize variable for game_choice
        game_choice = str(raw_input('Enter n to deal a new hand, r to replay the last hand, or e to end game: '))
        
        # if player chooses to exit, break the loop
        if game_choice == 'e':
            break
         
        # if player chooses to replay but hand is empty, print error message
        elif game_choice == 'r':
            if hand == {}:
                print 'You have not played a hand yet. Please play a new hand first!'
            else:
                # if hand is not empty, prompt for player choice of user or computer
                player_choice = str(raw_input('Enter u to have yourself play, c to have the computer play: '))
                # if player chooses to play, initiate playHand
                if player_choice == 'u':
                    playHand(hand, wordList, HAND_SIZE)
            
                # if player chooses computer to play, initiate compPlayHand
                elif player_choice == 'c':
                    compPlayHand(hand, wordList, HAND_SIZE)
                
                # if player chooses another other input, print error message
                else:
                    print 'Invalid command.'  
                      
        # if player chooses to play new game or replay old hand, ask for player
        # choice of either user or computer
        elif game_choice == 'n':
            player_choice = str(raw_input('Enter u to have yourself play, c to have the computer play: '))            
            hand = dealHand(HAND_SIZE)
            
            # if player chooses to play, initiate playHand
            if player_choice == 'u':
                playHand(hand, wordList, HAND_SIZE)
            
            # if players chooses computer to play, initiate compPlayHand
            elif player_choice == 'c':
                compPlayHand(hand, wordList, HAND_SIZE)
            
            # if player chooses another other input, print error message
            #else:
                print 'Invalid command.'
                
        # if any other input, print error message
        else:
            print 'Invalid command.' 

            
                                    
        ## if player had chosen to start new game, deal new hand  
        #if game_choice == 'n':
        #    hand = dealHand(HAND_SIZE)
        #    
        #    # if player chooses to play, initiate playHand
        #    if player_choice == 'u':
        #        playHand(hand, wordList, HAND_SIZE)
        #    
        #    # if players chooses computer to play, initiate compPlayHand
        #    elif player_choice == 'c':
        #        compPlayHand(hand, wordList, HAND_SIZE)
        #    
        #    # if player chooses another other input, print error message
        #    else:
        #        print 'Invalid command.'
        #        
        ## if player had chosen to replay the hand, 
        #elif game_choice == 'r' and hand != {}:
        #    
        #    # if player chooses to play, initiate playHand
        #    if player_choice == 'u':
        #        playHand(hand, wordList, HAND_SIZE)
        #    
        #    # if player chooses computer to play, initiate compPlayHand
        #    elif player_choice == 'c':
        #        compPlayHand(hand, wordList, HAND_SIZE)
        #        
        #    # if player chooses another other input, print error message
        #    else:
        #        print 'Invalid command.'
             
#
# Build data structures used for entire session and play game
#
if __name__ == '__main__':
    wordList = loadWords()
    playGame(wordList)


