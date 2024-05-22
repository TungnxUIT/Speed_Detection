import serial

# Khởi tạo một đối tượng Serial với cổng và tốc độ baudrate cụ thể
serial_port = serial.Serial('COM4', 19200)  # Thay 'COM1' bằng cổng UART thực tế bạn đang sử dụng và 9600 là baudrate

def DecimalToBinary(num):
    binary_string = ""
    if num >= 1:
        binary_string = DecimalToBinary(num // 2)
    binary_string += str(num % 2)
    
    # Pad the binary string with zeros to make it at least 9 bits long
    while len(binary_string) < 8:
        binary_string = "0" + binary_string
    
    # If the binary string is longer than 9 bits, truncate it to 9 bits
    if len(binary_string) > 8:
        binary_string = binary_string[-9:]
    
    return binary_string

def string_to_byte(input_string):
    # Chuyển chuỗi thành một số nguyên từ 0 đến 255
    num = int(input_string, 2)
    
    # Chuyển số nguyên thành một byte
    byte_value = num.to_bytes(1, byteorder='big')
    
    return byte_value

try:
    i = 0
    while True:
        # Gửi dữ liệu qua UART
        num = 18
        string = DecimalToBinary(num)
        data_to_send = string_to_byte(string)
        serial_port.write(data_to_send)  # Chuyển đổi chuỗi thành dạng bytes và gửi
        i += 1
        if(i == 10000): break



except KeyboardInterrupt:
    serial_port.close()  # Đóng kết nối UART khi ngừng chương trình
    print("Program terminated.")
