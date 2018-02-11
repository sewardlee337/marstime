# marstime

*_Project under active development._*

### Introduction

This is an implementation of the NASA [Mars24 Sunclock algorithm](https://www.giss.nasa.gov/tools/mars24/) developed by Dr. Michael D Allison, using the R programming language. 

For more information, see:
* [Allison, M. 1997. Accurate analytic representations of solar time and season on Mars with applications to the Pathfinder/Surveyor missions. Geophys. Res. Lett. 24, 1967-1970.](http://onlinelibrary.wiley.com/doi/10.1029/97GL01950/abstract)


### Mars24()

The bulk of the calculations is performed by the function `Mars24()`:

```
Mars24(datetime, tzone)
```
where 
* `datetime` is a character string representing the Earth time that you want to convert to Martian time. The character string should be in the format `'%Y-%m-%d %H:%M:%S'`.
* `tzone` is a character string representing the timezone of the Earth time that you want to convert to Martian time. 

The output of `Mars24()` is a dataframe that corresponds to the examples documented on the ["Algorithm and Worked Examples"](https://www.giss.nasa.gov/tools/mars24/help/algorithm.html) page on the NASA Goddard Institute for Space Studies website. 

For example:

```r
## Example: January 6, 2000 (UTC)

Mars24('2000-01-06 00:00:00', 'UTC') %>%
     print()
```

```
##    equation                                  description         value
## 1       A-1                    Get a starting Earth time  9.471168e+11
## 2       A-2            Convert millis to Julian Date(UT)  2.451550e+06
## 3       A-3  Determine time offset from J2000 epoch (UT)  0.000000e+00
## 4       A-4               Determine UTC to TT conversion  6.418400e+01
## 5       A-5                   Determine Julian Date (TT)  2.451550e+06
## 6       A-6 Determine time offset from JS2000 epoch (TT)  4.500743e+00
## 7       B-1                  Determine Mars mean anomaly  2.174558e+01
## 8       B-2          Determine angle of Fiction Mean Sun  2.727457e+02
## 9       B-3                         Determine perturbers  1.418321e-03
## 10      B-4                 Determine Equation of Center  4.441927e+00
## 11      B-5        Determine aerocentric solar longitude  2.771876e+02
## 12      C-1                   Determine Equation of Time -5.187746e+00
## 13      C-2              Determine Coordinated Mars Time  2.399425e+01
```
