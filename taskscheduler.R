install.packages("taskscheduleR")
library(taskscheduleR)


taskscheduler_create(
  taskname = 'airline', 
  rscript = 'C:\\Users\\kkami\\Desktop\\getAirlineData.r',
  schedule = 'MINUTE',
  starttime = format(Sys.time() + 62, "%H:%M"), modifier = 1,
  startdate = format(Sys.Date(), "%m/%d/%Y"),
  Rexe = file.path(Sys.getenv("R_HOME"), "bin", 'Rscript.exe'
  )
)

taskscheduleR::taskscheduler_delete('airline')


taskscheduler_create(
  taskname = 'create_master_airline', 
  rscript = 'C:\\Users\\kkami\\Desktop\\create_master_airline.r',
  schedule = 'HOURLY',
  starttime = format(Sys.time() + 62, "%H:%M"), modifier = 1,
  startdate = format(Sys.Date(), "%m/%d/%Y"),
  Rexe = file.path(Sys.getenv("R_HOME"), "bin", 'Rscript.exe'
  )
)


taskscheduleR::taskscheduler_stop('airline')
taskscheduleR::taskscheduler_delete('create_master_airline')

           
  
  
  
  
  
  
  
  
