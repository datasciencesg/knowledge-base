## Week 1
x = int(raw_input('Enter an integer: '))
if x%2 == 0:
    print('')
    print('Even')
else:
    print('')
    print('Odd')
print('Done with conditional')

x = 9
if x%2 == 0:
    if x%3 == 0:
        print('divisible by 2 and 3')
    else:
        print('divisible by 2 and not 3')
elif x%3 == 0:
    print('divisible by 3 and not by 2')
else:
    print('not divisible by 2 or 3')
    
happy = 3
if happy > 2:
    print('hello world')
    
varA = 'adieu'
varB = 123
string = 'string'

if (type(varA) == type('string') or type(varB) == type('string')):
    print('string involved')
else:
    if varA > varB:
        print('bigger')
    elif varA == varB:
        print('equal')
    elif varA < varB:
        print('smaller')