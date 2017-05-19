Queue <- setRefClass(Class = "Queue",
  fields = list(
    name = "character",
    data = "list"
 ),
 methods = list(
   #Returns the number of items in the queue.
   size = function() {
     return(length(data))
   },
   #Inserts element at back of the queue.
   push = function(item) {
     data[[size()+1]] = item
   },
   #Removes and returns head of queue.
   pop = function() {
     if (size() == 0) stop("queue is empty")
     value = data[[1]]
     data[[1]] = NULL
     return (value)
   },
   #Removes and returns head of queue.
   poll = function() {
     if (size() == 0) return(NULL)
     else pop()
   },
   #Returns (but does not remove) specified positions in queue.
   peek = function(pos = c(1)) {
     if (size() < max(pos)) return(NULL)
     if (length(pos) == 1) return(data[[pos]])
     else return(data[pos])
   },
   #placeholder
   initialize=function(...) {
     callSuper(...)
     .self
   }
 )
)