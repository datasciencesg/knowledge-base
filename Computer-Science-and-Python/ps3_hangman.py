# 6.00 Problem Set 3
# 
# Hangman game
#

# -----------------------------------
# Helper code
# You don't need to understand this helper code,
# but you will have to know how to use the functions
# (so be sure to read the docstrings!)

import random
import string

WORDLIST_FILENAME = "words.txt"

def loadWords():
    """
    Returns a list of valid words. Words are strings of lowercase letters.
    
    Depending on the size of the word list, this function may
    take a while to finish.
    """
    print "Loading word list from file..."
    # inFile: file
    inFile = open(WORDLIST_FILENAME, 'r', 0)
    # line: string
    line = inFile.readline()
    # wordlist: list of strings
    wordlist = string.split(line)
    print "  ", len(wordlist), "words loaded."
    return wordlist

def chooseWord(wordlist):
    """
    wordlist (list): list of words (strings)

    Returns a word from wordlist at random
    """
    return random.choice(wordlist)

# end of helper code
# -----------------------------------

# Load the list of words into the variable wordlist
# so that it can be accessed from anywhere in the program
wordlist = loadWords()

def isWordGuessed(secretWord, lettersGuessed):
    '''
    secretWord: string, the word the user is guessing
    lettersGuessed: list, what letters have been guessed so far
    returns: boolean, True if all the letters of secretWord are in lettersGuessed;
      False otherwise
    '''
    # initialize no. of found letters to zero
    found = 0
    
    # initialize the length of secretWord
    word_length = len(secretWord)
    
    # initialize result to False
    result = False
    
    # if char in secret_word is in letters_guessed, add 1 to found
    for char in secretWord:
        if char in lettersGuessed:
            #print 'char:' + char
            found += 1
    #print 'found: ' + str(found)
    #print 'word_length: ' + str(word_length)
    
    # if the number of letters found equals the word length, return true      
    if found == word_length:
        result = True
        
    return result
            
def getGuessedWord(secretWord, lettersGuessed):
    '''
    secretWord: string, the word the user is guessing
    lettersGuessed: list, what letters have been guessed so far
    returns: string, comprised of letters and underscores that represents
      what letters in secretWord have been guessed so far.
    '''
    # initialize blank string for current state of guesses
    current_state = ''
    
    # if char in secret_word is in letters_guessed, add the char to the current 
    # state; else, add ' _'
    for char in secretWord:
        if char in lettersGuessed:
            current_state += char
        else: 
            current_state += ' _'
    return current_state

def getAvailableLetters(lettersGuessed):
    '''
    lettersGuessed: list, what letters have been guessed so far
    returns: string, comprised of letters that represents what letters have not
      yet been guessed.
    '''
    # initialize all letters of the alphabet
    all_letters = string.ascii_lowercase
    
    # initialize blank string to store list of available letters
    avail_letters = ''
    
    # for each letter, if char in letters_guessed, then do nothing; else, add 
    # the char to avail_letters 
    for char in all_letters:
        if char in lettersGuessed:
            pass
        else: 
            avail_letters += char
    return avail_letters

def game_start(secretWord):
    '''
    text to be displayed at the start of the game
    '''
    print 'Welcome to the game, Hangman!'
    print 'I am thinking of a word that is ' + str(len(secretWord)) + ' letters long.'
    print '------------'
    print 'You have ' + str(8) + ' guesses left.'
    print 'Available letters: ' + string.ascii_lowercase                                                   
                                                                                                            
def hangman(secretWord):
    '''
    secretWord: string, the secret word to guess.

    Starts up an interactive game of Hangman.

    * At the start of the game, let the user know how many 
      letters the secretWord contains.

    * Ask the user to supply one guess (i.e. letter) per round.

    * The user should receive feedback immediately after each guess 
      about whether their guess appears in the computers word.

    * After each round, you should also display to the user the 
      partially guessed word so far, as well as letters that the 
      user has not yet guessed.

    Follows the other limitations detailed in the problem write-up.
    '''
    # variables to store
    secret = secretWord
    lettersGuessed = []
    guesses = 8
    mistakes = 0
    all_letters = string.ascii_lowercase
    avail_letters = ''
     
    # prints the game start text
    game_start(secretWord)  
    
    # infinite while loop if the word is not guessed yet; this loop will be 
    # broken if guesses == 0 or isWordGuessed == True below
    while True:
        
        # guess a letter
        guess = raw_input('Please guess a letter: ')
        
        # convert letter to lower case
        char_guessed = guess.lower()
        #print 'char_guessed: ' + char_guessed
        
        # condition if letter is already guessed, 
        if char_guessed in lettersGuessed:
            print "Oops! You've already guessed that letter: " + getGuessedWord\
            (secretWord, lettersGuessed)
            print '-------------'
            print 'You have ' + str(guesses) + ' guesses left.'
            print 'Available letters: ' + getAvailableLetters(lettersGuessed)
        
        # condition if letter is guessed correctly
        elif char_guessed in secret:
            lettersGuessed.append(char_guessed)
            #print 'letters_guessed: ' + str(lettersGuessed)
            print 'Good guess: ' + getGuessedWord(secretWord, lettersGuessed)
            print '-------------'
            
            # condition if entire word is guessed
            if isWordGuessed(secretWord, lettersGuessed):
                print 'Congratulations, you won!'
                break
            else:
                print 'You have ' + str(guesses) + ' guesses left.'
                print 'Available letters: ' + getAvailableLetters(lettersGuessed)
                 
        # condition if letter is guessed incorrectly
        elif char_guessed not in secret:
            lettersGuessed.append(char_guessed)
            #print 'letters_guessed: ' + str(lettersGuessed)
            print 'Oops! That letter is not in my word: ' + getGuessedWord\
            (secretWord, lettersGuessed)
            guesses -= 1
            print '-------------'
            
            # condition if guesses are reduced to zero
            if guesses == 0:
                print 'Sorry, you ran out of guesses. The word was ' + secretWord +\
                '.' 
                break
            else:
                print 'You have ' + str(guesses) + ' guesses left.'
                print 'Available letters: ' + getAvailableLetters(lettersGuessed)
        
# When you've completed your hangman function, uncomment these two lines
# and run this file to test! (hint: you might want to pick your own
# secretWord while you're testing)

secretWord = chooseWord(wordlist).lower()
#secretWord = 'apple'
hangman(secretWord)
