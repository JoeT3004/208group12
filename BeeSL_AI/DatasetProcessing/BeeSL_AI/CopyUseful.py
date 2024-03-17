import os
f = open("Number_Per_Video.txt", "r")
w = open("input_file_for_wget.txt", "w")
for x in f:
    split_Lines = x.split(",")
    video_Name = split_Lines[0]
    number_of_Videos = int(split_Lines[1])
    print(number_of_Videos)
    if number_of_Videos >= 15:
        w.write("https://thor.robots.ox.ac.uk/~vgg/data/bobsl/videos/"+video_Name+"\n")
    else:
        break
