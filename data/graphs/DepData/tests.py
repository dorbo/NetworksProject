file_name = ['email-Eu-core-temporal-Dept1.txt', 'email-Eu-core-temporal-Dept2.txt','email-Eu-core-temporal-Dept3.txt', 'email-Eu-core-temporal-Dept4.txt']
for a in range(4):
	file = open(file_name[a])
	lines = file.readlines()
	lst = []
	for line in lines:
		(v1, v2, max_time) = line.split()
		lst.append(float(max_time))
	print sorted(lst) == lst

"""
import sys
import os
sys.path.append('../')
import matplotlib.pyplot as plt
import numpy as np
import networkx as nx
import random

file_name = ['email-Eu-core-temporal-Dept1.txt', 'email-Eu-core-temporal-Dept2.txt','email-Eu-core-temporal-Dept3.txt', 'email-Eu-core-temporal-Dept4.txt']
for a in range(4):
	file = open(file_name[a])
	lines = file.readlines()
	(v1, v2, max_time) = lines[-1].split()

	for i in range(len(lines)):
		currentvalue = lines[i]
		m = i
		cur = float(currentvalue.split()[2])
		check = float(lines[m-1].split()[2])
		while m > 0 and check > cur:
			lines[m] = lines[m - 1]
			m -= 1
			lines[m] = currentvalue
			check = float(lines[m - 1].split()[2])

	print a
	f = open('test' + str(a) + '.txt', 'w')
	for line in lines:
		f.write(line)
	f.close()


print 1
f = open('test.txt', 'w')
f.writelines(['%f ' % num for num in a])
f.close()

print 'done'
"""