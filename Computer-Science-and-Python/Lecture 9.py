class intSet(object):
    """An intSet is a set of integers
    The value is represented by a list of ints, self.vals.
    Each int in the set occurs in self.vals exactly once."""

    def __init__(self):
        """Create an empty set of integers"""
        self.vals = []

    def insert(self, e):
        """Assumes e is an integer and inserts e into self""" 
        if not e in self.vals:
            self.vals.append(e)

    def member(self, e):
        """Assumes e is an integer
           Returns True if e is in self, and False otherwise"""
        return e in self.vals

    def remove(self, e):
        """Assumes e is an integer and removes e from self
           Raises ValueError if e is not in self"""
        try:
            self.vals.remove(e)
        except:
            raise ValueError(str(e) + ' not found')

    def __str__(self):
        """Returns a string representation of self"""
        self.vals.sort()
        return '{' + ','.join([str(e) for e in self.vals]) + '}'
        
    def intersect(self, other):
        '''returns a new intSet containing elements that appear in both sets'''
        intersect_set = intSet()
        for i in other.vals:
            if self.member(i):
                intersect_set.insert(i)
        return intersect_set
        
    def __len__(self):
        return len(self.vals)
        
# L11 Problem 6
class Queue(object):
    
    def __init__(self):
        self.queue = []
        
    def insert(self, e):
        self.queue.append(e)
        
    def remove(self):
        if self.queue == []:
            raise ValueError()
        else:
            return self.queue.pop(0)
