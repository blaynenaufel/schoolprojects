#!/usr/bin/python3
import psycopg2
__author__ = 'blayne'
'''
Blayne Naufel
CS4320
Dr. Ben Setzer
Assignment 2 Script 1
'''

conn = psycopg2.connect(database="birt", user="birt", password="birt", host="localhost")
cmd = "select customernumber, customername, creditLimit from customers"
crs = conn.cursor()
crs.execute(cmd)
customerList = crs.fetchall()

print ("{0:<15} {1:<50} {2:<30} {3:<30} {4:<30} {5:<30}".format("Customer Number", "Customer Name", "Total Payments", "Total Orders Value", "Credit Limit", "Available Credit"))
for customer in customerList:
    cmd = "select amount from payments where customernumber = %s"
    crs.execute(cmd, [customer[0]])
    paymentList = crs.fetchall()
    totalPayment = 0
    for payment in paymentList:
        totalPayment += payment[0]
        cmd = "select ordernumber from orders where customernumber = %s"
        crs.execute(cmd, [customer[0]])
        orderList = crs.fetchall()
        totalOrder = 0
        for order in orderList:
            cmd = "select priceeach, quantityordered from orderdetails where orderNumber =%s"
            crs.execute(cmd, [order[0]])
            orderDetailsList = crs.fetchall()
            for payment in orderDetailsList:
                totalOrder += payment[0] * payment[1]
                availableCredit = (customer[2] + totalPayment) - totalOrder

    row_fmt = "{0:<15} {1:<50} {2:<30.2f} {3:<30.2f} {4:<30.2f} {5:<30.2f}"
    row = row_fmt.format(customer[0], customer[1], totalPayment, totalOrder, customer[2], availableCredit)
    print(row)
conn.close()