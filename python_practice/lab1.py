import logging
import sys
import os


class InvalidServerNameError(Exception):    
    def __init__(self):#,message):
        #self.message=message
       print("<----InvalidServerNameError---->")
        
logger1=logging.getLogger(name="loggerMeitar")
logger1.setLevel(logging.DEBUG)
formatter = logging.Formatter("handler 1: %(asctime)s - %(levelname)s - %(message)s")
formatter2 = logging.Formatter("handler 2 :%(asctime)s - %(levelname)s - %(message)s")

handler=logging.StreamHandler(stream=sys.stdout)
handler2=logging.StreamHandler(stream=sys.stderr)
handler.setFormatter(formatter)
handler2.setFormatter(formatter2)
logger1.addHandler(handler)
logger1.addHandler(handler2)
        
server=input("please enter a server name: ")
server=server.strip()
try:
    if server == "" or server.isalnum() == False:
        logger1.error("")
        raise InvalidServerNameError()       
except InvalidServerNameError:    
    print("blah blah")

servers=["a","b","c","d"]

def check_service_status(server_name):
    try:
        if server_name in servers:
            logger1.info("running server")
            return "running"
        else: raise ValueError()
    except ValueError:
        logger1.error("ValueError")
        return "ValueError raised"


#print(check_service_status("gg"))
        