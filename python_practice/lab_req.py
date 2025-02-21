import requests
import json


class MeitarException(Exception):
    def __init__(self, message):
        if(message=="404"):
            print("User not found.")
        elif(message=="500"):
            print("Server error. Please try again later.")
        else:
            raise Exception

url="https://jsonplaceholder.typicode.com/users/1"
try:
    response=requests.get(url)
    response1 = response.json()
    if(response.status_code==200):
        name = response1 ["name"]
        add=response1["address"]
        email=response1["email"]
        print(f"name:{name}, add: {add}, email: {email}")
    else:
        raise MeitarException(f"{response.status_code}")
except MeitarException:
    pass
except Exception as e:
    print ("something went wrong")
    print(e)

