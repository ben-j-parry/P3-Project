import math

#coeffs
b = [0.2447, 0.3754, 0.2448]
a = [1, -0.3691,  0.2339]

values = range(3)


#mapped values
for x in values:
    b[x] = b[x] * 2147483647
    b[x] = math.floor(b[x])

print(b)

for x in values:
    a[x] = a[x] * 2147483647
    a[x] = math.floor(a[x])

print(a)


#binary
for x in values:
    #b[x] = bin(b[x])
    b[x] = '{:032b}'.format(b[x])

print(b)

for x in values:
    #a[x] = bin(a[x])
    a[x] = '{:032b}'.format(a[x])
print(a)






