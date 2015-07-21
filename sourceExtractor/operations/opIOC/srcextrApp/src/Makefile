TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

PROD_IOC = srcextr
DBD = srcextr.dbd

srcextr_DBD += commonInclude.dbd

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
srcextr_SRCS += srcextr_registerRecordDeviceDriver.cpp
srcextr_SRCS += srcextrMain.cpp

srcextr_LIBS += asyn calc sscan modbus autosave stream std

#===========================


srcextr_LIBS += $(EPICS_BASE_IOC_LIBS)
#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
