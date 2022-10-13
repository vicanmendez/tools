install.packages("tidyverse")
install.packages("rvest")
install.packages("stringr")
library("rvest")
library("stringr")
library("tidyverse")

#Function that returns a list of dates between two given dates with the format mm-dd-YYYY
itemizeDates <- function(startDate, endDate, 
                         format="%m-%d-%Y") {
  out <- seq(as.Date(startDate, format=format), 
             as.Date(endDate, format=format), by="days")  
  format(out, format)
} 

#function that returns the amount of times a variable appears in an array
numberPresent <- function(x, array) {
  n <- 0
  for(i in array) {
    if(x == i) {
      n <- n+1
    }
  }
  out <- n
}


numbers_total <- list()

fechaOk <- TRUE
d_start <- readline(prompt="Ingresa el día de inicio que queremos obtener resultados: (NÚMERO DE 2 CIFRAS)")
m_start <- readline(prompt="Ingresa el MES de INICIO que queremos obtener resultados: (NÚMERO DE 2 CIFRAS)")
y_start <- readline(prompt="Ingresa el AÑO DE fecha de inicio (NÚMERO DE 4 CIFRAS), EJ: '2022' ")

if((as.integer(d_start) < 1) | (as.integer(d_start) > 31 )) {
  print("Día incorrecto")
  fechaOk <- FALSE
}
if((as.integer(m_start) < 1) | (as.integer(m_start) > 12 )) {
  print("Mes incorrecto")
  fechaOk <- FALSE
}

if((as.integer(y_start) < 1900) | (as.integer(y_start) > 2100 )) {
  print("Año incorrecto")
  fechaOk <- FALSE
}

d_end <- readline(prompt="Ingresa el día FINAL que queremos obtener resultados: (NÚMERO DE 2 CIFRAS)")
m_end <- readline(prompt="Ingresa el MES DE LA FECHA FINAL (NÚMERO DE 2 CIFRAS) ")
y_end <- readline(prompt="Ingresa el AÑO DE LA FECHA FINAL (NÚMERO DE 4 CIFRAS), EJ: '2022' ")

if((as.integer(d_end) < 1) | (as.integer(d_end) > 31 )) {
  print("Día incorrecto")
  fechaOk <- FALSE
}
if((as.integer(m_end) < 1) | (as.integer(m_end) > 12 )) {
  print("Mes incorrecto")
  fechaOk <- FALSE
}

if((as.integer(y_end) < 1900) | (as.integer(y_end) > 2100 )) {
  print("Año incorrecto")
  fechaOk <- FALSE
}


if(fechaOk == TRUE) {
fechaStart <- ""
fechaStart <- paste(m_start, "-", d_start, "-", y_start)  
fechaStart <- (str_remove_all(fechaStart, " "))
fechaEnd <- paste(m_end, "-", d_end, "-", y_end)  
fechaEnd <- (str_remove_all(fechaEnd, " "))

#
dates_study <- itemizeDates(fechaStart, fechaEnd)
#analyze for each date
for(date in dates_study) {
    day <- substr(date, 4, 5)
    month <- substr(date, 1, 2)
    year <- substr(date, 7, 11)
    #making the URL of the particular day
    
    url1 <- "https://www.loteria.gub.uy/ver_resultados.php?vdia="
    url2 <- "&vmes="
    url3 <- "&vano="
    url <- paste(url1, day, url2, month, url3, year)
    url <- str_remove_all(url, " ")
    
    print(url)
    print("Espera un par de segundos..")
    Sys.sleep(2)
    test <- xml2::read_html(url)
    temp <- html_nodes(test, "div[class='text_azul_3']")
    print(paste("Sorteo del día: ", day, "mes: ", month))
    for(i in temp) {
      print(substr(i, 63, 65))
    } #/endFOR
    numbers <- list()
    for(i in temp) {
      numbers <- append(numbers, (substr(i, 63, 65)))
    } #/endFOR
    
    #clean the gotten list
    numbers_clean <- list()
    for(i in numbers) {
      #only want 3 digit numbers
      if(str_length(i) > 2) {
        if((substr(i, 3, 3) == " ") == FALSE) {
          numbers_clean <- append(numbers_clean, i)
        } 
      } #endIF control length
    } #endFOR
    
    #now, we add the list of numbers to the general list
    numbers_total <- append(numbers_total, numbers_clean)
    
  } #/endFOR
}  #/endIF fechaOK


total_Integers <- list()
for(i in numbers_total) {
  total_Integers <- append(total_Integers, as.integer(i))
}

#total_Integers

array_show <- array()
freq_show <- array()
#analyze frequencies
for(i in 0:999) {
  array_show <- append(array_show, i)
  freq_show <- append(freq_show, numberPresent(i, total_Integers))
}

#clean NAs
array_show <- na.omit(array_show)
freq_show <- na.omit(freq_show)

#create the frame and save csv
resultsFrame <- data.frame("Numeros" = array_show, "Frecuencia" = freq_show)
write.csv2(resultsFrame, "Resultados-Set21-Ene22.csv")

#create the plot
plot <- ggplot(data=resultsFrame) + geom_point(mapping = aes(x=Numeros, y=Frecuencia, color=freq_show)) + ggtitle("Quiniela uruguaya 1 de Setiembre/21 - 13 de Enero/22") 
ggsave(plot = plot, width = 8, height = 8, dpi = 300, filename = "Numeros-Set-Ene.pdf")

#why not studying the 2 digits numbers?
numbers_2digits <- list()
for (i in numbers_total) {
  numbers_2digits <- append(numbers_2digits, substr(i, 2, 3))
 }

array_show2 <- array()
freq_show2 <- array()
#analyze frequencies
for(i in 0:99) {
  array_show2 <- append(array_show2, i)
  freq_show2 <- append(freq_show2, numberPresent(i, as.integer(numbers_2digits)))
}

#create the frame and save csv
resultsFrame2 <- data.frame("Numeros" = array_show2, "Frecuencia" = freq_show2)
write.csv2(resultsFrame2, "Resultados-Set21-Ene22-2CIFRAS.csv")
#create the plot
plot2 <- ggplot(data=na.omit(resultsFrame2)) + geom_point(mapping = aes(x=Numeros, y=Frecuencia, color=Frecuencia)) + ggtitle("Quiniela uruguaya 1 de Setiembre/21 - 13 de Enero/22") 
ggsave(plot = plot2, width = 8, height = 8, dpi = 300, filename = "Numeros-Set-Ene-2CIFRAS.pdf")
