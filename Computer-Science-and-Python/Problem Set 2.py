### Problem Set 2
# Qn 1

#Test Case 1
balance = 4213
annualInterestRate = 0.2
monthlyPaymentRate = 0.04

#Test Case 2:
balance = 4842
annualInterestRate = 0.2
monthlyPaymentRate = 0.04

monthly_interest = annualInterestRate/12
total_paid = 0

for i in range(1, 13):
    min_month = balance * monthlyPaymentRate
    balance -= min_month
    balance *= (1 + monthly_interest)
    total_paid += min_month
    print 'Month: ' + str(i)
    print 'Minimum monthly payment :' + str(round(min_month, 2))
    print 'Remaining balance: ' + str(round(balance, 2))
    
print 'Total paid: ' + str(round(total_paid, 2))
print 'Remaining balance: ' + str(round(balance,2))

# Qn 2

# Test Case 1
balance = 3329
annualInterestRate = 0.2

# Test Case 2
balance = 4773
annualInterestRate = 0.2

# Test Case 3
balance = 3926
annualInterestRate = 0.2

monthly_interest = annualInterestRate/12
working_bal = balance
payment = 0

while working_bal > 0:
    payment += 10
    for i in range(1, 13):
        working_bal -= payment
        working_bal *= (1 + monthly_interest)
        #print 'Month: ' + str(i)
        #print 'Remaining balance: ' + str(round(working_bal, 2))
    if working_bal > 0:
        working_bal = balance

print 'Lowest Payment: ' + str(payment)
    
# Qn 3
# Test Case 1
balance = 320000
annualInterestRate = 0.2

# Test Case 2
balance = 999999
annualInterestRate = 0.18

# create variables for working balance, epsilon, monthly interest, lower bound for 
# payment, upper bound for payment, and working payment to test
epsilon = 0.01
monthly_interest = annualInterestRate/12
lower_payment = balance/12
upper_payment = (balance * (1 + monthly_interest)**12)/12
working_payment = (lower_payment + upper_payment)/2
working_bal = 1

def remaining_bal(balance):
    global working_bal
    for i in range(1, 13):
        balance -= working_payment
        balance *= (1 + monthly_interest)
        #print 'Month: ' + str(i)
        #print 'Remaining balance: ' + str(balance)
    working_bal = balance
    return working_bal
    
while abs(working_bal) >= epsilon:
    #print 'lower: ' + str(lower_payment)
    #print 'upper: ' + str(upper_payment)
    #print 'working_payment: ' + str(working_payment)
    #print 'balance: ' + str(balance)
    if remaining_bal(balance) > 0:
        lower_payment = working_payment
    else:
        upper_payment = working_payment
    working_payment = (lower_payment + upper_payment)/2

print 'Lowest Payment : ' + str(round(working_payment, 2))