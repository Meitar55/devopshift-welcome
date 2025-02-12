import httpx
from models import MyHTTPError

# class MyHTTPError(Exception):
#     """Exception raised for custom error scenarios.

#     Attributes:
#         message -- explanation of the error
#     """
#     def _init_(self, message):
#         self.message = message
#         super()._init_(self.message)

url_json_spaceholder = "https://jsonplaceholder.typicode.com/"
url_ext_users="/users"
url_ext_singleUser_endpoint="/1"


def printUserData(response):
    user_name=response["name"]
    user_Email=response["email"]
    user_add=response["address"]
    user_add_st=user_add["street"]
    user_add_c=user_add["city"]

    print(f"""User Data:
    Name: {user_name}
    Email: {user_Email}
    Address: {user_add_st}, {user_add_c}
    """)

try:
    response=httpx.get("".join([url_json_spaceholder,url_ext_users,url_ext_singleUser_endpoint]),
                   )
    try:
        response_code=response.status_code
        response.raise_for_status()
        response=response.json()
    except httpx.HTTPStatusError:
        if (response_code==404):
            print("User not found.")
        elif (response_code>=500):
            print("Server error. Please try again later.")
        else:
            raise MyHTTPError
    except MyHTTPError as e:
        print ("MyHTTPError occured")
    printUserData(response)
except httpx.HTTPError:
    print("cannot connect")
    
    
    

