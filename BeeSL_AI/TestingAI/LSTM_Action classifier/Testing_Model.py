import cv2
import os
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision

from mediapipe import solutions
from mediapipe.framework.formats import landmark_pb2


import numpy as np


def draw_landmarks(image, landmarks):
    for landmark in landmarks.landmark:
        # Get the x, y coordinates of the landmark (scaled to the image size)
        x = int(landmark.x * image.shape[1])
        y = int(landmark.y * image.shape[0])

        # Draw a circle at the landmark position
        cv2.circle(image, (x, y), 5, (0, 255, 0), -1)  # Green color, filled circle


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



def Process_multi_array( new_frame_data):
        global frame_Counter 
        global multi_Array
        multi_Array[frame_Counter] = new_frame_data    
        frame_Counter = (frame_Counter + 1)  
        print(str(frame_Counter))

def Setup_multiarray():
    multi_Array = []
    for item in range(10):
        multi_Array.append(fill_empty_landmarks(75))
    return multi_Array
    
def Handle_Prediction(prediction):
    prediction = np.array(prediction)

    index = np.argmax(prediction)
    return index
    
base_options = python.BaseOptions(model_asset_path='hand_landmarker.task')
options = vision.HandLandmarkerOptions(base_options=base_options,
                                       num_hands=2)
detector = vision.HandLandmarker.create_from_options(options)


mp_hands = mp.solutions.hands.Hands(static_image_mode=True, 
                                    max_num_hands=2, 
                                    min_detection_confidence=0.2,  # Adjust this value as needed
                                    min_tracking_confidence=0.2)

mp_pose = mp.solutions.pose.Pose(static_image_mode=True,                                     
                                    min_detection_confidence=0.2,  # Adjust this value as needed
                                    min_tracking_confidence=0.2)
from keras.models import load_model

class_Dictionary = Get_Classes()

multi_Array = Setup_multiarray()

# Load the saved model
loaded_model = load_model("Test_Model2_noBird.h5")

cap = cv2.VideoCapture(0)

frame_Counter = 0

import time
frames_number = 0
start_time = time.time()
elasped_time = 0
label = 'nothing'

while(True):
    ret, frame = cap.read()
    
    # Check if there are frames remaining
    if ret:
            
        image_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        hand_landmarker_result = mp_hands.process(image_rgb)
        pose_landmarker_result = mp_pose.process(image_rgb)
        
        hand_landmarks = get_hand_landmarks(hand_landmarker_result)
        pose_landmarks = get_pose_landmarks(pose_landmarker_result)
        
        Process_multi_array( hand_landmarks + pose_landmarks)
        
        
        if hand_landmarker_result.multi_hand_landmarks:
            # Iterate through each hand
            for hand_landmarks in hand_landmarker_result.multi_hand_landmarks:
                # Draw landmarks on the frame
                draw_landmarks(image_rgb, hand_landmarks)
        print(str(frame_Counter))
        if frame_Counter >9:
            frame_Counter = frame_Counter % 10
            numpy_dataset = np.array(multi_Array)
            
            data_reshape = numpy_dataset.reshape( 1,numpy_dataset.shape[0], numpy_dataset.shape[1] * numpy_dataset.shape[2])
            
            prediction = loaded_model.predict(data_reshape)
            label_index = Handle_Prediction(prediction)
            label = class_Dictionary[str(label_index)]
            
        frames_number = frames_number + 1
        elasped_time = time.time() - start_time
       
        font = cv2.FONT_HERSHEY_SIMPLEX
        org = (50, 50)  # Position (x,y) of the text
        font_scale = 1
        color = (255, 0, 0)  # BGR color (blue, green, red)
        thickness = 2

        # Put the text on the image
        frame_text = cv2.putText(image_rgb, label, org, font, font_scale, color, thickness, cv2.LINE_AA)

        

        cv2.imshow('frame',frame_text)
        print (label)
        print("FPS IS: " + str( frames_number/elasped_time) )
        time.sleep(0.02)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
        
        
        
        
        
        
    
        
        