import cv2
import os
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision

from mediapipe import solutions
from mediapipe.framework.formats import landmark_pb2


import numpy as np



    

def fill_empty_landmarks(landmark_count):
    landmarks = []
    for item in range(landmark_count):
        landmarks.append((0,0))
    return landmarks
    

def get_pose_landmarks(pose_landmarker_result):
    
    if not pose_landmarker_result.pose_landmarks:
        return fill_empty_landmarks(33)
    
    pose_landmarks = []        
        
    for landmark in pose_landmarker_result.pose_landmarks.landmark:
        x, y = landmark.x, landmark.y 
        pose_landmarks.append((x,y))
    
    return pose_landmarks

def get_hand_landmarks(hand_landmarker_result):
    
    if not hand_landmarker_result.multi_hand_landmarks:
        return fill_empty_landmarks(42)
    
    landmarks = []        
    
    if len( hand_landmarker_result.multi_hand_landmarks) != 2:
        landmarks = landmarks + fill_empty_landmarks(21)
        
    for hand_landmarks in hand_landmarker_result.multi_hand_landmarks:
        
        for landmark in hand_landmarks.landmark:
            x, y = landmark.x, landmark.y 
            landmarks.append((x,y))
    return landmarks

             
def Get_Classes():
    e = open("number_to_label.txt", "r")
    class_dictionary = {}
    for item in e:
        line_array = item.split(',')
        class_dictionary[line_array[0]] = line_array[2]
    return class_dictionary

def Setup_multiarray():
    multi_Array = []
    for item in range(10):
        multi_Array.append(fill_empty_landmarks(75))
    return multi_Array

multi_Array = Setup_multiarray()
frame_Counter = 0

def Process_multi_array( new_frame_data):
        global frame_Counter 
        global multi_Array
        multi_Array[frame_Counter] = new_frame_data    
        frame_Counter = (frame_Counter + 1)  
        print(str(frame_Counter))


    
def Handle_Prediction(prediction):
    prediction = np.array(prediction)

    index = np.argmax(prediction)
    return index
    
#base_options = python.BaseOptions(model_asset_path='hand_landmarker.task')
#options = vision.HandLandmarkerOptions(base_options=base_options, num_hands=2)
#detector = vision.HandLandmarker.create_from_options(options)


mp_hands = mp.solutions.hands.Hands(static_image_mode=True, 
                                    max_num_hands=2, 
                                    min_detection_confidence=0.2,  # Adjust this value as needed
                                    min_tracking_confidence=0.2)

mp_pose = mp.solutions.pose.Pose(static_image_mode=True,                                     
                                    min_detection_confidence=0.2,  # Adjust this value as needed
                                    min_tracking_confidence=0.2)

from keras.models import load_model
import time


def Start_Session(client_socket):
    global frame_Counter 
    global multi_Array
    
    client_socket.settimeout(45) 
    class_Dictionary = Get_Classes()


    # Load the saved model
    loaded_model = load_model("Test_Model_long.h5")

    start_time_Overall = time.time()    
    frames_number = 0
    start_time = time.time()
    elasped_time = 0
    label = 'nothing'
    
    
    vc = cv2.VideoCapture(0)

  #means that socket will timeout if message is not recieved within 15 seconds 
     
  
    time_for_each_question = 30
        
    message_data = client_socket.recv(1024)
    test_Action = message_data.decode('utf-8')+'\n'
    print(test_Action)
    
    #Need to setup first letter but is a posttest loop so that end can end the loop
    
    cap = cv2.VideoCapture(0)
    
    while test_Action != "end\n":
        
        correct_action = False
        
        start_time_Overall = time.time()  

        while correct_action == False and ( time.time() -start_time_Overall  ) < time_for_each_question:
            ret, frame = cap.read()
            
        
                
            image_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            hand_landmarker_result = mp_hands.process(image_rgb)
            pose_landmarker_result = mp_pose.process(image_rgb)
            
            hand_landmarks = get_hand_landmarks(hand_landmarker_result)
            pose_landmarks = get_pose_landmarks(pose_landmarker_result)
            
            Process_multi_array( hand_landmarks + pose_landmarks)
            
            if frame_Counter >9:
                frame_Counter = frame_Counter % 10
                numpy_dataset = np.array(multi_Array)
                
                data_reshape = numpy_dataset.reshape( 1,numpy_dataset.shape[0], numpy_dataset.shape[1] * numpy_dataset.shape[2])
                
                prediction = loaded_model.predict(data_reshape)
                label_index = Handle_Prediction(prediction)
                label = class_Dictionary[str(label_index)]
                print(str(time.time() -start_time_Overall ) )
                if label == test_Action or label ==test_Action+'?' :
                    correct_action = True 
                
            frames_number = frames_number + 1
            elasped_time = time.time() - start_time
        

            cv2.imshow('frame',frame)
            print (label)
            print("FPS IS: " + str( frames_number/elasped_time) )
            time.sleep(0.02)
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
        
        if correct_action == True:
            message_back = 'C'
            client_socket.sendall(message_back.encode('utf-8'))
        else:
            try:
                message_back = 'F'
                client_socket.sendall(message_back.encode('utf-8'))
            except:
                break
       
        client_socket.settimeout(15) 
        message_data = client_socket.recv(1024)
        test_Action = message_data.decode('utf-8')+'\n'
        print(len(test_Action) ) 
        
        print(test_Action)
    
                    


def Start_Action_Classifier(incoming_socket):
  client_socket = incoming_socket
  message_back = 'Action Session Started'
  client_socket.sendall(message_back.encode('utf-8'))
  Start_Session(client_socket)
  
