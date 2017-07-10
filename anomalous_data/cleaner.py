file = '/Users/akbirkhan/Desktop/Variational-LSTM-Autoencoder-master/corpus/anomalous_data/anomalousTrafficTest.txt'
target = '/Users/akbirkhan/Desktop/Variational-LSTM-Autoencoder-master/corpus/anomalous_data/anomalousTrafficTestclean.txt'
f = open(file,'r')
t = open(target,'w')
sentence = ""
query = False
q2 = False
#info will store all information after html+query 
info = ''
count = 0
for line in f.readlines():
	if line[0:3]== 'GET':
		t.write(sentence + '\n')
		sentence = line.rstrip('\n') + ' '
		query = False
		count +=1

	elif line[0:4] == "POST":
		t.write(sentence + '\n')
		#Split http request into domain and html type
		request = line.rstrip('\n').split()
		#add to the sentence the POST + html addresss
		sentence = request[0]+' '+ request[1]+ '?'
		#store html type i.e "HTTP/1.1"
		info = request[2]+ ' '
		query = True
		count +=1

	else:
		if query == True & q2 == True:
			sentence = sentence + line.rstrip('\n') + ' ' + info
			q2 = False
			query = False
			info = ''

		elif query == True:
			if line == '\n':
				q2 = True
			else:
				info = info + line.rstrip('\n')  + ' '		
		else:
			sentence = sentence + line.rstrip('\n')  + ' '
#Wrtie final request
t.write(sentence+'\n')
t.close()
f.close()
print('Count:')
print(count+1)
print('done!')
