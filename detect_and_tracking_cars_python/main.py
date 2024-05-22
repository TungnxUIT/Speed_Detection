import cv2
from tracker import *
import serial

def DecimalToBinary(num):
    binary_string = ""
    if num >= 1:
        binary_string = DecimalToBinary(num // 2)
    binary_string += str(num % 2)
    
   
    while len(binary_string) < 8:
        binary_string = "0" + binary_string
    
    if len(binary_string) > 8:
        binary_string = binary_string[-8:]
    
    return binary_string

def string_to_byte(input_string):
    # Chuyển chuỗi thành một số nguyên từ 0 đến 255
    num = int(input_string, 2)
    
    # Chuyển số nguyên thành một byte
    byte_value = num.to_bytes(1, byteorder='big')
    
    return byte_value

# Create tracker object
tracker = EuclideanDistTracker()

cap = cv2.VideoCapture("video/test05.mp4")

ser = serial.Serial('COM4', 19200)

# Object detection from Stable camera
object_detector = cv2.createBackgroundSubtractorMOG2(history=100, varThreshold=40)

# Initialize variables for file writing
frame_count = 0
file = open("results.txt", "w")
bin_file = open("results_bin.txt", "w")

while True:
    ret, frame = cap.read()
    if not ret:
        break

    height, width, _ = frame.shape

    # Extract Region of interest
    roi = frame[30:2000, 10:2000]

    # 1. Object Detection
    mask = object_detector.apply(roi)
    _, mask = cv2.threshold(mask, 254, 255, cv2.THRESH_BINARY)
    contours, _ = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    detections = []
    for cnt in contours:
        # Calculate area and remove small elements
        area = cv2.contourArea(cnt)
        if area > 1000:
            x, y, w, h = cv2.boundingRect(cnt)
            detections.append([x, y, w, h])

    # 2. Object Tracking
    boxes_ids = tracker.update(detections)
    for box_id in boxes_ids:
        x, y, w, h, id = box_id
        # Write results to file every 3 frames
        if frame_count % 3 == 0:
            file.write(f"Frame: {frame_count}, Car ID: {id}, X position: {x}, Y position: {y}\n")
            #if(id > 256 or y > 256): continue
            #if id == 18: id = 100
            #if id == 118: id = 18 
            #if id > 256: continue
            #if id == 82: continue
            #if id == 146: continue
            id_bin = DecimalToBinary(id)
            x_bin = DecimalToBinary(x)
            y_bin = DecimalToBinary(y)
            id_send = string_to_byte(id_bin)
            x_send = string_to_byte('11111111')
            y_send = string_to_byte(y_bin)
            wait = string_to_byte('11111111')
            ser.write(id_send)
            ser.write(x_send)
            ser.write(y_send)
            ser.write(wait)
            bin_file.write(id_bin + '\n')
            bin_file.write(x_bin + '\n')
            bin_file.write(y_bin + '\n')
            bin_file.write('11111111' + '\n')

        cv2.putText(roi, str(id), (x, y - 15), cv2.FONT_HERSHEY_PLAIN, 2, (255, 0, 0), 2)
        cv2.rectangle(roi, (x, y), (x + w, y + h), (0, 255, 0), 3)

    #cv2.imshow("roi", roi)
    cv2.imshow("Frame", frame)
    #cv2.imshow("Mask", mask)

    key1 = cv2.waitKey(30)  # Chờ một phím được nhấn trong 1 mili giây
    if key1 == ord(' '):   # Kiểm tra nếu phím được nhấn là dấu cách (space bar)
        cv2.waitKey(-1)   # Chờ đến khi một phím được nhấn, sử dụng giá trị -1 để chờ vô thời hạn

    key = cv2.waitKey(30)
    if key == 27:
        break

    frame_count += 1

#file.close()  # Close the file after processing

cap.release()
cv2.destroyAllWindows()
