from fastapi import FastAPI
from models import ServerStatusResponse, Server, read_server_list,add_new_server

app = FastAPI()


@app.get("/server")
def get_server(server_name: str) -> ServerStatusResponse:
    #server_status = servers.get(server_name, "Does not exist")
    servers=read_server_list()
    for server in servers:
        if server.name==server_name:
            server_status=server.online
            return ServerStatusResponse(server_name=server_name, server_status=server_status)
    return ServerStatusResponse(server_name=server_name, server_status="did not find server")



@app.post("/server")
def create_server(server_name: str) -> ServerStatusResponse:
    new_server=Server(name=server_name, online=True, cpus=10,ram=20)
    add_new_server(new_server)
    return ServerStatusResponse(server_name=server_name, server_status="Created")

    
    # if server_name in servers:
    #     return ServerStatusResponse(server_name, "Name already exists")
    # else:
    #     servers[server_name] = True
    #     return ServerStatusResponse(server_name, "Created")