import logging
import sys
import os
import json

log_level = os.environ.get("LOG_LEVEL","DEBUG")
log_format=os.environ.get("LOG_FORMAT","TEXT")

class InvalidServerNameError(Exception):
    def __init__(self, message):
        self.message = message
        super().__init__(self.message)
 
invalidSNlogger=logging.getLogger("invalidServerNameLogger")#creating custom logger for invalis input for server name
invalidSNlogger.setLevel(log_level)#defining the logger to log only for log_level exceptions and up

class JSONformatter(logging.Formatter):
    def dormat(self,record:logging.LogRecord) -> str:
        log={"timestamp":self.formatTime(record,self.datemt), 
             "level":record.levelname, 
             "message":record.getMessage
        }
        return json.dumps(log)
    
handler = logging.StreamHandler(sys.stdout)#creating handler to print logs to standard output
if log_format=="JSON":
    handler.setFormatter(JSONformatter())
else:
    log_format="%(ascitime)s:%(name)s:%(module)s"
    handler.setFormatter(logging.Formatter(log_format))

invalidSNlogger.addHandler(handler)#connecting handler to logger

def check_service_status(server_name):
    try:
        if(known_servers.__contains__(server_name)):
            print ("server is running")
            #log success??
        else: 
            raise ValueError()
    except ValueError:
        #log unrecognized??
        pass

known_servers = ["nginx","docker"]

while True:
    server_name=input("Please insert a server name:  ")
    server_name=server_name.strip()
    try:
        if(server_name.isascii==False or server_name=="" or server_name.isalnum()==False ):
            raise InvalidServerNameError("mosko")
    except InvalidServerNameError:
        invalidSNlogger.error("invalid server name error occured: ")
    else:
        str=check_service_status(server_name)
        