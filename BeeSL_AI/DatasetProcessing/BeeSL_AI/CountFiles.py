f = open("TrainingData_Final.txt", "r")

dict_Of_videos = {"first": 1}

for x in f:
    #5085344787448740525.mp4,0,27.2,29.2
    split_Lines = x.split(",")
    video_Name = split_Lines[0]
    print(split_Lines[0])
    if video_Name not in dict_Of_videos:
       dict_Of_videos[video_Name] = 1
    else:
        dict_Of_videos[video_Name] = dict_Of_videos[video_Name] + 1
f = open("Number_Per_Video.txt", "w")

sorted_list = sorted(dict_Of_videos.items(), key=lambda item: item[1], reverse=True)

for key, value in sorted_list:
    print(key +","+str(value) )
    f.write(key +","+str(value)+"\n")