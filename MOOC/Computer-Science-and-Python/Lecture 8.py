### Lecture 8

def FancyDivide(numbers, index):
    try:
        try:
            denom = numbers[index]
            for i in range(len(numbers)):
                numbers[i] /= denom
        except IndexError, e:
            FancyDivide(numbers, len(numbers) - 1)
        else:
            print "1"
        finally:
            print "0"
    except ZeroDivisionError, e:
        print "-2"
        
# L8 Problem 3
def FancyDivide(list_of_numbers, index):
   denom = list_of_numbers[index]
   return [SimpleDivide(item, denom)
               for item in list_of_numbers]


def SimpleDivide(item, denom):
    try:
        return item / denom
    except ZeroDivisionError, e:
        return 0