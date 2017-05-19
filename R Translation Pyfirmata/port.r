
library(methods)
source("mockup.r")

setClass("Port", representation(
		self = Port,
	     	port_number:"numeric",
	     	boards:"Boards",
	     	reporting:FALSE,
	     	pins:makePins(port_number)
	     	)

makePins <- function(port_number){
	
	pinobjects = [0,0,0,0,0,0,0]
	for (i in 1:7){
		num = i*8*port_number
		pinobjects[i] = new("MockupPin", pin_number=num)
	}
	return pinobjects
		
}
