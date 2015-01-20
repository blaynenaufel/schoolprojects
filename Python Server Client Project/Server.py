__author__ = 'Blayne'


from socket import socket

listener_socket = socket()

listener_socket.bind(('',12321))   #  host:  listen on any ip address
                                    # port: 12345

listener_socket.listen(5)

print("Now calling accept function")

(sock, address) = listener_socket.accept()
#script is now waiting for a connection

print("Connection made and accepted")

print("socket is " + str(sock))
print("address is " + str(address))


rcvd_data = sock.recv(2048)
print("received", rcvd_data)
rcvd_string = rcvd_data.decode("utf-16")
print("received string", rcvd_string)
numbers = rcvd_string.split()
initialBalance = float(numbers[0]) #initial balance
annualRate = float(numbers[1]) #annual rate
numberOfMonths = int(numbers[2]) #numberofmonths
monthlyInterest = annualRate/12
numerator = initialBalance*monthlyInterest*pow(1+monthlyInterest, numberOfMonths)
denominator = (pow(1+monthlyInterest, numberOfMonths)-1)
monthlyPayment = numerator/denominator
print("monthly payment", monthlyPayment)
monthlyPaymentAsString = str(monthlyPayment)
byte_data = monthlyPaymentAsString.encode("utf-16")
sock.send(byte_data)


sock.close()

listener_socket.close()