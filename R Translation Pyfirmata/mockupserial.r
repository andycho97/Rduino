library(iterators)


MockupSerial = setClass(
	"MockupSerial",
	#define representation
	#need to set self as a deque = FIFO stack
	representation = c(
		self = MockupSerial, 
		port = port,
		baudrate = "numeric",
		timeout = "numeric"
	),
	#set default value for the slots
	prototype = list(
		self.port = port,
		port = "somewhere",
		baudrate = 0,
		timeout = 0.02
	)
	#function for testing consistency of data, timeout check for now
	validity = function(object){
		if (timeout != 0.02){
			return("Timeout error")
		}	
		return (TRUE)
	}

	#inheritance call for other mockup serial objects

	#begin generic method signatures
	#CHECK DEFAULT PARAMETERS IN R AND SELF REFERENCES
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
	setGeneric(name = "close",
		def = function(self){
			standardGeneric("close")
		}
	)
	setGeneric(name = "inWaiting",
		def = function(self){
			standardGeneric("inWaiting")
		}
	)
	#implement methods
	setMethod(f = "read",
		signature = "MockupSerial",
		definition = function(self, count){
			if (count > 1){
				val = vector("numeric")
				for (i in 1: count){
					#equivalent of appending the popped value to the vector
					#this way is inefficient because its repeatedly copying the val vector
					#may want to employ a try catch index error to prevent popping from an empty self stack
					val = c(val, self.pop()) 
				}
			}
			else{
				val = self.pop()
			}
			# need an iterator check
			return (intToBits(val))
		}
	)
	setMethod(f = "write",
		signature = "MockupSerial",
		definition = function(self, value){
			value = iter(value)
			intToBits(value)
			self.push(value)
		}
	)
	setMethod(f = "close",
		signature = "MockupSerial",
		definition = function(self){
			self.clear()
		}
	)
	setMethod(f = "inWaiting",
		signature = "MockupSerial",
		definition = function(self){
			return length(self)
		}
	)

)