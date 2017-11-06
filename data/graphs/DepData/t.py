file_name = ['email-Eu-core-temporal-Dept1.txt', 'email-Eu-core-temporal-Dept2.txt','email-Eu-core-temporal-Dept3.txt', 'email-Eu-core-temporal-Dept4.txt']
for a in range(4):
	file = open(file_name[a])
	lines = file.readlines()
	lst = []
	for line in lines:
		(v1, v2, max_time) = line.split()
		lst.append(float(max_time))
	print sorted(lst) == lst
