import subprocess

def task1():
    comm="wsl ls -l /var/log"
    try:
        p=subprocess.run(comm.split(),stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if p.returncode==0: 
            print(p.stdout.decode())
    except FileNotFoundError:
        print("command does not exist")
    except PermissionError:
        print("use sudo permissions")
    except Exception:
        print("some error occured")



def task2():
    comm="wsl systemctl status ssh"
    try:
        p=subprocess.run(comm.split(),stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if p.returncode==0: 
            print(p.stdout.decode())
    # except FileNotFoundError:
    #     print("command does not exist")
    # except PermissionError:
    #     print("use sudo permissions")
    except Exception:
        print("some error occured")

task2()