#!../../bin/linux-x86/srcextr

## You may have to change srcextr to something else
## everywhere it appears in this file

< envPaths


epicsThreadSleep(5)

## Register all support components
dbLoadDatabase("../../dbd/srcextr.dbd")
srcextr_registerRecordDeviceDriver(pdbbase)

####################################################################################################################################
##################### Setup the GPIB gateway for the Internal Steering Magnet
######################################################################################################################################
epicsThreadSleep(5)
##E5810Reboot("192.168.0.153",0)
vxi11Configure("ISMGateway", "192.168.0.153", 1, 2, "gpib0",0,0)
##vxi11Configure("portName", "address", flag, timeout, "vxiName", priority, noAutoConnect)
## portName = Any Name that makes sense (Can be more than one port(name) per IP address.
## address = IP address or name on tne network.  Assumed TCP unless specified - See documentation for other than TCP
## flag = lock/recovery specification. we use 1 = Recover with IFC (Interface Clear) when error occurs
## timeout = I/O timeout in seconds
## vxiName = must be "gpib0" for E5810E
## priority = Priority for Asyn I/O thread.  0 or missing = medium priority
## noAutoConnect = zero or missing for portThread to autoconnect

####################################################################################################################################
#########################Configure Asyn Ports Connected to the Extractor SAM, PSHV/SEPTUM, EMC, PSARC/GasFlow Meter
####################################################################################################################################

##                  drvAsynIPPortConfigure("portName","hostAddress",priority,noAutoConnect,noProcessEOS)

##                  portName = Any Name that makes sense (Can be more than one port(name) per IP address
##                  hostAddress = IP address or name, and port # on tne network.  Assumed TCP unless specified - See documentation for other than TCP
##                  priority = Asyn I/O thread priority.  0 or missing = ThreadPriorityMedium
##                  noAutoConnect = Autoconnect status. 0 or missing = Autoconnect after disconnect or if connect timeout at boot.
##                  noProcessEOS = EOS in and out are specified if 0 or missing

##  Configure Port for Source-Extractor-Output Acromag 973EN-4006, 6 Channel Analog Output, Output range of 0-5 VDC
## Acromag used to read extractor servo + gas servo + defl probe servo potentiometer values and Gas Flow Meter

drvAsynIPPortConfigure("ExtrServoRead","192.168.0.74:502",0,0,1)


##  Configure Port for Source-Extractor-Read Acromag 962EN-4006, 6 Channel Analog Input, Input range of +/-5 VDC
## Acromag used to write extractor servo + gas servo + defl probe servo drive signals and PSHV Set Signal

drvAsynIPPortConfigure("ExtrServoWrite","192.168.0.73:502",0,0,1)


##  Configure Port for PSARC and Gas Flow Acromag 952EN, Combo I/O module, Input range of +/-5 VDC 
## Acromag used to read PSARC Current & Voltage and Gas Flow

drvAsynIPPortConfigure("IonSource","192.168.0.78:502",0,0,1)


## Configure Port connected to EMC Acromag - 952EN, Combo I/O module, Input range of +/-10 VDC, output range 0-20 mA
drvAsynIPPortConfigure("AcromagEMC","192.168.0.76:502",0,0,1)


## Configure Port connected to PSHV Acromag - 952EN, Combo I/O module, Input range of +/-10 VDC, output range 0-20 mA
##  Reads and Writes PSHV and reads Septum Temp
drvAsynIPPortConfigure("AcromagDEFL","192.168.0.77:502",0,0,1)


##################################################################################################################################################
###############Allow previous IP Ports created to support Modbus Protocol
##################################################################################################################################################
##                  modbusInterposeConfig("portName", linkType, timeOutmSec, writeDelaymSec)

##                  portName = Name of previously configured IP port to attach Modbus communication to
##                  LinkType = 0 - TCP/IP
##                                   1 - RTU Serial
##                                   2 - ASCII Serial
##                  timeOutmSec = time in milliseconds for asynOctet has to complete read/write operations before timeout is reached and operation is
##                            aborted
##                  writeDelayMSec = minimum delay in milliseconds between modbus writes, useful for RTU and ascii comm, set to 0 for tcp comm.

modbusInterposeConfig("ExtrServoRead", 0, 1000,0)

modbusInterposeConfig("ExtrServoWrite", 0, 1000,0)

modbusInterposeConfig("IonSource", 0, 1000, 0)

modbusInterposeConfig("AcromagEMC", 0, 1000, 0)

modbusInterposeConfig("AcromagDEFL", 0, 1000, 0)




##################################################################################################################################################
#####Configure Modbus Ports and assign them to IP Ports.  More than 1 Modbus port may be assigned to an IP Port
####################################################################################################################################
#drvModbusAsynConfigure(
#
#                      portName, - name of Modbus port to create
#
#                      tcpPortName, - name of previously created IP port to use  
#
#                      slaveAddress - For TCP communication the PLC ignores it so set to 0
#
#                      modbusFunction, - 1 Read Coil Status
#                                      - 2 Read Input Status
#                                      - 3 Read Holding Register
#                                      - 4 Read Input Register
#                                      - 5 Write Single Coil
#                                      - 6 Write Single Register
#                                      - 7 Read Exception Status
#                                      - 15 Write Multiple Coils (Requires additional Gensub code to put values in waveform record)
#                                      - 16 Write Multiple Registers (Requires additional Gensub code to put values in waveform record)
#                                      - 17 Report Slave ID
#
#                      modbusStartAddress, - Address in decimal or octal (add leading 0 if using octal e.g. 0177)
#
#                      modbusLength,  - number of 16 bit words to access for function codes 3,4,6,16, number of bits for codes 1,2,5,15
#
#                      dataType,     - Data format
#                                    - 0 UINT16, Unsigned 16bit Binary
#                                    - 1 INT16SM, 16 bit Binary, sign and magnitude.  Bit 15 is sign, 0-14 magnitude
#                                    - 2 BCD, unsigned
#                                    - 3 BCD, signed
#                                    - 4 INT16, signed 2's compliment
#                                    - 5 INT32_LE, 32 bit integer, little endian
#                                    - 6 INT32_LE, 32 bit integer, big endian
#                                    - 7 FLOAT32_LE, 32 bit floating point, little endian
#                                    - 8 FLOAT32_LE, 32 bit floating point, big endian
#                                    - 9 FLOAT64_LE, 64 bit floating point, little endian
#                                    - 10 FLOAT64_LE, 64 bit floating point, big endian
#
#                      pollMsec, - Polling delay time for read functions (This is the time resolution when using I/O interrupt scanning)
#
#                      plcType, - Any name, used in asynReport
#
##  


## Read extractor servo + gas servo + defl probe servo potentiometer values and (for now) Gas Flow Meter

drvModbusAsynConfigure("ExtractorRead", "ExtrServoRead",0,4,0,13,0,100,"Acromag")
#DEFLEntryServoRead 0 Offset; DEFLExitServoRead 1 Offset; EMCExitServoRead 2 Offset; DeflProbeServoRead 3 Offset

## Write extractor servo + gas servo + defl probe servo drive signals
drvModbusAsynConfigure("DEFLEntryServoWrite", "ExtrServoWrite",0,6,18,1,0,100,"Acromag")
drvModbusAsynConfigure("DEFLExitServoWrite", "ExtrServoWrite",0,6,19,1,0,100,"Acromag")
drvModbusAsynConfigure("EMCExitServoWrite", "ExtrServoWrite",0,6,20,1,0,100,"Acromag")
drvModbusAsynConfigure("DeflProbeServoWrite", "ExtrServoWrite",0,6,21,1,0,100,"Acromag")

drvModbusAsynConfigure("ExtrServoWriteRead", "ExtrServoWrite",0,4,0,1,0,100,"Acromag")
#Here to keep the write port open. Not used in code. KEEP IN.KEEP IN. KEEP IN.
#Also used to check the Status register of the Write Port. Used for Hardware Error checking.

## for the Source
drvModbusAsynConfigure("SourceRead", "IonSource",0,4,0,9,0,100,"Acromag")
drvModbusAsynConfigure("GasFlowWrite","IonSource",0,6,100,1,0,100,"Acromag")

## Read and Write EMC Acromag
drvModbusAsynConfigure("EMCRead", "AcromagEMC",0,4,0,8,0,100,"Acromag")
drvModbusAsynConfigure("EMCWrite","AcromagEMC",0,6,100,1,0,100,"Acromag")

## for PSHV
drvModbusAsynConfigure("DEFLRead","AcromagDEFL",0,4,0,9,0,100,"Acromag")
drvModbusAsynConfigure("DEFLWrite","AcromagDEFL",0,6,100,1,0,100,"Acromag")


## Set the auto save file paths
set_requestfile_path("autosaverequests")
set_savefile_path("../../../var/autosavefiles")



######################################################################################################################
######################################################################################################################
######################Load record instances
######################################################################################################################
######################################################################################################################


######################################################################################################################
######################## New Servo Records
######################################################################################################################


###############Servo ON/OFF
dbLoadRecords("../../db/ExtractorServo/ExtractorServoOnOff.vdb","SubSys=ExtrServo, Group=DEFLEntry")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoOnOff.vdb","SubSys=ExtrServo, Group=DEFLExit")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoOnOff.vdb","SubSys=ExtrServo, Group=EMCExit")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoOnOff.vdb","SubSys=ExtrServo, Group=DeflProbe")

###############Servo ON/OFF Requested by parameter on tuning module or Standby Transition for Deflector Probe
dbLoadRecords("../../db/ExtractorServo/ExtractorServoOnModule.vdb","Group=DEFLEntry, Param=Servo, ModCalcOn=A, ModCalcOff=A")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoOnModule.vdb","Group=DEFLExit, Param=Servo, ModCalcOn=A, ModCalcOff=A")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoOnModule.vdb","Group=EMCExit, Param=Servo, ModCalcOn=A, ModCalcOff=A")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoOnModule.vdb","Group=DeflProbe, Param=Servo, ModCalcOn=(A-D)|(B-E), ModCalcOff=A|B")

###############Servo Stand By 1/2 Transition Actions
###############NOTE: Deflector Probe Standby Actions are handled in ExtractorServoOnModule.vdb
dbLoadRecords("../../db/ExtractorServo/ExtractorServoSB1SB2.vdb","SubSys=ExtrServo")

##Servo Initialize
dbLoadRecords("../../db/ExtractorServo/ExtractorServoInitialize.vdb","SubSys=ExtrServo")

##Servo Condition
dbLoadRecords("../../db/ExtractorServo/ExtractorServoCondition.vdb","SubSys=ExtrServo")

###############Main control loop sequence for reading extractor servo drive positions
dbLoadRecords("../../db/ExtractorServo/ExtractorServoControlSeq.vdb","SubSys=ExtrServo")

###############Main control loop sequence for reading extractor servo drive positions
dbLoadRecords("../../db/ExtractorServo/ExtractorServoAnalog.vdb","Group=DEFLEntry, WritePort=DEFLEntryServoWrite, ReadPort=ExtractorRead, Offset=9")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoAnalog.vdb","Group=DEFLExit, WritePort=DEFLExitServoWrite, ReadPort=ExtractorRead, Offset=10")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoAnalog.vdb","Group=EMCExit, WritePort=EMCExitServoWrite, ReadPort=ExtractorRead, Offset=11")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoAnalog.vdb","Group=DeflProbe, WritePort=DeflProbeServoWrite, ReadPort=ExtractorRead, Offset=12")

###############Write Particle Beam interlocks for Servos.
dbLoadRecords("../../db/ExtractorServo/ExtractorServoBeamInterlockCondition.vdb","SubSys=ExtrServo, Group=DEFLEntry")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoBeamInterlockCondition.vdb","SubSys=ExtrServo, Group=DEFLExit")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoBeamInterlockCondition.vdb","SubSys=ExtrServo, Group=EMCExit")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoBeamInterlockCondition.vdb","SubSys=ExtrServo, Group=DeflProbe")

################### Establish Analog SET PV's
dbLoadRecords("../../db/ExtractorServo/ExtractorServoParamSet.vdb","Group=DEFLEntry, Param=Servo, PREC=2, Mult=.001, NoAttach=1, EGU=%, DRVH=98 , DRVL=35, PWZ=.5")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoParamSet.vdb","Group=DEFLExit, Param=Servo, PREC=2, Mult=.001, NoAttach=1, EGU=%, DRVH=70 , DRVL=5 , PWZ=.5")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoParamSet.vdb","Group=EMCExit, Param=Servo, PREC=2, Mult=.001, NoAttach=1, EGU=%, DRVH=98 , DRVL=42 , PWZ=.5")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoParamSet.vdb","Group=DeflProbe, Param=Servo, PREC=2, Mult=.1, NoAttach=1, EGU=%, DRVH=90 , DRVL=5 , PWZ=.5")

#######################Load Deflector Probe Specific Records
dbLoadRecords("../../db/ExtractorServo/ExtractorServoProbeLights.vdb")

##Load Default Values
dbLoadRecords("../../db/ExtractorServo/ExtractorServoDefaultValues.vdb","Group=DEFLEntry, Param=Servo, HiVal=57.5, SetVal=52.5, LoVal=47.5, DiffVal=1")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoDefaultValues.vdb","Group=DEFLExit, Param=Servo, HiVal=70, SetVal=68, LoVal=66, DiffVal=1.5")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoDefaultValues.vdb","Group=EMCExit, Param=Servo, HiVal=80, SetVal=70, LoVal=60, DiffVal=1")
dbLoadRecords("../../db/ExtractorServo/ExtractorServoDefaultValues.vdb","Group=DeflProbe, Param=Servo, HiVal=92, SetVal=89.3, LoVal=30, DiffVal=1")


################################################################################################################################
##############################Load PSHV control and Septum read Records
################################################################################################################################

##############################Initialize PSHV - InitializeRE has alias names instead of MOD1 numbers
dbLoadRecords("../../db/PSHV/PSHVInitialize.vdb","SubSys=DEFL")

###############################Read and write analog values for PSHV and Septum Temp
dbLoadRecords("../../db/PSHV/PSHVAnalog.vdb","SubSys=DEFL")

#############################PSHV On/OFF
dbLoadRecords("../../db/PSHV/PSHVOnOff.vdb","SubSys=DEFL")

#############################PSHV Check Interlocks
dbLoadRecords("../../db/PSHV/PSHVCondition.vdb","SubSys=DEFL")

#############################PSHV Check Interlocks
dbLoadRecords("../../db/PSHV/PSHVBeamInterlockCondition.vdb","SubSys=DEFL")

#############################Define PSHV Control Parameters
dbLoadRecords("../../db/PSHV/PSHVParamSet.vdb","SubSys=DEFL, Param=Volt,NoAttach=1,Mult=.0001,EGU=KV,PREC=2,PWZ=.5,DRVH=60,DRVL=0")

#############################Provide Diagnostic Messaging for Initialization
dbLoadRecords("../../db/PSHV/PSHVPrevent.vdb","PV=DEFL:BeamOn:Init,Msg=Init DEFL,Reason=Beam On")
dbLoadRecords("../../db/PSHV/PSHVPrevent.vdb","PV=DEFL:24Volt:Init,Msg=Init DEFL,Reason=No Control Voltage")


################################################################################################################################
##############################Load SOURCE
################################################################################################################################


##############################Initialize Source for ARC+Gas Manifold
dbLoadRecords("../../db/Source/SourceInitialize.vdb","SubSys=Source")

###############################Read and write analog values for PSARC AND Gas Flow Meter
dbLoadRecords("../../db/Source/SourceAnalog.vdb","SubSys=Source")

###############################Starts HB Processes, and writes HB
dbLoadRecords("../../db/Source/SourceControlSeq.vdb","SubSys=Source")

###############################Define Control Parameters for Gas Flow Meter
dbLoadRecords("../../db/Source/SourceParamSet.vdb","SubSys=Source, Device=Gas, Param=Flow, NoAttach=1, Mult=.00015, EGU=CCM, PREC=2, PWZ=0.1, DRVH=10, DRVL=0")

#############################SOURCE On/OFF PSARC Only 
dbLoadRecords("../../db/Source/SourceOnOff.vdb","SubSys=Source")

#############################PSARC Check Interlocks for PSARC and Gas Manifold
dbLoadRecords("../../db/Source/SourceCondition.vdb","SubSys=Source, GasValveDRVL=3.1, GasValveDRVH=3.7")

#############################PSARC Record N=1/2 Cathode Histories
dbLoadRecords("../../db/Source/SourceCathodeMonitor.vdb","SubSys=Source")

############################Select Particle Type
dbLoadRecords("../../db/Source/SourceGasSelect.vdb","SubSys=Gas, Device=Type")

############################PID Control for Gas Manifold only
dbLoadRecords("../../db/Source/SourcePIDControl.vdb","SubSys=Source, KP=0.035, KD=0.00, KI=0.00")

##############################Source System Reset
dbLoadRecords("../../db/Source/SourceSystemReset.vdb","SubSys=Source")

##Load stdby 1 to stby 2 transition database
dbLoadRecords("../../db/Source/SourceSystemSB1SB2.vdb","SubSys=Source")

#############################Provide Diagnostic Messaging for Initialization
dbLoadRecords("../../db/Source/SourcePrevent.vdb","PV=Source:Init,Msg=Init Source,Reason=Beam On")


######################################################################################################################
#####################################Load EMC Records
######################################################################################################################

##Load EMC Records
dbLoadRecords("../../db/EMC/EMCInitialize.vdb","SubSys=EMC")
dbLoadRecords("../../db/EMC/EMCAnalog.vdb","SubSys=EMC, CurrMult=44.765, VoltReadMult=0.0075, CurrReadMult=.048045")
dbLoadRecords("../../db/EMC/EMCOnOff.vdb","SubSys=EMC")
dbLoadRecords("../../db/EMC/EMCCondition.vdb","SubSys=EMC")
dbLoadRecords("../../db/EMC/EMCParamSet.vdb","SubSys=EMC, Param=Curr,NoAttach=1,Mult=.002,EGU=A,PREC=1,PWZ=.5,DRVH=480,DRVL=-4")
dbLoadRecords("../../db/EMC/EMCPrevent.vdb","PV=EMC:Output:Init,Msg=Init EMC,Reason=Beam On")
dbLoadRecords("../../db/EMC/EMCPrevent.vdb","PV=EMC:Output:Init:24Volt,Msg=Init EMC,Reason=No Control Voltage")
dbLoadRecords("../../db/ExtractionSystemReset.vdb")


######################################################################################################################
#####################################Load ISM Records
######################################################################################################################

dbLoadRecords("../../db/ISM/ISMOnOff.vdb", "SubSys=ISM, Device=Output, Param=Curr")
dbLoadRecords("../../db/ISM/ISMInitialize.vdb", "SubSys=ISM")
dbLoadRecords("../../db/ISM/ISMInitializeSupply.vdb", "SubSys=ISM, Device=Output, R=1, AsynPort=ISMGateway")
dbLoadRecords("../../db/ISM/ISMCondition.vdb","SubSys=ISM, Device=Output, Param=Curr")
dbLoadRecords("../../db/ISM/ISMParamSet.vdb","SubSys=ISM, Device=Output, Param=Curr, NoAttach=1,Mult=.0002,EGU=A,PREC=2,PWZ=.2,DRVH=2,DRVL=-2")
dbLoadRecords("../../db/ISM/ISMAnalog.vdb", "SubSys=ISM, Device=Output, Param=Curr,R=1, AsynPort=ISMGateway, Prec=2")
dbLoadRecords("../../db/ISM/ISMControlSeq.vdb", "SubSys=ISM")

## These create messages when pressed that say "Cannot $(Msg), $(Reason)." They are used to disable buttons (Ex. Init)
dbLoadRecords("../../db/ISM/ISMPrevent.vdb","PV=ISM:BeamOn:Init,Msg=Init ISM,Reason=Beam On")
dbLoadRecords("../../db/ISM/ISMPrevent.vdb","PV=ISM:NotOn:Init,Msg=Init ISN,Reason=Not On")



######################################################################################################################
#####################################Load Septum Records
######################################################################################################################

dbLoadRecords("../../db/SeptumTemp/SeptumPredictor.vdb", "SubSys=Source, Group=Septum, CON=25")
dbLoadRecords("../../db/SeptumTemp/SeptumTripReport.vdb", "SubSys=Source, Group=Septum")


######################################################################################################################
# Standby Transition Database
######################################################################################################################

##Load stdby 1 to stby 2 transition database
dbLoadRecords("../../db/ExtractionSystemSB1SB2.vdb", "SubSys=Extraction")

######################################################################################################################
# Load IOC Heartbeat database
######################################################################################################################

dbLoadRecords("../../db/IocHeartbeat.vdb", "SubSys=SrcExtr")


# now required in version 4.5
set_pass0_restoreFile(auto_positions.sav)
set_pass1_restoreFile(auto_settings.sav)


######################################################################################################################
######################################################################################################################
# Initialize IOC
######################################################################################################################
######################################################################################################################

iocInit()


# save positions every 60 seconds
create_monitor_set("auto_positions.req",60)
#save settings every 10 minutes
create_monitor_set("auto_settings.req",600)

## Start any sequence programs
#seq maysSnc,"user=rootHost"
