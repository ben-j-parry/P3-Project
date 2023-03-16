import math


b = [0.2177475988864898681640625, -0.08758144080638885498046875, 0.120641104876995086669921875]
a = [1, -0.4925051629543304443359375,  0.9028937816619873046875]

values = range(2)

for x in values:
    b[x] = b[x] * 2147483647
    b[x] = math.floor(b[x])

print(b)

for x in values:
    a[x] = a[x] * 2147483647
    a[x] = math.floor(a[x])

print(a)





