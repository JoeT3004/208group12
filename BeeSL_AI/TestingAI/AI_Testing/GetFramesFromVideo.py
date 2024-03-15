import cv2
import os

def StoreFrame(video_Name : string, start_Time: int, label: string):
    fps = video.get(cv2.CAP_PROP_FPS)
    frame_id = int(fps*(start_Time+1))
    frame_Counter = frame_id    
    video.set(cv2.CAP_PROP_POS_FRAMES, frame_id)
    ret, frame = video.read()
    cv2.imwrite(label + video_Name +start_Time, frame)
    
    path = 'C:\Users\brown\Documents\208\TestingAI\AI_Testing\Frames'
    path = os.path.join(path, label) 
    os.mkdir(path) 
    cv2.imwrite(os.path.join(path , (label + video_Name +start_Time) ) , img)
    print(label + video_Name +start_Time)

f = open("TrainingData.txt", r)

for x in f:
    #5085344787448740525.mp4,0,27.2,29.2
    split_Lines = x.split(",")
    StoreFrame(split_Lines[0], split_Lines[2], split_Lines[1])

path = 'C:\Users\brown\Documents\208\TestingAI\AI_Testing\Frames'
path = os.path.join(path, 'none') 
os.mkdir(path) 
print("all Files done ")