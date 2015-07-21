LOGPATH=/usr/local/cnts/epics/operations/var
BASENAME=cathodecurrent.log
PV=Source:Cathode:History:Record
nohup camonitor $PV >> $LOGPATH/$BASENAME &
