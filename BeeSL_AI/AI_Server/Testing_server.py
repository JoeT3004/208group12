import socket

# create a socket object
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

port = 9999
IP_Host = "127.0.0.1"

    # establish connection with server
client.connect((IP_Host, port))
#Static



msg = 'Action'
client.send(msg.encode("utf-8")[:1024])
response = client.recv(1024)
response = response.decode("utf-8")

print(response)

while True:
    # input message and send it to the server
    msg = input("Enter message: ")
    client.send(msg.encode("utf-8")[:1024])
    response = client.recv(1024)
    response = response.decode("utf-8")
    
    print(response)