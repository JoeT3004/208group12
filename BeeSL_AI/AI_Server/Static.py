# This is the code for the static classifier 
# this is within a seperate program due to the fact that the simulator on a Mac has no connection to the webcam
# so a seperate python program is used to see the webcam due to technological restrictions. The python program 
# then uses sockets to communicate with the swift program. 

# This program uses Mediapipe gesture recogniser framework for classifying static poses as alphabet charicters
 

import mediapipe 
import cv2

import math

import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision

import socket



from mediapipe import solutions
from mediapipe.framework.formats import landmark_pb2
import numpy as np
import cv2




  
  
#@title Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# the above License refers to the mediapipe classes used as they are used under this license

# I have changed the libraries source code in specific attributes "num_hands" to ensure that
# the max number of hands recognised by the system is 2 so that both hands can be used. I 
# am required under this lisense to disclose that I have changed the source code in this
# specific aspect. 
#
# to obtain a non edited version go to mediapipes official website here:
# https://developers.google.com/mediapipe/solutions/vision/gesture_recognizer 

import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision

base_options = python.BaseOptions(model_asset_path='gesture_recognizer.task')
options = vision.GestureRecognizerOptions(base_options=base_options)
recognizer = vision.GestureRecognizer.create_from_options(options)

import cv2
import time

def draw_landmarks(image, landmarks):
  for landmark_hand in landmarks:
    for landmark in landmark_hand:
        # Get the x, y coordinates of the landmark (scaled to the image size)
        x = int(landmark.x * image.shape[1])
        y = int(landmark.y * image.shape[0])

        # Draw a circle at the landmark position
        cv2.circle(image, (x, y), 5, (0, 255, 0), -1)  # Green color, filled circle


current_letter = ''

time_for_each_question = 30.0

def Start_Session(client_socket):
    
  vc = cv2.VideoCapture(0)

  #means that socket will timeout if message is not recieved within 15 seconds 
  client_socket.settimeout(15)
  
      
  message_data = client_socket.recv(1024)
  test_letter = message_data.decode('utf-8')
  
  #Need to setup first letter but is a posttest loop so that end can end the loop
  
  while test_letter != 'end\n':
    start_time = time.time()    
    print(test_letter)
    correct_letter = False
    
    #GetLetter

    while correct_letter == False and (start_time - time.time() ) < time_for_each_question:
      #img = me.get_frame_read().frame
      rval, img = vc.read()
      numpy_Image =np.array(img)
      image = mp.Image(
      image_format=mp.ImageFormat.SRGB,  # Adjust format based on your image data
      data=numpy_Image)
      
      recognition_result = recognizer.recognize(image)
      gesture = 'none'
      if(len(recognition_result.gestures) >0):
          top_gesture = recognition_result.gestures[0][0]    
          gesture = getattr(top_gesture, 'category_name')

      if gesture == test_letter:
        correct_letter = True
        
      font = cv2.FONT_HERSHEY_SIMPLEX     
      org = (50, 50) 
      fontScale = 1
      color = (255, 0, 0) 
      thickness = 2
      
      final_image = cv2.putText(np.copy(image.numpy_view()), gesture, org, font,  
                    fontScale, color, thickness, cv2.LINE_AA) 
      
      
      draw_landmarks(final_image,recognition_result.hand_landmarks)
      
      cv2.imshow("results",final_image)
      cv2.waitKey(1)
    
    if correct_letter == True:
      message_back = 'C'
      client_socket.sendall(message_back.encode('utf-8'))
    else:
        message_back = 'F'
        client_socket.sendall(message_back.encode('utf-8'))
      
    message_data = client_socket.recv(1024)
    test_letter = message_data.decode('utf-8')
  
  #Now that end has been recieved we can stop the loop and this static session is done


def Start_static_Classifier(incoming_socket):
  client_socket = incoming_socket
  message_back = 'Static Session Started'
  client_socket.sendall(message_back.encode('utf-8'))
  Start_Session(client_socket)
  