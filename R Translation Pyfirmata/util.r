library(serial)


"""
Helper function to get the one and only board connected to the computer
running this. It assumes a normal arduino layout, but this can be
overriden by passing a different layout dict as the ``layout`` parameter.
``base_dir`` and ``identifier`` are overridable as well. It will raise an
IOError if it can't find a board, on a serial, or if it finds more than
one.
"""

function = get_the_board(layout = BOARDS['arduino'], base_dir = "/dev/", indetifier  = "tty.usbserial"){
    source("pyFirmata.R")  # prevent a circular import
    boards = vector()
    for device in os.listdir(base_dir){
		if startsWith(device, identifier){
			board = Board(os.path.join(base_dir, device), layout)
        else:
    	    boards = c(boards, board)
		}  	
    }
    if length(boards) == 0:
        stop("No boards found in",base_dir,"with identifier",identifier)
    else if length(boards) > 1:
        stop ("More than one board found!")
    return (boards[1])
}

#wait on iterator class translation 
"""
Breaks an integer into two 7 bit bytes.
"""
function = to_two_bytes(number = number){
	if (number > 32767):
		stop ("Cant handle values bigger than 32767 (max for two bits)")
	first = number %% 128
	second = number >> 7
	return (vector(intToBits(first), intToBits(second)))
}

"""
Return an integer from two 7 bit bytes.
"""
function =  from_two_bytes(bytes = bytes):
    first = bytes[1]
    second = bytes[2]
    if (typeof(first) == "integer" & typeof(second) == "integer"){
    	return (second << 7 | first)
    }  
    else{
    	first = as.integer(first)
    	second = as.integer(second)
    	return (second << 7 | first)
    }
}

"""
Return a string made from a list of two byte chars.
"""
function = two_byte_iter_to_str(bytes = bytes){
	bytes = c(bytes)
	index = 1
	chars = vector()
	while(length(bytes) > 0){
		first = bytes[index]
		second = bytes[index]
		chars = c(chars, from_two_bytes(first, second))
	}
	return (rawToChar(chars))
}


"""
Return a iter consisting of two byte chars from a string.
"""
function =  str_to_two_byte_str(string = string){
	bstring = Encoding(string)
    bytes = c()
    for char in bstring:
        bytes = c(bytes, char)
        bytes = c(bytes, 0)
    return (charToBits(bytes))
}

"""
Breaks a value into values of less than 255 that form value when multiplied.
(Or almost do so with primes)
Returns a tuple
"""

function = break_to_bytes(value = value)
    if (value < 256):
        return (value,)
    d = 256
    least = (0, 255)
    for i in range(254){
        c -= 1
        rest = value %% c
        if (rest == 0 & value / c < 256){
            return (c, int(value / c))
        }
        else if (rest == 0 & value / c > 255){
            parts = list(break_to_bytes(value / c))
            append.(parts, 0 , c)
            return (cbind(parts))
        }
        else{
            if (rest < least[2]){
                least = cbind(c, rest)
            }
        }
    }
    return (c, int(value / c))


"""
Capability Response codes:
    INPUT:  0, 1
    OUTPUT: 1, 1
    ANALOG: 2, 10
    PWM:    3, 8
    SERV0:  4, 14
    I2C:    6, 1
"""
#INCOMPLETE, need to identify enumerate in R
function =  pin_list_to_board_dict(pinlist = pinlist){
	board_dict = {
        'digital': [],
        'analog': [],
        'pwm': [],
        'servo': [],  # 2.2 specs
        # 'i2c': [],  # 2.3 specs
        'disabled': [],
    }
}
    

   
    for (i, pin in seq_along(pinlist)):
        pin.pop()  # removes the 0x79 on end
        if not pin:
            board_dict['disabled'] += [i]
            board_dict['digital'] += [i]
            continue

        for j, _ in enumerate(pin):
            # Iterate over evens
            if j % 2 == 0:
                # This is safe. try: range(10)[5:50]
                if pin[j:j + 4] == [0, 1, 1, 1]:
                    board_dict['digital'] += [i]

                if pin[j:j + 2] == [2, 10]:
                    board_dict['analog'] += [i]

                if pin[j:j + 2] == [3, 8]:
                    board_dict['pwm'] += [i]

                if pin[j:j + 2] == [4, 14]:
                    board_dict['servo'] += [i]

                # Desable I2C
                if pin[j:j + 2] == [6, 1]:
                    pass

    # We have to deal with analog pins:
    # - (14, 15, 16, 17, 18, 19)
    # + (0, 1, 2, 3, 4, 5)
    diff = set(board_dict['digital']) - set(board_dict['analog'])
    board_dict['analog'] = [n for n, _ in enumerate(board_dict['analog'])]

    # Digital pin problems:
    # - (2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)
    # + (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13)

    board_dict['digital'] = [n for n, _ in enumerate(diff)]
    # Based on lib Arduino 0017
    board_dict['servo'] = board_dict['digital']

    # Turn lists into tuples
    # Using dict for Python 2.6 compatibility
    board_dict = dict([
        (key, tuple(value))
        for key, value
        in board_dict.items()
    ])

    return board_dict




        
