__author__ = 'Blayne'


from socket import socket
import sys

sock = socket()

sock.connect(('localhost',12321))

initialBalance = int(sys.argv[1])
annualRate = float(sys.argv[2])
numberOfMonths = int(sys.argv[3])

initialBalanceAsString = str(initialBalance)
annualRateAsString = str(annualRate)
numberOfMonthsAsString = str(numberOfMonths)

byte_data = (initialBalanceAsString + " " + annualRateAsString + " " + numberOfMonthsAsString).encode("utf-16")  # convert string characters to bytes

sock.send(byte_data)
rcvd_data = sock.recv(2048)
print("received", rcvd_data)
rcvd_string = rcvd_data.decode("utf-16")
rcvd_stringAsFloat = float(rcvd_string)
rcvd_stringAsFloatRound = "{0:.2f}".format(rcvd_stringAsFloat)
rcvd_stringAsFloatRoundString = str(rcvd_stringAsFloatRound)
print("The loan payment will be: ", rcvd_stringAsFloatRoundString)



sock.close()