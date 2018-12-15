# Problem 5
low = 0
high = 100
ans = (low + high)/2
poss_input = 'chl'
x = ''

print('Please think of a number between 0 and 100!')
while x != 'c':
    if x not in poss_input:
        print('Sorry I did not understand your input.')
    elif x == 'l':
        low = ans
    elif x == 'h':
        high = ans
    ans = (low + high)/2
    print('Is your secret number ' + str(ans) + '?')
    x = raw_input('Enter "h" to indicate the guess is too high. Enter "l" to \
    indicate the guess is too low. Enter "c" to indicate I guessed correctly.')
    
print ('Game over. Your secret number was ' + str(ans))
    
