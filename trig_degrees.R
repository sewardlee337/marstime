## The following are trigonometric functions that accept degrees rather than 
## radians as arguments.


sin_deg <- function(x) {
     return(sin(x * pi / 180))
}

cos_deg <- function(x) {
     return(cos(x * pi / 180))
}

tan_deg <- function(x) {
     return(tan(x * pi / 180))
}

asin_deg <- function(x) {
     return(asin(x * pi / 180))
}

acos_deg <- function(x) {
     return(acos(x * pi / 180))
}

atan_deg <- function(x) {
     return(atan(x * pi / 180))
}