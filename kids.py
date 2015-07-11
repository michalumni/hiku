import random
import string
import datetime

VOWELS = ['a','e','i','o','u']
CONSONANTS = ['b','c','d','f','g','h','j','k','l','m','n','p', 'q' ,'r' ,'s', 't', 'v', 'w', 'x' ,'y','z']


myStr = random.choice(CONSONANTS) + random.choice(VOWELS) + random.choice(CONSONANTS) + random.choice(CONSONANTS)
myStr = myStr + random.choice(VOWELS) + random.choice(CONSONANTS)

print (myStr)
#print (datetime.datetime.utcnow())