library(methods)
library(iterators)
source("MockupSerial.r")
source("Board.r")

MockupBoard = setClass("MockupBoard", contains = "Board"
                       #define representation
                       representation(self = MockupBoard, values_dict = "list", id = "numeric"),
                       
                      #initialize the object
                       setMethod("initialize","MockupBoard", function(.Object, port, layout, values_dict)
                         .Object@sp <- MockupSerial(port,57600),
                         setup_layout(layout),
                         .Object@id <- 1,
                         .Object@values_dict <- values_dict),
                       
                       setGeneric(name = "reset_taken",
                                  def = function(self){
                                    standardGeneric("reset_taken")
                                  }),
                       
                       setGeneric(name = "update_values_dict",
                                  def = function(self){
                                    standardGeneric("update_values_dict")
                                  }),
                       
                       setMethod(f = "reset_taken",
                                 signature = "MockupBoard",
                                 definition = function(self){
                                   for(key in self@taken['analog'])
                                       {
                                     # needs to define
                                         self@taken['analog'][key] = FALSE
                                   }
                                   for(key in self@taken['digital']){
                                     # needs to define
                                     self@taken['digital'][key] = FALSE
                                   }
                                       }),
                       
                       setMethod(f = "update_values_dict",
                                 signature = "MockupSerial",
                                 definition = function(self)
                                   {
                                   for(port in self@digital_ports)
                                   {
                                     port@values_dict = self@values_dict
                                     port.update_values_dict()
                                   }
                                   for(pin in self@analog)
                                   {
                                     pin@values_dict = self@values_dict
                                   }
                                 })
                       )
