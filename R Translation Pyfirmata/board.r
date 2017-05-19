
library(methods)

setClass( "Board",
	 representation(
		firmata_version = NA,
	    	firmware = NA,
		firmware_version = NA,
		_command_handlers = NA,
		_command = NA,
		_stored_data = NA,
		_parsing_sysex = FALSE)
