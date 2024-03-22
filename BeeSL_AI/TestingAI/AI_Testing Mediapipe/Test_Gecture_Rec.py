import mediapipe 
import cv2

import math

import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision

base_options = python.BaseOptions(model_asset_path='exported_model_6_(copy)\gesture_recognizer.task')
options = vision.GestureRecognizerOptions(base_options=base_options)
recognizer = vision.GestureRecognizer.create_from_options(options)




from mediapipe import solutions
from mediapipe.framework.formats import landmark_pb2
import numpy as np
import cv2

def Handdraw_landmarks_on_image(rgb_image, detection_result):
  hand_landmarks_list =     detection_result.hand_landmarks
  handedness_list = detection_result.handedness
  annotated_image = np.copy(rgb_image)

  # Loop through the detected hands to visualize.
  for idx in range(len(hand_landmarks_list)):
    hand_landmarks = hand_landmarks_list[idx]
    handedness = handedness_list[idx]

    # Draw the hand landmarks.
    hand_landmarks_proto = landmark_pb2.NormalizedLandmarkList()
    hand_landmarks_proto.landmark.extend([
      landmark_pb2.NormalizedLandmark(x=landmark.x, y=landmark.y, z=landmark.z) for landmark in hand_landmarks
    ])
    solutions.drawing_utils.draw_landmarks(
      annotated_image,
      hand_landmarks_proto,
      solutions.hands.HAND_CONNECTIONS,
      solutions.drawing_styles.get_default_hand_landmarks_style(),
      solutions.drawing_styles.get_default_hand_connections_style())

    # Get the top left corner of the detected hand's bounding box.
    height, width, _ = annotated_image.shape
    x_coordinates = [landmark.x for landmark in hand_landmarks]
    y_coordinates = [landmark.y for landmark in hand_landmarks]
    # Draw handedness (left or right hand) on the image.
    

  return annotated_image

def draw_landmarks_on_image(rgb_image, detection_result):
  pose_landmarks_list = detection_result.pose_landmarks
  annotated_image = np.copy(rgb_image)

  # Loop through the detected poses to visualize.
  for idx in range(len(pose_landmarks_list)):
    pose_landmarks = pose_landmarks_list[idx]

    # Draw the pose landmarks.
    pose_landmarks_proto = landmark_pb2.NormalizedLandmarkList()
    pose_landmarks_proto.landmark.extend([
      landmark_pb2.NormalizedLandmark(x=landmark.x, y=landmark.y, z=landmark.z) for landmark in pose_landmarks
    ])
    solutions.drawing_utils.draw_landmarks(
      annotated_image,
      pose_landmarks_proto,
      solutions.pose.POSE_CONNECTIONS,
      solutions.drawing_styles.get_default_pose_landmarks_style())
  return annotated_image

import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision


import cv2


vc = cv2.VideoCapture(0)


while True:
    #img = me.get_frame_read().frame
    rval, img = vc.read()
    image = mp.Image(
    image_format=mp.ImageFormat.SRGB,  # Adjust format based on your image data
    data=img)
    
    recognition_result = recognizer.recognize(image)
    gesture = 'none'
    if(len(recognition_result.gestures) >0):
        top_gesture = recognition_result.gestures[0][0]    
        #categoryName 
        #categoryName 
        gesture = getattr(top_gesture, 'category_name')
        print(gesture)
    #hand_landmarks = recognition_result.hand_landmarks    
    #cv2_imshow(cv2.cvtColor(annotated_image, cv2.COLOR_RGB2BGR))

    #Handannotated_image = Handdraw_landmarks_on_image(image.numpy_view(), recognition_result)
    
    # font 
    font = cv2.FONT_HERSHEY_SIMPLEX 
    
    # org 
    org = (50, 50) 
    
    # fontScale 
    fontScale = 1
    
    # Blue color in BGR 
    color = (255, 0, 0) 
    
    # Line thickness of 2 px 
    thickness = 2
    #np.copy(image.numpy_view())
    final_image = cv2.putText(np.copy(image.numpy_view()), gesture, org, font,  
                   fontScale, color, thickness, cv2.LINE_AA) 
    
    cv2.imshow("results",final_image)
    cv2.waitKey(1)