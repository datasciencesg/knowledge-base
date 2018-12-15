## Week 2

x = int(raw_input('Enter an integer: '))
ans = 0
while ans**3 < abs(x):
    ans = ans + 1
if ans**3 != abs(x):
    print(str(x) + ' is not a perfect cube')
else:
    if x < 0:
        ans = -ans
    print ('Cube root of ' + str(x) + ' is ' + str(ans))
    
num = 0
while num <= 5:
    print num
    num += 1

print "Outside of loop"
print num 

num = 10
while num > 3:
    num -= 1
    print num
    
num = 10
while True:
    if num < 7:
        print 'Breaking out of loop'
        break
    print num
    num -= 1
print 'Outside of loop' 

# Problem 2a
x = 0
while x < 10:
    x += 2
    print x
print 'Goodbye!'

# Problem 2b
x = 10
print 'Hello!'
while x > 0:
    print x
    x -= 2
    
# Problem 2c
end = 6
x = 1
ans = 0
while x <= end:
    ans += x
    x += 1
print ans

x = int(raw_input('Enter an integer: '))
ans = 0
for ans in range(0, abs(x) + 1):
    if ans**3 == abs(x):
        break
if ans**3 != abs(x):
    print(str(x) + ' is not a perfect cube')
else:
    if x < 0:
        ans = -ans
    print ('Cube root of ' + str(x) + ' is ' + str(ans))
    
# Problem 3
myStr = '6.00x'

for char in myStr:
    print char
    
print 'done'

# next 
greeting = 'Hello!'
count = 0

for letter in greeting:
    count += 1
    if count % 2 == 0:
        print letter 
    print letter

print 'done'

# next
school = 'Massachusetts Institute of Technology'
numVowels = 0
numCons = 0

for char in school:
    if char == 'a' or char == 'e' or char == 'i' \
       or char == 'o' or char == 'u':
        numVowels += 1
    elif char == 'o' or char == 'M':
        print char
    else:
        numCons -= 1

print 'numVowels is: ' + str(numVowels)
print 'numCons is: ' + str(numCons) 

num = 10
for num in range(5):
    print num
print num 

divisor = 2
for num in range(0, 10, 2):
    print num/divisor 
    
count = 0
for letter in 'Snow!':
    print 'Letter # ' + str(count) + ' is ' + str(letter)
    count += 1
    break
print count 

for variable in range(20):
    if variable % 4 == 0:
        print variable
    if variable % 16 == 0:
        print 'Foo!' 

x = 0        
for i in range(2, 11, 2):
    x += 2
    print x
print 'Goodbye!'

x = 10
print 'Hello!'
for i in range(1, 6):
    print x 
    x -= 2
    
end = 6
ans = 0
for i in range(end + 1):
    ans += i
print ans
    
    
count = 0
phrase = "hello, world"
for iteration in range(5):
    count += len(phrase)
    print "Iteration " + str(iteration) + "; count is: " + str(count)
    
x = 23
epsilon = 0.01
step = 0.1
guess = 0.0

while guess <= x:
    if abs(guess**2 -x) < epsilon:
        break
    else:
        guess += step
        print guess

if abs(guess**2 - x) >= epsilon:
    print 'failed'
else:
    print 'succeeded: ' + str(guess)

# lecture 3.5, slide 2

x = 25
epsilon = 0.01
step = 0.1
numGuesses = 0
ans = 0.0
while (abs(ans**2 - x)) >= epsilon and ans <= x:
    ans += step
    numGuesses += 1
    print ans
print('numGuesses = ' + str(numGuesses))
if abs(ans**2-x) >= epsilon:
    print('Failed on square root of ' + str(x))
else:
    print(str(ans) + ' is close to the square root of ' + str(x))

