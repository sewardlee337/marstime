## Setup

library(dplyr)
library(lubridate)

script.dir <- dirname(sys.frame(1)$ofile)
source(paste0(script.dir, '/trig_degrees.R'))

## Example arguments

datetime = '2000-01-06 00:00:00'
tzone = 'UTC'

millis <- datetime  %>%
  ymd_hms(tz = tzone) %>%
  as.integer() * 1000

## Mars24 algorithm

Mars24 <- function(millis) {
     
     ## A-2: Convert millis to Julian Date (UT)
     
     jdUT <- 2440587.5 + (millis / (8.64 * 1e7)) 
     
     ## A-3: Determine time offset from J2000 epoch (UT)
    
     epoch.J2000 <- ymd_hms('2000-01-01 00:00:00')
     
     T <- ifelse(as_datetime(millis/1000) < epoch.J2000, (jdUT - 2451545.0) / 36525, 0)
     
     ## A-4: Determine UTC to TT conversion
     
     tt.minus.ut <- 64.184 + (59 * T) - (51.2 * T^2) - (67.1 * T^3) - (16.4 * T^4)
     
     ## A-5: Determine Julian Date (TT)
     
     jdTT <- jdUT + (tt.minus.ut / 86400)
     
     ## A-6: Determine time offset from J2000 Epoch (TT)
     
     deltaTJ2000 <- jdTT - 2451545.0 
     
     ## B-1: Determine Mars mean anomaly
     
     M <- 19.3871 + (0.52402073 * deltaTJ2000)
     
     ## B-2: Determine angle of Fiction Mean Sun
     
     alphaFMS <- 270.3871 + (0.524038496 * deltaTJ2000)
     
     ## B-3: Determine perturbers
     
     ### Note use of custom trig functions. Default trig functions in R only accept
     ### arguments in radians.
     
     alpha <- c(0.0071, 0.0057, 0.0039, 0.0037, 0.0021, 0.0020, 0.0018)
     tau <- c(2.2353, 2.7543, 1.1177, 15.7866, 2.1354, 2.4694, 32.8493)
     phi <- c(49.409, 168.173, 191.837, 21.736, 15.704, 95.528, 49.095)
     
     PBS <- sum(alpha * cos_deg(((0.985626 * deltaTJ2000 / tau) + phi)))
     
     ## B-4: Determine Equation of Center
     
     v.minus.M <- (10.691 + 3.0 * 1e-7 * deltaTJ2000) * sin_deg(M) +
          0.623 * sin_deg(2 * M) + 0.050 * sin_deg(3 * M) + 0.005 * sin_deg(4 * M) +
          0.0005 * sin_deg(5 * M) + PBS
     
     ## B-5: Determine aerocentric solar longitude
     
     Ls <- alphaFMS + v.minus.M
     
     ## C-1: Determine Equation of Time
     
     EOT <- 2.861 * sin_deg(2 * Ls) - 0.071 * sin_deg(4 * Ls) + 
          0.002 * sin_deg(6 * Ls) - v.minus.M
     
     ## C-2: Determine Coordinated Mars Time (ie Airy Mean Time)
     
     MTC <- (24 * (((jdTT - 2451549.5) / 1.0274912517) + 44796.0 - 0.0009626)) %% 24
     
     ## Return dataframe
     
     equation <- c('A-1', 'A-2', 'A-3', 'A-4', 'A-5', 'A-6', 'B-1', 'B-2', 
                   'B-3', 'B-4', 'B-5', 'C-1', 'C-2')
     
     description <- c('Get a starting Earth time in millis', 
                      'Convert millis to Julian Date (UT)',
                      'Determine time offset from J2000 epoch (UT)',
                      'Determine UTC to TT conversion',
                      'Determine Julian Date (TT)',
                      'Determine time offset from JS2000 epoch (TT)',
                      'Determine Mars mean anomaly', 
                      'Determine angle of Fiction Mean Sun', 
                      'Determine perturbers', 'Determine Equation of Center',
                      'Determine aerocentric solar longitude', 
                      'Determine Equation of Time', 'Determine Coordinated Mars Time')
     
     value <- c(millis, jdUT, T, tt.minus.ut, jdTT, deltaTJ2000, M, alphaFMS,
                PBS, v.minus.M, Ls, EOT, MTC)
     
         output <- data.frame(equation = equation, description = description, 
                               value = value) 
         return(output)

}

## Convert Earth to Mars

earth2mars_convert <- function(millis, verbose=FALSE) {
  calculations <- Mars24(millis)
  
  if(verbose==TRUE) {
    print(calculations)
  }
  
  return(calculations$value[13])
}