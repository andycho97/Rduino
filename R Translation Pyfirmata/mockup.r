
library(methods)
library(iterators)
library(serial)
source("values.R")
source("pin.r")
source("port.r")
source("board.r")

# MockupPort class and methods

setClass(
       "MockupPort", contains = "Port",
      representation = c(
		     self = MockupPort,
		     port_number:"numeric",
		     boards:"Boards",
		     reporting:FALSE,
		     pins:makePins(port_number)
      			 )
      )

setMethod("update_values_dict", signature("MockupPort"), 
	  function(self){
		for i in self@pins{
			i@values_dict = self@values_dict	
		}
       	} )

# MockupPin class and methods

setClass(
	 "MockupPin", contains="Pin",
	 representation = c(
			self = MockupPin,
			values_dict = "matrix"
			is_activate = "logical",
			mode = "character"
			)
	 prototype = list(
			  self.is_activate = FALSE
			  )
	 )

setMethod("write", signature("MockupPin"), 
	  function(self, value){
		  if (self.mode == UNAVAILABLE){
		  	simpleError("Can't read from Pin")
		  }
		  if (self.mode == INPUT){
		  	simpleError("Pin is not an output")
		  }
		  if (self.port == NA){
		  	simpleError("Pin has no attribute write")
		  }
		  self.value = value

		}
       	} )
