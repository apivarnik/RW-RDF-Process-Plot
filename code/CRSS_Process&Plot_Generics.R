##############################################################################
#This script creates annual plots of Outflow and PE to compare two CRSS runs

#DEVELOPMENT IS ON GOING ON THIS

#Contents 
## 1. Set Up ##
## 2. User Input ##
## 3. Process Results ## 
## 4. Plot ## 

#   Created by C. Felletter 8/2018
#   Updated by CF on 10/2018 to include logic for adapting for development of
#   multiple plot types in one pdf
##############################################################################

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1. Set Up ##
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rm(list=ls()) #clear the enviornment 

## Directory Set Up
#Set folder where studies are kept as sub folders. 
CRSSDIR <- Sys.getenv("CRSS_DIR")

# where scenarios are folder are kept
scen_dir = file.path(CRSSDIR,"Scenario") 
#containing the sub folders for each ensemble

results_dir <- file.path(CRSSDIR,"results") 

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. User Input ##
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

list.dirs(scen_dir) #list dirs in set folder folder for us in next input

#### Normally You'll Only Change The Below ####
#scens you want to compare 
scens <- list(
  "Aug 2018" = "Aug2018_2019,DNF,2007Dems,IG,Most",
  "Aug 2018 + Fix" = "Aug2018_2019_9000,DNF,2007Dems,IG_9000,Most_BM_FGltsp"
)

list.files(file.path(scen_dir,scens[1])) #list files in scen folder for next input

#files, variables, floworpes, cyorwys, figuretypes, exc_months (if using exceed
# on PE), & custom captions/y_lab should be set to a single value
#but could be used to loop through multiple plots if all c() variable were extended 
#see example below 

## Process Variables ##

rdffiles <- c("Res.rdf") #rdf file with slot you want
# rdffiles <- c("DailyFlows.rdf") #rdf file with slot you want
# rdffiles <- c("UBRes.rdf") #rdf file with slot you want

variables <- c("Powell.Inflow") #RW Object.Slot
# variables <- c("Powell.Pool Elevation") #RW Object.Slot
# variables <- c("FlamingGorge.Pool Elevation") #RW Object.Slot
# variables <- c("DailyFlows.FlamingGorgeDaily") #RW Object.Slot

# timesteps <- c("annual") #"annual" or "monthly"
timesteps <- c("monthly") #"annual" or "monthly"
# timesteps <- c("daily") #"annual" or "monthly" or "daily"


floworpes <- c("flow") #"flow" or "pe"
# floworpes <- c("pe") #"flow" or "pe"

cyorwys <- c("cy") #"cy" or "wy". wy not tested for all plot configurations
#daily only supports cy

mainScenGroup <<- names(scens)[1] #name of the subfolder this analysis will be stored

## Plot Variables ##

combineplots <<- F #F for individual files saved, true to combineplots multiple files

figuretypes <- c(1) #1 is Trace Mean, 2 is Bxplt of Traces, 3 is Exceedance
# IF PICKING "monthly" 3 you must specify a month
exc_months <- c(12) #1 - Jan, 12 - Dec
#Note: exceedance month is only needed for monthly pe exceedance (3)

startyrs <- c(2019) #filter out all years > this year
endyrs <- c(2026) #filter out all years > this year
#these must match if doing daily slot

customcaptions <- c(NA) #NA or this will overwrite the default captions
# customcaptions <- c("May") #NA or this will overwrite the default captions
#set for mean (1) and boxplot (2)

custom_y_labs <- c(NA) #NA gives defaults, enter if want soemthing different
# custom_y_labs <- c("May") #NA gives defaults, enter if want soemthing different
## daily = "Daily Flow (cfs)"
## monthly = "Monthly Flow (ac-ft/mo)" OR "End of Month PE (ft)"
## annual = "Annual C/WY Flow (ac-ft/mo)" OR "EOC/WY PE (ft)" it knows CYorWY

#file names
figname <<- 'Generic_Fig'
#if combineplots is T figs saved as figname.pdf w/o captions
#if F figs saved individually as figname_timestep_cyorwy_variable_figuretype.imgtype

#### End of Normal Change Section ####

#output image parameters 
width <<- 9 #inches
height <<- 6

imgtype <<- "pdf" #supports pdf, png, jpeg. pdf looks the best 
#only works when individual plots are selected 

#### Example of Multi Slot Process select region and hit ctrl+c to enable ####

#Example 1: Single Trace w/ above parameters. 

# figname <<- 'Example_1_Fig'
# #Note: any parameters that are listed twice will be set as the latest (furtherst 
# #down) value


#Example 2: Monthly Flow Bxplt, Annual PE Exceedance. Don't combine plots.

# rdffiles <- c("Res.rdf","Res.rdf") #rdf file with slot you want
# variables <- c("Powell.Outflow","Powell.Pool Elevation") #RW Object.Slot
# timesteps <- c("annual","monthly")
# floworpes <- c("flow","pe") #"flow" or "pe"
# cyorwys <- c("cy","cy") #"cy" or "wy". wy not tested for all plot configurations
# mainScenGroup <<- names(scens)[1] #name of the subfolder this analysis will be stored
# ## Plot Variables ##
# combineplots <<- T #F for individual files saved, true to combineplots multiple files
# # # #Note: creating a single pdf 
# figuretypes <- c(3,2) #1 is Trace Mean, 2 is Bxplt of Traces, 3 is Exceedance
# exc_months <- c(NA,NA) #1 - Jan, 12 - Dec
# #Note: exceedance month is only needed for monthly pe exceedance (3)
# startyrs <<- c(2019,2019) #filter out all years > this year
# endyrs <<- c(2026,2026) #filter out all years > this year
# customcaptions <- c(NA,NA) #NA or this will over write the default caption on boxplots
# custom_y_labs <- c(NA,NA) #NA gives defaults, enter if want soemthing different
# figname <<- 'Example_2_Fig'

#Example 3: Daily Mean, Monthly Flow Bxplt, Monthly Exceedance Flow, Annual PE Bxplt

# # Process Variables ##
# rdffiles <- c("DailyFlows.rdf","UBRes.rdf","Res.rdf","Res.rdf") #rdf file with slot you want
# variables <- c("DailyFlows.FlamingGorgeDaily","FlamingGorge.Outflow","Powell.Inflow","Powell.Pool Elevation") #RW Object.Slot
# timesteps <- c("daily","monthly","monthly","annual")
# floworpes <- c("flow","flow","flow","pe") #"flow" or "pe"
# cyorwys <- c("cy","cy","wy","wy") #"cy" or "wy". wy not tested for all plot configurations
# mainScenGroup <<- names(scens)[1] #name of the subfolder this analysis will be stored
# ## Plot Variables ##
# combineplots <<- F #F for individual files saved, true to combineplots multiple file
# #Note: creating a series of seperate files
# figuretypes <- c(1,2,3,2) #1 is Trace Mean, 2 is Bxplt of Traces, 3 is Exceedance
# exc_months <- c(NA,NA,9,NA) #1 - Jan, 12 - Dec
# #Note: must specify exc_month for Exceedance, since we want wy this is 9/sept
# startyrs <<- c(2019,2019,2019,2019) #filter out all years > this year
# endyrs <<- c(2019,2026,2026,2026) #filter out all years > this year
# #Note: start year same as end year for Daily
# customcaptions <- c(NA,NA,"Inflow Exceedance",NA) #NA or this will over write the default caption on boxplots
# custom_y_labs <- c(NA,NA,"Inflow Exceedance",NA) #NA gives defaults, enter if want soemthing different
# # Note: use of custom caption and labels
# figname <<- 'Example_3_Fig'


#Example 4: Monthly Exceedance PE, Monthly Flow Bxplt, , Annual PE Bxplt

# # Process Variables ##
# rdffiles <- c("UBRes.rdf","Res.rdf","Res.rdf") #rdf file with slot you want
# variables <- c("FlamingGorge.Pool Elevation","Powell.Inflow","Powell.Pool Elevation") #RW Object.Slot
# timesteps <- c("monthly","monthly","annual")
# floworpes <- c("pe","flow","pe") #"flow" or "pe"
# cyorwys <- c("wy","wy","wy") #"cy" or "wy". wy not tested for all plot configurations
# # Note: everything is on wy but since doing monthly exceedances it doesn't matter for 1&2
# mainScenGroup <<- names(scens)[1] #name of the subfolder this analysis will be stored
# ## Plot Variables ##
# combineplots <<- T #F for individual files saved, true to combineplots multiple files
# # #Note: creating a single pdf 
# figuretypes <- c(3,3,2) #1 is Trace Mean, 2 is Bxplt of Traces, 3 is Exceedance
# exc_months <- c(5,5,NA) #1 - Jan, 12 - Dec
# #Note: looking at exceedance for a PE and a flow for May 
# startyrs <<- c(2019,2019,2019) #filter out all years > this year
# endyrs <<- c(2026,2026,2026) #filter out all years > this year
# customcaptions <- c("May PE",NA,NA) #NA or this will over write the default caption on boxplots
# custom_y_labs <- c("May PE (ft) Exceedance",NA,NA) #NA gives defaults, enter if want soemthing different
# # # Note: use of custom caption and labels and compare to standard labels on next plot 
# figname <<- 'Example_4_Fig'

#Example 5: Bad UI, slot not in rdf

# figuretypes <- 4

#Example 6: Bad UI, slot not in rdf

# variables <- "Fake.News"

#### End Examples #### 



# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#                               END USER INPUT
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

source('code/Generic_Input_Check.r')
source('code/Generic_Scen_Process.r')
source('code/Generic_Daily_Plot.r')
source('code/Generic_annual_plot.r')
source('code/Generic_monthly_plot.r')

ofigs <- file.path(results_dir,mainScenGroup) 
if (!file.exists(ofigs)) {
  message(paste('Creating folder:', ofigs))
  dir.create(ofigs)
}

message('Figures will be saved to: ', ofigs)

if(combineplots == T){
  pdf(file.path(ofigs,paste0(figname,".pdf")), width=width, height=height)
}

#this could be used to loop through multiple plots 
for(i in 1:length(variables)){
  ## Process Variables ##
  rdffile <<- rdffiles[i] 
  variable <<- variables[i]
  floworpe <<- floworpes[i]
  cyorwy <<- cyorwys[i]
  timestep <<- timesteps[i]
  ## Plot Variables ##
  figuretype <<- figuretypes[i]
  exc_month <<- exc_months[i]
  startyr <<- startyrs[i] 
  endyr <<- endyrs[i]
  customcaption <<- customcaptions[i]
  custom_y_lab <<- custom_y_labs[i]
  
  # some sanity checks that UI is correct:
  generic.input.check(scen_dir,scens,timestep) 
  
  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ## 3. Process Results 
  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  scen_res <- generic.scen.process(scen_dir,scens,timestep) 
  # scen_res <- generic.scen.process(scen_dir,scens,file,variable,timestep,floworpe,cyorwy,mainScenGroup) 
  
  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ## 4. Plot Choosen Timestep Type 
  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
  
  if(timestep == "annual"){
    generic.annual.plot(scen_res)
  } else if(timestep == "monthly"){
    generic.monthly.plot(scen_res) 
  } else if(timestep == "daily"){
    generic.daily.plot(scen_res)
  } else {
    stop(paste0("Plot type ",timestep," not supported"))
  }

} #close process and plot loop i 

if(combineplots == T){
  dev.off()
}