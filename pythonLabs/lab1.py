known_servers = ["nginx","docker"]
server_name=input("Please insert a server name:  ")
try:
    if(server_name.isascii==False or server_name=="" or server_name.isalnum()==False ):
        raise ValueError
except ValueError:
    print("invalid server name input")
else:
    if(known_servers.__contains__(server_name)):
        print ("server is running")
    else: print ("server is unrecognized")
        