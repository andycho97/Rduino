library(methods)
library(iterators)
source("Port.r")

MockupPort = setClass("MockupPort", contains = "Port",
                      # define representations
                      representation(self = MockupPort),
                      #initialize the object
                      setMethod("initialize","MockupPort", function(.Object, board, port_number)
                        .Object@board <- board,
                        .Object@port_number <- port_number,
                        .Object@reporting <- FALSE,
                        .Object@pins = list(),
                        for(i in 0:7)
                        {
                            pin_nr = i+self@port_number*8
                            self@pins.append(MockupPin(self@board,pin_nr,typeof(prfirmata.DIGITAL), port=self))
                        }
                        
                      ),
                      
                      setGeneric(name = "update_values_dict",
                                 def = function(self){
                                   standardGeneric("update_values_dict")
                                 }),
                      
                      setMethod(f = "update_values_dict",
                                signature = "MockupPort",
                                definition = function(self)
                                  {
                                  for(pin in self@pins)
                                  {
                                    pin@values_dict = self@values_dict
                                  }
                                })
)
