

library(methods)

get <- function(x) x


Arduino <- setClass(
		    "Arduino", contains = "Board",
		   representation(
				  name="character",
				  port="numeric",
				  digital=c(0:13),
				  analog=c(0:5),
				  pwm=c(3,5,6,9,10,11),
				  use_ports:TRUE,
				  disabled=c(0,1)) 
		    )

ArduinoMega <- setClass("ArduinoMega", contains = "Board",
		   representation(
				  name="character",
				  port="numeric",
				  digital=c(0:53),
				  analog=c(0:15),
				  pwm=c(2:13),
				  use_ports:TRUE,
				  disabled=c(0,1)) 

ArduinoDue <- setClass("ArduinoDue", contains = "Board",
		   representation(
				  name="character",
				  port="numeric",
				  digital=c(0:53),
				  analog=c(0:11),
				  pwm=c(2:23),
				  use_ports:TRUE,
				  disabled=c(0,1)) 

ArduinoNano <- setClass("ArduinoNano", contains = "Board",
		   representation(
				  name="character",
				  port="numeric",
				  digital=c(0,13),
				  analog=c(0,7),
				  pwm=c(3,5,6,9,10,11),
				  use_ports:TRUE,
				  disabled=c(0,1)) 


#my_board <- new("Arduino", name="ard_1", port=13)
#print(my_board@name)
