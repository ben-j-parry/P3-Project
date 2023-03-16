import math


def fixed_point(number):
    return number * 2147483647

#f0 = int(input("Centre Frequency (Hz): "))
#G = int(input("Gain (dB): "))
#BW = int(input("Bandwidth (Hz): "))
f0 = 10000
G = 5
BW = 1000

fs = 48000
A = 10**(G/40)
w0 = 2 * math.pi * (f0/fs)

p = (math.log(2)/2)*BW*(w0/math.sin(w0))

a_ = math.sin(w0)*math.sinh(p)

b = []
a = []


b.append(1 + (a_ * A)) 
b.append(-2 * math.cos(w0))
b.append(1 - (a_ * A))

a.append(1 + (a_ / A))
a.append(-2 * math.cos(w0))
a.append(1 - (a_ / A))

print(b)
print(a)

values = range(0,3)

a_0 = a[0]

for x in values:
    b[x] = b[x] / a_0

for x in values:
    a[x] = a[x] / a_0


print("")
print(b)
print(a)

n_real = []

n_real.append(b[0]/a[0])
n_real.append((b[1]/a[0])/2)
n_real.append(b[2]/a[0])

factor = max(n_real)
range_ = (2**31)-1

N = []
D = []

N.append(((b[0]/a[0])/factor))
N.append(((b[1]/a[0])/(2*factor)))
N.append(((b[2]/a[0])/factor))

D.append(1)
D.append((a[1]/(-2*a[0])))
D.append(-(a[2]/a[0]))

print("")
print(N)
print(D)