import socket
import Static
import Action

listening_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
port = 9999
'''
host = socket.gethostbyname(socket.gethostname() )
'''
host = "127.0.0.1"


listening_socket.bind((host,port))

listening_socket.listen()
print("Server_listening")
while True:
    (client_Socket, address) = listening_socket.accept()

    message_data = client_Socket.recv(1024)
    message = message_data.decode('utf-8')

    #Data will be sent as 'Static,' or 'Action' to start a session

    if message == 'Static':
        Static.Start_static_Classifier(client_Socket)
    elif message == 'Action':
        Action.Start_Action_Classifier(client_Socket)
    
    
