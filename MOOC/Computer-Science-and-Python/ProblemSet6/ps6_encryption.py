# 6.00x Problem Set 6
#
# Part 1 - HAIL CAESAR!

import string
import random

WORDLIST_FILENAME = "words.txt"

# -----------------------------------
# Helper code
# (you don't need to understand this helper code)
def loadWords():
    """
    Returns a list of valid words. Words are strings of lowercase letters.
    
    Depending on the size of the word list, this function may
    take a while to finish.
    """
    print "Loading word list from file..."
    inFile = open(WORDLIST_FILENAME, 'r')
    wordList = inFile.read().split()
    print "  ", len(wordList), "words loaded."
    return wordList

def isWord(wordList, word):
    """
    Determines if word is a valid word.

    wordList: list of words in the dictionary.
    word: a possible word.
    returns True if word is in wordList.

    Example:
    >>> isWord(wordList, 'bat') returns
    True
    >>> isWord(wordList, 'asdf') returns
    False
    """
    word = word.lower()
    word = word.strip(" !@#$%^&*()-_+={}[]|\\:;'<>?,./\"")
    return word in wordList

def randomWord(wordList):
    """
    Returns a random word.

    wordList: list of words  
    returns: a word from wordList at random
    """
    return random.choice(wordList)

def randomString(wordList, n):
    """
    Returns a string containing n random words from wordList

    wordList: list of words
    returns: a string of random words separated by spaces.
    """
    return " ".join([randomWord(wordList) for _ in range(n)])

def randomScrambled(wordList, n):
    """
    Generates a test string by generating an n-word random string
    and encrypting it with a sequence of random shifts.

    wordList: list of words
    n: number of random words to generate and scamble
    returns: a scrambled string of n random words

    NOTE:
    This function will ONLY work once you have completed your
    implementation of applyShifts!
    """
    s = randomString(wordList, n) + " "
    shifts = [(i, random.randint(0, 25)) for i in range(len(s)) if s[i-1] == ' ']
    return applyShifts(s, shifts)[:-1]

def getStoryString():
    """
    Returns a story in encrypted text.
    """
    return open("story.txt", "r").read()


# (end of helper code)
# -----------------------------------


#
# Problem 1: Encryption
#
def buildCoder(shift):
    """
    Returns a dict that can apply a Caesar cipher to a letter.
    The cipher is defined by the shift value. Ignores non-letter characters
    like punctuation, numbers and spaces.

    shift: 0 <= int < 26
    returns: dict
    """
    # initialize empty dictionary
    dict = {}
    
    # create lists for keys based on lower case and upper case alphabet
    lower_keys =list(string.ascii_lowercase)
    upper_keys = list(string.ascii_uppercase)
    
    # initialize empty list for values
    lower_vals = []
    upper_vals = []    
    
    # create value lists based on shifting the lower and upper keys
    for key in lower_keys:
        index = shift % 26
        shift += 1
        lower_vals.append(lower_keys[index])
    for key in upper_keys:
        index = shift % 26
        shift += 1
        upper_vals.append(upper_keys[index])
        
    # create total key and value lists
    all_keys = upper_keys + lower_keys
    all_vals = upper_vals + lower_vals
    index = 0
    
    # for each key in all_keys, add the value from all_vals
    for k in all_keys:
        dict[k] = all_vals[index]
        index += 1
    
    return dict
 
def applyCoder(text, coder):
    """
    Applies the coder to the text. Returns the encoded text.

    text: string
    coder: dict with mappings of characters to shifted characters
    returns: text after mapping coder chars to original text
    """
    # create a string of chars to ignore
    # ignored_chars = string.punctuation + ' ' + string.digits
    
    # create dictionary based on coder
    dict = coder
    
    # initialize empty string for encoded message
    encoded_msg = ''
    
    # for each char in text, if it is not in ignored_chars, encoded it using the 
    # dict and add the encoded char to encoded_msg; else, add the char to 
    # encoded msg    
    for char in text:
        if char in string.letters:
            encoded_msg += dict[char]
        else: 
            encoded_msg += char
    
    return encoded_msg    
      
def applyShift(text, shift):
    """
    Given a text, returns a new text Caesar shifted by the given shift
    offset. Lower case letters should remain lower case, upper case
    letters should remain upper case, and all other punctuation should
    stay as it is.

    text: string to apply the shift to
    shift: amount to shift the text (0 <= int < 26)
    returns: text after being shifted by specified amount.
    """
    # return applyCoder which uses text and buildCoder as input
    return applyCoder(text, buildCoder(shift))
    
#
# Problem 2: Decryption
#
def findBestShift(wordList, text):
    """
    Finds a shift key that can decrypt the encoded text.

    text: string
    returns: 0 <= int < 26
    """
    # initialize correct_shift to be zero
    correct_shift = 0
    
    # initialize highest_valid_words to be zero
    highest_valid_words = 0
    
    # for shift from 0 to 26
    for shift in range(25):
    
        # valid_words = 0
        valid_words = 0
        
        # applyShift using shift
        decoded_text = applyShift(text, shift)
        
        # split the decoded_text into a list of individual words
        decoded_text = decoded_text.split()
    
        # for each word in decoded_text
        for word in decoded_text:
            
            # add the result of isWord (i.e., True/False) to valid_words
            valid_words += isWord(wordList, word)
                
        # if valid_words is greater than highest_valid_words
        if valid_words > highest_valid_words:
        
            # change value of highest_valid_words to valid_words
            highest_valid_words = valid_words
            
            # change value of correct_shift to shift
            correct_shift = shift
    
    # return correct_shift
    return correct_shift
    

def decryptStory():
    """
    Using the methods you created in this problem set,
    decrypt the story given by the function getStoryString().
    Use the functions getStoryString and loadWords to get the
    raw data you need.

    returns: string - story in plain text
    """
    # load wordlist
    wordList = loadWords()
    
    # initialize text using getStoryString()
    text = getStoryString()
    
    # find the best shift for text
    shift = findBestShift(wordList, text)

    # use applyShift to decode text
    decoded_text = applyShift(text, shift)
    
    # return decoded_text
    return decoded_text

#
# Build data structures used for entire session and run encryption
#

if __name__ == '__main__':
    # To test findBestShift:
    wordList = loadWords()
    s = applyShift('Hello, world!', 8)
    bestShift = findBestShift(wordList, s)
    assert applyShift(s, bestShift) == 'Hello, world!'
    # To test decryptStory, comment the above four lines and uncomment this line:
    #    decryptStory()
