
library(methods)

# Pros and cons of initializing values to NA?
setClass("Pin")(
		representation=c(
				 self = Pin,
				 board = Board,
				 values_dict = "matrix",
				 pin_number = "numeric",
				 type = "logical",
				 port = Port,
				 PWM_CAPABLE = "logical",
				 _mode = "character",
				 reporting = "logical",
				 value = NA
				 ),
	    	prototype= list(
				self.PWM_CAPABLE = FALSE,
				self.reporting = FALSE,
				self.board = NA,
				self.values_dict = NA,
				self.pin_number = NA,
				self.type = NA,
				self.port = NA,
				self._mode = NA,
				self.value = NA
				)
		)

# can we define these generic methods for everything that will use them?

setGeneric(name = "read",
		def = function(self, count){
			standardGeneric("read")
		}
	)

setGeneric(name = "write",
	def = function(self, value){
		standardGeneric("write")
	}
)
# When should we use @ to get object attributes
setMethod(f = "_set_mode",
	  signature = "Pin",
	  definition = function(self, mode){
		  if (mode == UNAVAILABLE){ self._mode = UNAVAILABLE }
		  if (self.mode == UNAVAILABLE){return "Pin cannot be used through Firmata"}
		  if (mode == PWM & !self.PWM_CAPABLE){return "Pin does not have PWM capabilities"}
		  if (mode == SERVO){
		  	if (self.type != DIGITAL){return "Only digital pins can drive servos, this pin is not"}
		  	self._mode = SERVO
			self.board.servo_config(self.pin_number)
			return
		  	}
		  ## set mode with SET_PIN_MODE message
		  self._mode = mode
		  self.board.sp.write(bytearray([SET_PIN_MODE, self.pin_number, mode]))
		  if (mode == INPUT){self.enable_reporting()}
	  })

setMethod(f = "_get_mode",
	  signature = "Pin",
	  definition = function(self){
	  	return self._mode
	  })

setMethod(f = "enable_reporting",
	  signature = "Pin",
	  definition = function(self){
	  	if (self.mode != INPUT{
	  	return "Pin is not an input and can thereore not report"
			}
	  	if (self.type == ANALOG){
			self.reporting = TRUE
			msg = bytearray([REPORT_ANALOG + self.pin_number, 1])
			self.board.sp.write(msg)
			}
		else{
			self.port.enable_reporting()
			# Apparently won't work for optimized boards like MEGA
			# will perhaps need to fix it
			}
	  )})


setMethod(f = "disable_reporting",
	  signature = "Pin",
	  definition = function(self){
	  	if (self.type == ANALOG){
	  		self.reporting == FALSE
			msg = bytearray([REPORT_ANALOG + self.pin_number, 0])
			self.board.sp.write(msg)
	  		}
		else{
			self.port.disable_reporting()	
			# Apparently won't work for optimized boards like MEGA
			# will perhaps need to fix it
			} 
	  })

setMethod(f = "read",
	  signature = "Pin",
	  definition = function(self){
	  	if (self.mode == UNAVAILABLE){
			return "Can't read pin"
			}
	  	return self.value
	  	})

setMethod(f = "write",
	  signature = "Pin",
	  definition = function(self, value){
	  	if (self.mode == UNAVAILABLE){
			return "Pin can't be used dthrough Firmata"
			}	
		if (self.mode == INPUT){
			return "Pin is set up as INPUT and cannot be written to"
			}
		if (value != self.value){
			self.value = value
			if self.mode == OUTPUT{
				if self.port{
					self.port.write()
					}
				else{
					msg = bytearray([DIGITAL_MESSAGE, self.pin_number, value])
					self.board.write(msg)
					}
				}
			else if(self.mode == PWM){
				value = numeric(round(value*255))
				msg = bytearray([ANALOG_MESSAGE + self.pin_number, value%128, value >> 7])
				self.board.write(msg)
				}
			else if(self.mode == SERVO){
				value = numeric(value)
				msg = bytearray([ANALOG_MESSAGE + self.pin_number, value%128, value >> 7])
				self.board.write(msg)
				}
			}
	  	})

