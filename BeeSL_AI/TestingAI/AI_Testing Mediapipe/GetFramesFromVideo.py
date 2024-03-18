import cv2
import os

def StoreFrame(video_Name, start_Time, label):
    #D:\Comp208\VideoFiles\bobsl\Training_videos
    path = "D:\Comp208\VideoFiles\bobsl\Training_videos" 
    first_Half_path = "D:\\Comp208\\VideoFiles" 
    second_Half_path = "\\bobsl\\Training_videos\\" + video_Name
    print(first_Half_path + second_Half_path)
    if os.path.exists(first_Half_path + second_Half_path):
        print("does work")
    else:
        print("doesnt")
    
    path = path + video_Name
    video = cv2.VideoCapture( first_Half_path + second_Half_path)
    fps = video.get(cv2.CAP_PROP_FPS)    
    #"D:\Comp208\VideoFiles\bobsl\Training_videos\5085344787448740525.mp4"
    path = "Frames"
    path = os.path.join(path, label) 
    
    if not os.path.exists(path):
        os.mkdir(path) 
    for item in range(1):   
        frame_id = int(fps*( float(start_Time)+2) )
        frame_Counter = frame_id    
        video.set(cv2.CAP_PROP_POS_FRAMES, frame_id)
        ret, frame = video.read()
        path = os.path.join(path , (label +","+ video_Name) +","+str( frame_id/fps)+".png" )
        cv2.imshow('frame', frame); cv2.waitKey(0)
        if not os.path.exists(path):
            cv2.imwrite( path , frame)
        print(label + video_Name +start_Time)

f = open("TrainingData.txt", "r")


#"D:\Comp208\VideoFiles\bobsl\Training_videos\5085344787448740525.mp4"
for x in f:
    #5085344787448740525.mp4,0,27.2,29.2
    split_Lines = x.split(",")
    if split_Lines[0] != "video":
        StoreFrame(split_Lines[0], split_Lines[2], split_Lines[1])

path = "Frames"
path = os.path.join(path, 'none') 
os.mkdir(path) 
print("all Files done ")