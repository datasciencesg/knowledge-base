### Problem Set 1

# Qn 1
s = 'azcbobobegghakl'    
count = 0
for letter in s:
    if letter in 'aeiou':
        count += 1
print 'Number of vowels: ' + str(count)

# Qn 2
s = 'azcbobobegghakl'
count = 0
for i in range(len(s)):
    three_letters =  s[i:i+3]
    if three_letters == 'bob':
        count +=1
print 'Number of times bob occurs is: ' + str(count)

# Qn 3
s = 'abcdefgazcbobobegghakl'
s = 'qrvikzxwpddqqc'
longest_sub = ''
sub = s[0]

for i in range(1, len(s)):
    if s[i] >= s[i-1]:
        sub += s[i]
        #print 'sub: ' + sub
    else:
        if len(longest_sub) < len(sub):
            longest_sub = sub
            #print 'longest_sub: ' + longest_sub
        sub = s[i]
if len(longest_sub) < len(sub):
    longest_sub = sub
    
print 'Longest substring in alphabetical order is: ' + longest_sub
