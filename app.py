from datetime import datetime,date
from flask import Flask, render_template, request, redirect, url_for, session
import json
import pypyodbc
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
import math
import pandas
import requests

import time
#from timeloop import Timeloop
from datetime import timedelta

app = Flask(__name__)

# Change this to your secret key (can be anything, it's for extra protection)
#app.secret_key = 'your secret key'

# Enter your database connection details below
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'labjes_demo'
app.config['MYSQL_PASSWORD'] = 'Adam@2341'
app.config['MYSQL_DB'] = 'labjes_taxiApp'

# Intialize MySQL
mysql = MySQL(app)


class create_dict(dict): 
  
    # __init__ function 
    def __init__(self): 
        self = dict() 
          
    # Function to add key:value 
    def add(self, key, value): 
        self[key] = value


#connection = pypyodbc.connect(
##    "Driver={SQL Server Native Client 11.0};"
 #   "Server=DESKTOP-5V1PA0N;"
 #   "Database=taxi app;"
 #   "Trusted_Connection=yes;"
 #   )

#Driver Login
@app.route('/driverLogin',methods=["POST"])
def dLogin():
    mydict=create_dict()
    print (request.is_json)

    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        email=content["email"]
        password=content["password"]

            # Check if account exists using MySQL
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM driver WHERE email = %s', [email])
        # Fetch one record and return result
        result = cursor.fetchone()
        
        if result == None:
            mydict.add("message","Email doesn't exist")
            mydict.add("success",False)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json
        else:
            
            if result["Password"]==password:

                tempDict=create_dict()
                tempDict.add("email",result["Email"])
                tempDict.add("idDriver",result["idDriver"])
                tempDict.add("name",result["FullName"])
                tempDict.add("car",result["CarMake"])
                tempDict.add("regno",result["RegistrationNo"])



                mydict.add("data",tempDict)
                mydict.add("message","Login Successful")
                mydict.add("success",True)

                stud_json = json.dumps(mydict, indent=2, sort_keys=True)
                return stud_json
            else:
                mydict.add("message","Password is not correct")
                mydict.add("success",False)

                stud_json = json.dumps(mydict, indent=2, sort_keys=True)
                return stud_json

    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


#Driver Signup
@app.route('/driverSignup',methods=["POST"])
def dSignup():
    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        email=content["email"]
        password=content["password"]
        name=content["name"]
        carmake=content["carmake"]
        regno=content["regno"]
        city=content["city"]
        postal=content["postal"]
        phone=content["phone"]
        lat=content["lat"]
        lng=content["lng"]

            # Check if account exists using MySQL
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select * from driver where driver.Email=%s",[email])
        rec=cursor.fetchone()

        if(rec!=None):
            mydict.add("message","Email already exist")
            mydict.add("success",False)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("INSERT INTO driver (FullName,Email,Password,CarMake,RegistrationNo,City,Postal,Phone,Latitude,Longitude) VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",[name,email,password,carmake,regno,city,postal,phone,lat,lng])
        mysql.connection.commit()
        # Fetch one record and return result
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select * from driver where driver.Email=%s",[email])
        rec=cursor.fetchone()

        if(rec!=None):
            tempDict=create_dict()
            tempDict.add("email",rec["Email"])
            tempDict.add("idDriver",rec["idDriver"])
            tempDict.add("name",rec["FullName"])
            tempDict.add("car",rec["CarMake"])
            tempDict.add("regno",rec["RegistrationNo"])

            mydict.add("data",tempDict)
            mydict.add("message","Account registered successful")
            mydict.add("success",True)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

        else:
            mydict.add("message","Something went wrong")
            mydict.add("success",False)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


#Restaurant Login
@app.route('/restLogin',methods=["POST"])
def rLogin():
    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        email=content["email"]
        password=content["password"]

            # Check if account exists using MySQL
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM restaurant WHERE email = %s', [email])
        # Fetch one record and return result
        result = cursor.fetchone()
        
        if result == None:
            mydict.add("message","Email doesn't exist")
            mydict.add("success",False)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json
        else:
            
            if result["Password"]==password:
                mydict.add("message","Login Succesfull")
                mydict.add("idRest",result["idRestaurant"])
                mydict.add("email",result["Email"])
                mydict.add("restName",result["RestaurantName"])
                mydict.add("lat",result["Latitude"])
                mydict.add("lng",result["Longitude"])
                mydict.add("success",True)
                stud_json = json.dumps(mydict, indent=2, sort_keys=True)
                return stud_json
            else:
                mydict.add("message","Password is not correct")
                mydict.add("success",False)

                stud_json = json.dumps(mydict, indent=2, sort_keys=True)
                return stud_json

    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


#Restaurant Signup
@app.route('/restSignup',methods=["POST"])
def rSignup():
    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        email=content["email"]
        password=content["password"]
        name=content["name"]
        restName=content["restName"]
        add=content["address"]
        city=content["city"]
        postal=content["postal"]
        phone=content["phone"]
        lat=content["lat"]
        lng=content["lng"]

            # Check if account exists using MySQL

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select * from restaurant where restaurant.Email=%s",[email])
        rec=cursor.fetchone()

        if(rec!=None):
            mydict.add("message","Email already exist")
            mydict.add("success",False)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("INSERT INTO restaurant (FullName,Email,Password,RestaurantName,Address,City,Postal,Phone,Latitude,Longitude) VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",[name,email,password,restName,add,city,postal,phone,lat,lng])
        mysql.connection.commit()
        # Fetch one record and return result
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select * from restaurant where restaurant.Email=%s",[email])
        rec=cursor.fetchone()

        if(rec!=None):
            mydict.add("message","Account registered successful")
            mydict.add("success",True)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

        else:
            mydict.add("message","Something went wrong")
            mydict.add("success",False)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


#Nearby Driver
@app.route('/nearbyDriver',methods=["POST"])
def nearbyDriver():
    mydict=create_dict()
    driverList=[]
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        
        restId=content["restId"]

            # Check if account exists using MySQL
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("SELECT idDriver,Email,CarMake,RegistrationNo,City,Postal,Latitude,Longitude,Status FROM driver WHERE driver.Status='Free'")
        records=cursor.fetchall()

        cursor.execute("SELECT Latitude,Longitude FROM restaurant WHERE restaurant.idRestaurant=%s",[int(restId)])
        rest=cursor.fetchone()

        for rec in records:
            R = 6373.0
            lat1 = math.radians(rec["Latitude"])
            lon1 = math.radians(rec["Longitude"])
            lat2 = math.radians(rest["Latitude"])
            lon2 = math.radians(rest["Longitude"])

            dlon = lon2 - lon1
            dlat = lat2 - lat1

            a = math.sin(dlat / 2)**2 + math.cos(lat1) * math.cos(lat2) * math.sin(dlon / 2)**2
            c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
            distance = R * c

            print(distance)

            if distance<=50:
                driver=create_dict()
                driver.add("FullName",rec["FullName"])
                driver.add("Carmake",rec["Carmake"])
                driver.add("regNo",rec["RegistrationNo"])
                driver.add("email",rec["Email"])
                driver.add("phone",rec["Phone"])
                driverList.append(driver)

        mydict.add("data",driverList)
        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


#UpdateDriverLocation
@app.route('/updateDLocation',methods=["POST"])
def updateDLoc():
    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        
        driverID=content["idDriver"]
        lat=content["lat"]
        lng=content["lng"]

            # Check if account exists using MySQL
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Update driver Set driver.Latitude=%s,driver.Longitude=%s where driver.idDriver=%s",[float(lat),float(lng),int(driverID)])
        mysql.connection.commit()

        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

def onesignalNotification(usersList,detail):
    header = {"Content-Type": "application/json; charset=utf-8",
              "Authorization": "Basic YTJmNGZlNDgtNWJlNy00YTk2LTliOTUtN2M3NWQ2MDBiMWRi"}

    message = "Hurray, New job is available for you. Please check it as soon as possible\n\n"+detail

    payload = {"app_id": "bd55ce90-1c6c-448d-912c-d258b7c1cb27",
               "include_external_user_ids": usersList,
               "contents": {"en": message},
               "headings": {"en": "Job Notification"},
               "big_picture":"https://img.onesignal.com/n/2debfc59-c683-4829-9d90-062c4e126b14.png"

               }

    data  = requests.post("https://onesignal.com/api/v1/notifications", headers=header,
                  data=json.dumps(payload))
    print(data)

    # return render_template("manufacture.html")
    return "true"

#Create Order

# tl = Timeloop()

# @tl.job(interval=timedelta(seconds=1))
# def expiryCheck():
#     cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
#     cursor.execute("Select Status from shareuri_taxiApp.order Where idOrder=%s",[idOrder])
#     result=cursor.fetchone()
#     if result["Status"]=="Not Accepted":
#         cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
#         cursor.execute("Select Timestamp from shareuri_taxiApp.order Where idOrder=%s",[idOrder])
#         result=cursor.fetchone()
#         print(time.ctime())
#     else:
#         t1.stop()


@app.route('/createOrder',methods=["POST"])
def createOrder():
    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        cName=content["cName"]
        cPhone=content["cPhone"]
        dAddress=content["dAddress"]
        orderValue=content["orderValue"]
        time=content["time"]
        postcode=content["postcode"]
        price=content["price"]
        idRest=content["idRest"]
        

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("INSERT INTO shareuri_taxiApp.order (CustomerName,CustomerPhone,DestAddress,idRest,orderValue,time,postcode,price) VALUES(%s,%s,%s,%s,%s,%s,%s,%s)",[cName,cPhone,dAddress,idRest,orderValue,time,postcode,price])
        mysql.connection.commit()
        # Fetch one record and return result
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select LAST_INSERT_ID() AS latest")
        rec=cursor.fetchone()

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select * From shareuri_taxiApp.order Where shareuri_taxiApp.order.idOrder=%s",[rec["latest"]])
        rec=cursor.fetchone()

        def convert(d):
            if isinstance(d,datetime):
                return d.__str__()

        if(rec!=None):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("Select idDriver From shareuri_taxiApp.driver Where shareuri_taxiApp.driver.Membership=%s",["Valid"])
            rec=cursor.fetchall()

            print(rec)
            userlist=[]
            for r in rec:
                userlist.append(str(r["idDriver"]))

            print(userlist)
            detail="Customer Name: "+cName+"\n"+"Destination Address: "+dAddress
            print(onesignalNotification(userlist,detail))
            mydict.add("message","Order created successful")
            mydict.add("data",json.dumps(rec, indent=2, sort_keys=True,default=convert))
            mydict.add("success",True)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

        else:
            mydict.add("message","Something went wrong")
            mydict.add("success",False)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


@app.route("/orderNotify")
def orderNotify():
    mydict=create_dict()

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("Select max(shareuri_taxiApp.order.idOrder) as latest from shareuri_taxiApp.order Where shareuri_taxiApp.order.Status='Not Accepted'")
    rec=cursor.fetchone()

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("Select CustomerName,CustomerPhone,DestAddress,idRest from shareuri_taxiApp.order Where idOrder=%s",[rec["latest"]])
    rec1=cursor.fetchone()

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("Select idRestaurant,RestaurantName,Address,City from shareuri_taxiApp.restaurant Where idRestaurant=%s",[rec1["idRest"]])
    rec2=cursor.fetchone()

    dataDict=create_dict()
    dataDict.add("idOrder",rec["latest"])
    dataDict.add("idRestaurant",rec2["idRestaurant"])
    dataDict.add("cName",rec1["CustomerName"])
    dataDict.add("cPhone",rec1["CustomerPhone"])
    dataDict.add("dAddress",rec1["DestAddress"])
    dataDict.add("rName",rec2["RestaurantName"])
    dataDict.add("rAddress",rec2["Address"])
    dataDict.add("city",rec2["City"])

    if(rec!=None):
        mydict.add("data",dataDict)
        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

    else:
        mydict.add("message","Something went wrong")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

@app.route("/orderAccept",methods=["POST"])
def orderAccept():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idOrder=content["idOrder"]
        idDriver=content["idDriver"]
        time=content["time"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select idDriver,Status from shareuri_taxiApp.order Where idOrder=%s",[idOrder])
        result=cursor.fetchone()

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select Status from shareuri_taxiApp.driver Where idDriver=%s",[idDriver])
        result2=cursor.fetchone()

        print(result2["Status"])
        if result2["Status"]=="Free":
            
            if result["idDriver"]==None and result["Status"]=="Not Accepted":
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute("Update shareuri_taxiApp.order Set Status=%s,idDriver=%s,time=%s where idOrder=%s",["Accepted",idDriver,time,idOrder])
                mysql.connection.commit()

                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute("Update shareuri_taxiApp.driver Set Status=%s where idDriver=%s",["Busy",idDriver])
                mysql.connection.commit()

                mydict.add("success",True)

                stud_json = json.dumps(mydict, indent=2, sort_keys=True)
                return stud_json
            else:
                mydict.add("success",False)
                mydict.add("message","Job is already assigned to someone else")

                stud_json = json.dumps(mydict, indent=2, sort_keys=True)
                return stud_json

        else:
            mydict.add("success",False)
            mydict.add("message","You are already engage in another job. Please complete it first")

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


@app.route("/cancelOrder",methods=["POST"])
def cancelOrder():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idOrder=content["idOrder"]
        idDriver=content["idDriver"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select idDriver,Status from shareuri_taxiApp.order Where idOrder=%s",[idOrder])
        result=cursor.fetchone()

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select Status from shareuri_taxiApp.driver Where idDriver=%s",[idDriver])
        result2=cursor.fetchone()

        print(result2["Status"])
        if result2["Status"]=="Busy":
            
            if result["idDriver"]==idDriver and result["Status"]=="Accepted":
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute("Update shareuri_taxiApp.order Set Status=%s,idDriver=%s,time=%s where idOrder=%s",["Not Accepted",None,None,idOrder])
                mysql.connection.commit()

                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute("Update shareuri_taxiApp.driver Set Status=%s where idDriver=%s",["Free",idDriver])
                mysql.connection.commit()

                mydict.add("success",True)

                stud_json = json.dumps(mydict, indent=2, sort_keys=True)
                return stud_json
            else:
                mydict.add("success",False)
                mydict.add("message","This Job belongs to someone else")

                stud_json = json.dumps(mydict, indent=2, sort_keys=True)
                return stud_json

        else:
            mydict.add("success",False)
            mydict.add("message","You are free now for another job.")

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

@app.route("/driverValidity",methods=["POST"])
def driverValidity():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idDriver=content["idDriver"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select Membership,ActivationDate from driver Where idDriver=%s",[idDriver])
        rec=cursor.fetchone()

        if rec["Membership"]=="Valid":
            dif=date.today()-rec["ActivationDate"]
            if dif.days<=30:
                mydict.add("message","Your account is already activated")
                mydict.add("success",True)

                stud_json = json.dumps(mydict, indent=2, sort_keys=True)
                return stud_json
            else:
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute("Update shareuri_taxiApp.driver Set Membership=%s where idDriver=%s",["Not Valid",idDriver])
                mysql.connection.commit()

                mydict.add("success",False)

                stud_json = json.dumps(mydict, indent=2, sort_keys=True)
                return stud_json

        else:
            mydict.add("success",False)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


@app.route("/checkBalance",methods=["POST"])
def checkbalance():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idDriver=content["idDriver"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select Membership,ActivationDate,Balance from shareuri_taxiApp.driver where idDriver=%s",[idDriver])
        rec=cursor.fetchone()

        temp=create_dict()
        temp.add("Membership",rec["Membership"])
        temp.add("ActivationDate",str(rec["ActivationDate"]))
        temp.add("Balance",rec["Balance"])

        mydict.add("data",temp)
        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


@app.route("/buyMembership",methods=["POST"])
def buyMembership():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idDriver=content["idDriver"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Update shareuri_taxiApp.driver Set Membership=%s,ActivationDate=%s where idDriver=%s",["Valid",date.today(),idDriver])
        mysql.connection.commit()

        mydict.add("message","Your account has been activated")
        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

@app.route("/inProgress",methods=["POST"])
def inProgress():
    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idOrder=content["idOrder"]
        idDriver=content["idDriver"]

        print(idOrder)
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select idDriver,Status from shareuri_taxiApp.order Where idOrder=%s",[idOrder])
        result=cursor.fetchone()
        print(result["idDriver"])
        print(idDriver)
        if result["idDriver"]==idDriver and result["Status"]=="Accepted":

            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("Update shareuri_taxiApp.order Set Status=%s where idOrder=%s",["In Progress",idOrder])
            mysql.connection.commit()

            mydict.add("message","Your job has been started")
            mydict.add("success",True)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

        else:
            mydict.add("success",False)
            mydict.add("message","This Job belongs to another driver")

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json


    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

#all in progress order of a driver
@app.route("/inProgressOrders",methods=["POST"])
def inProgressOrders():
    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idDriver=content["idDriver"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select CustomerName,CustomerPhone,DestAddress,idRest,restaurant.RestaurantName,restaurant.Address,restaurant.Postal,restaurant.Latitude,restaurant.Longitude,postcode,order.Status,order.idOrder from shareuri_taxiApp.order INNER JOIN restaurant ON shareuri_taxiApp.order.idRest=shareuri_taxiApp.restaurant.idRestaurant Where (order.Status=%s or order.Status=%s) and idDriver=%s",["In Progress","Accepted",idDriver])
        rec=cursor.fetchall()

        mydict.add("data",rec)
        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


#all in progress order of a driver
@app.route("/CompleteOrders",methods=["POST"])
def CompleteOrders():
    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idDriver=content["idDriver"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select CustomerName,CustomerPhone,price,DestAddress,idRest,restaurant.RestaurantName,restaurant.Address,restaurant.Postal,postcode,order.Status,order.idOrder from shareuri_taxiApp.order INNER JOIN restaurant ON shareuri_taxiApp.order.idRest=shareuri_taxiApp.restaurant.idRestaurant Where shareuri_taxiApp.order.Status=%s and idDriver=%s",["Complete",idDriver])
        rec=cursor.fetchall()

        mydict.add("data",rec)
        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


#all in progress order of a driver
@app.route("/ordersList")
def OrdersList():
    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'GET':
        
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select CustomerName,CustomerPhone,DestAddress,idRest,restaurant.RestaurantName,restaurant.Email,restaurant.Address,restaurant.City,restaurant.Postal,restaurant.Latitude,restaurant.Longitude,postcode,order.idOrder from shareuri_taxiApp.order INNER JOIN restaurant ON shareuri_taxiApp.order.idRest=shareuri_taxiApp.restaurant.idRestaurant Where shareuri_taxiApp.order.Status=%s",["Not Accepted"])
        rec=cursor.fetchall()

        mydict.add("data",rec)
        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


@app.route("/checkDriverStatus",methods=["POST"])
def checkDriverStatus():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idDriver=content["idDriver"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select Status from shareuri_taxiApp.driver where idDriver=%s",[idDriver])
        rec=cursor.fetchone()

        if rec["Status"]=="Free":
            mydict.add("success",True)
        else:
            mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

@app.route("/checkOrderStatus",methods=["POST"])
def checkOrderStatus():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idOrder=content["idOrder"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select Status,idDriver,time from shareuri_taxiApp.order where idOrder=%s",[idOrder])
        rec=cursor.fetchone()

        if rec["idDriver"]!=None:
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("Select FullName,CarMake,RegistrationNo from shareuri_taxiApp.driver where idDriver=%s",[rec["idDriver"]])
            rec1=cursor.fetchone()
            #Merge(rec1, rec)
            z = {**rec1, **rec}
            mydict.add("data",z)
            mydict.add("success",True)
        else:
            mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


@app.route("/getDriverInfo",methods=["POST"])
def getDriverInfo():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idDriver=content["idDriver"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select * from shareuri_taxiApp.driver where idDriver=%s",[idDriver])
        rec=cursor.fetchone()

        if rec!=None:
            temp=create_dict()

            temp.add("name",rec["FullName"])
            temp.add("email",rec["Email"])
            temp.add("password",rec["Password"])
            temp.add("carmake",rec["CarMake"])
            temp.add("regno",rec["RegistrationNo"])
            temp.add("city",rec["City"])
            temp.add("postal",rec["Postal"])
            temp.add("phone",rec["Phone"])
            mydict.add("data",temp)
            mydict.add("success",True)
        else:
            mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

@app.route("/updateDriverInfo",methods=["POST"])
def updateDriverInfo():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idDriver=content["idDriver"]
        name=content["name"]
        email=content["email"]
        password=content["password"]
        carmake=content["carmake"]
        city=content["city"]
        postal=content["postal"]
        phone=content["phone"]
        regno=content["regno"]


        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Update shareuri_taxiApp.driver Set FullName=%s,Password=%s,CarMake=%s,Postal=%s,City=%s,RegistrationNo=%s,Phone=%s where idDriver=%s and Email=%s",[name,password,carmake,postal,city,regno,phone,idDriver,email])
        mysql.connection.commit()

        
        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


@app.route("/getrestaurantLocation",methods=["POST"])
def getrestaurantLocation():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idDriver=content["idDriver"]
        idOrder=content["idOrder"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select restaurant.Latitude,restaurant.Longitude,restaurant.Phone from shareuri_taxiApp.order INNER JOIN restaurant ON shareuri_taxiApp.order.idRest=shareuri_taxiApp.restaurant.idRestaurant where idDriver=%s and idOrder=%s",[idDriver,idOrder])
        rec=cursor.fetchone()

        if rec!=None:
            temp=create_dict()

            temp.add("lat",rec["Latitude"])
            temp.add("lng",rec["Longitude"])
            temp.add("phone",rec["Phone"])
            
            mydict.add("data",temp)
            mydict.add("success",True)
        else:
            mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


@app.route("/orderComplete",methods=["POST"])
def orderComplete():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idOrder=content["idOrder"]
        idDriver=content["idDriver"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Update shareuri_taxiApp.order Set Status=%s where idOrder=%s",["Complete",idOrder])
        mysql.connection.commit()

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Update shareuri_taxiApp.driver Set Status=%s where idDriver=%s",["Free",idDriver])
        mysql.connection.commit()

        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

@app.route("/jobDelete",methods=["POST"])
def jobDelete():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idOrder=content["idOrder"]
        idRest=content["idRest"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Delete from shareuri_taxiApp.order where idOrder=%s and idRest=%s",[idOrder,idRest])
        mysql.connection.commit()

        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

@app.route('/driverHistory',methods=["POST"])
def driverHistory():
    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idDriver=content["idDriver"]
        
        # Check if account exists using MySQL

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select * from shareuri_taxiApp.order where Status=%s and idDriver=%s",['Accepted',idDriver])
        rec=cursor.fetchall()

        if(rec==None):
            mydict.add("message","No history found")
            mydict.add("success",False)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

        else:
            tempDic=create_dict()
            tempList=[]
            
            for r in rec:
                tempDic.add("")
            
            mydict.add("data",temp)
            mydict.add("success",True)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

#all orders of a restaurant
@app.route("/rordersList",methods=["POST"])
def ROrdersList():
    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idRest=content["idRest"]
        
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select CustomerName,CustomerPhone,DestAddress,idOrder from shareuri_taxiApp.order Where shareuri_taxiApp.order.Status=%s  and shareuri_taxiApp.order.idRest=%s",["Not Accepted",idRest])
        rec=cursor.fetchall()

        mydict.add("data",rec)
        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

#all orders of a restaurant
@app.route("/rInProgressList",methods=["POST"])
def rInProgressList():
    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idRest=content["idRest"]
        
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select CustomerName,CustomerPhone,DestAddress,idOrder,driver.idDriver,driver.FullName,driver.Email,driver.Phone,driver.Latitude,driver.Longitude,driver.CarMake,driver.RegistrationNo from shareuri_taxiApp.order INNER JOIN driver ON shareuri_taxiApp.order.idDriver=shareuri_taxiApp.driver.idDriver Where shareuri_taxiApp.order.Status=%s and shareuri_taxiApp.order.idRest=%s",["Accepted" or "In Progress",idRest])
        rec=cursor.fetchall()

        mydict.add("data",rec)
        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

@app.route("/rCompletedList",methods=["POST"])
def rCompleteList():
    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idRest=content["idRest"]
        
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select CustomerName,CustomerPhone,DestAddress,idOrder,driver.idDriver,driver.FullName,driver.Email,driver.Phone,driver.Latitude,driver.Longitude,driver.CarMake,driver.RegistrationNo from shareuri_taxiApp.order INNER JOIN driver ON shareuri_taxiApp.order.idDriver=shareuri_taxiApp.driver.idDriver Where shareuri_taxiApp.order.Status=%s and shareuri_taxiApp.order.idRest=%s",["Complete",idRest])
        rec=cursor.fetchall()

        mydict.add("data",rec)
        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

@app.route("/rcheckBalance",methods=["POST"])
def rcheckbalance():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idRest=content["idRest"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select Status,Balance from shareuri_taxiApp.restaurant where idRestaurant=%s",[idRest])
        rec=cursor.fetchone()

        temp=create_dict()
        temp.add("Status",rec["Status"])
        temp.add("Balance",rec["Balance"])

        mydict.add("data",temp)
        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


@app.route("/getPostCodes",methods=["POST"])
def getPostCodes():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idRest=content["idRest"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select postcode,price from shareuri_taxiApp.postcodeprice where idRest=%s",[idRest])
        rec=cursor.fetchall()

        if rec!=None:
            mydict.add("data",rec)
            mydict.add("success",True)
        else:
            mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


@app.route("/deletePostCode",methods=["POST"])
def deletePostCode():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idRest=content["idRest"]
        postcode=content["postcode"]
        
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select * From shareuri_taxiApp.postcodeprice Where shareuri_taxiApp.postcodeprice.idRest=%s and shareuri_taxiApp.postcodeprice.postcode=%s",[idRest,postcode])
        rec=cursor.fetchone()
        
        if rec==None:
            mydict.add("message","This postcode is not exist")
            mydict.add("success",False)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Delete from shareuri_taxiApp.postcodeprice where idRest=%s and postcode=%s",[idRest,postcode])
        mysql.connection.commit()

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select * from shareuri_taxiApp.postcodeprice where idRest=%s and postcode=%s",[idRest,postcode])
        rec=cursor.fetchone()

        if rec!=None:
            mydict.add("success",False)
        else:
            mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


@app.route('/addPostCode',methods=["POST"])
def addPostCode():
    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        price=content["price"]
        postcode=content["postcode"]
        idRest=content["idRest"]
        
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select * From shareuri_taxiApp.postcodeprice Where shareuri_taxiApp.postcodeprice.idRest=%s and shareuri_taxiApp.postcodeprice.postcode=%s",[idRest,postcode])
        rec=cursor.fetchone()
        
        if rec!=None:
            mydict.add("message","This postcode is already exist")
            mydict.add("success",False)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json
            

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("INSERT INTO shareuri_taxiApp.postcodeprice (idRest,postcode,price) VALUES(%s,%s,%s)",[idRest,postcode,price])
        mysql.connection.commit()
        # Fetch one record and return result
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select LAST_INSERT_ID() AS latest")
        rec=cursor.fetchone()

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select * From shareuri_taxiApp.postcodeprice Where shareuri_taxiApp.postcodeprice.idRest=%s and shareuri_taxiApp.postcodeprice.postcode=%s",[idRest,postcode])
        rec=cursor.fetchone()

        if(rec!=None):
            mydict.add("success",True)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

        else:
            mydict.add("message","Something went wrong")
            mydict.add("success",False)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json


@app.route("/editPostCode",methods=["POST"])
def editPostCode():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        postcode=content["postcode"]
        idRest=content["idRest"]
        price=content["price"]
        
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select * From shareuri_taxiApp.postcodeprice Where shareuri_taxiApp.postcodeprice.idRest=%s and shareuri_taxiApp.postcodeprice.postcode=%s",[idRest,postcode])
        rec=cursor.fetchone()
        
        if rec==None:
            mydict.add("message","This postcode is not exist")
            mydict.add("success",False)

            stud_json = json.dumps(mydict, indent=2, sort_keys=True)
            return stud_json

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Update shareuri_taxiApp.postcodeprice Set price=%s where idRest=%s and postcode=%s",[price,idRest,postcode])
        mysql.connection.commit()

        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
        

@app.route("/getRestInfo",methods=["POST"])
def getRestInfo():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idRest=content["idRest"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Select * from restaurant where idRestaurant=%s",[idRest])
        rec=cursor.fetchone()

        if rec!=None:
            temp=create_dict()

            temp.add("name",rec["FullName"])
            temp.add("email",rec["Email"])
            temp.add("password",rec["Password"])
            temp.add("restName",rec["RestaurantName"])
            temp.add("address",rec["Address"])
            temp.add("city",rec["City"])
            temp.add("postal",rec["Postal"])
            temp.add("phone",rec["Phone"])
            mydict.add("data",temp)
            mydict.add("success",True)
        else:
            mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json

@app.route("/updateRestInfo",methods=["POST"])
def updateRestInfo():

    mydict=create_dict()
    print (request.is_json)
    
    if request.method == 'POST' and request.is_json:
        content=request.get_json()
        idRest=content["idRest"]
        name=content["name"]
        email=content["email"]
        password=content["password"]
        restName=content["restName"]
        city=content["city"]
        postal=content["postal"]
        phone=content["phone"]
        address=content["address"]


        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("Update restaurant Set FullName=%s,Password=%s,RestaurantName=%s,Postal=%s,City=%s,Address=%s,Phone=%s where idRestaurant=%s and Email=%s",[name,password,restName,postal,city,address,phone,idRest,email])
        mysql.connection.commit()

        
        mydict.add("success",True)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json
    else:
        mydict.add("message","Wrong format")
        mydict.add("success",False)

        stud_json = json.dumps(mydict, indent=2, sort_keys=True)
        return stud_json



if __name__ == "__main__":
    app.run()



