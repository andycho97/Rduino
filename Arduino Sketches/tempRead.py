import serial
import csv
from datetime import datetime

def readTemps(numLines):
	ser = serial.Serial("/dev/cu.usbmodemFD121",9600)
	temps = []
	entry = []
	dt = datetime(2008, 11, 10, 17, 53, 59)
	while (numLines >= 0):
		dt = datetime.now()
		time_str = dt.strftime("%H:%M:%S")
		line = ser.readline() 
		print("Read in:", line)
		entry = line.split(":")
		entry.insert(0, time_str)
		temps.append(entry)
		numLines -= 1
	return temps

def writeTemps(temps, filename):
	header = ["Time", "Sensor Value", "Voltage", "Celsius", "Fahrenheit"]
	with open(filename, 'w') as csvfile:
		writer = csv.writer(csvfile)
		writer.writerow(header)
		writer.writerows(temps)


if __name__ == "__main__":
	temps = readTemps(10)
	writeTemps(temps, "temp_readings.csv")
