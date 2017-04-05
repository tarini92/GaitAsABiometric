import cv2
import os
import glob


i=1
os.chdir('/home/akanksha/darknet/')

for path in glob.glob('/home/akanksha/Desktop/MPPE/videos/test1/*.png'):
	print(path)
	os.system('./darknet detect cfg/yolo.cfg yolo.weights ' + path)
	print("Done For Image "+ str(i))
	i = i+1