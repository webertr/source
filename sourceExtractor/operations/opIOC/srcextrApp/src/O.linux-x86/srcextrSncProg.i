# 1 "../srcextrSncProg.st"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "../srcextrSncProg.st"
# 1 "./../srcextrSncLib.st" 1






program srcextrSnc

double setting;
assign setting to "MOD1:VacuumPressure.VAL";
monitor setting;

short light;
assign light to "MOD1:bit16";

short fault;
assign fault to "MOD1:bit17";

string currentstate;
assign currentstate to "MOD1:CurrentVacuumState";

ss set_lights
{
 state light_on{
  when(setting >= 5.0){
   strcpy(currentstate, "Light Off");
                pvPut(currentstate);

  light=FALSE;
  pvPut(light);
  }state light_off

  when(setting > 10.0){
                strcpy(currentstate, "Fault");
                pvPut(currentstate);

                light=TRUE;
                pvPut(fault);
                }state fault
 }

 state light_off{
  when(setting < 5.0){
                strcpy(currentstate, "Light On");
                pvPut(currentstate);

  light=TRUE;
  pvPut(light);
  }state light_on

  when(setting > 10.0){
  strcpy(currentstate, "Fault");
                pvPut(currentstate);

                light=TRUE;
                pvPut(fault);
                }state fault
 }
 state fault{
  when(setting < 5.0){
  strcpy(currentstate, "Light On");
                pvPut(currentstate);

                light=TRUE;
                pvPut(light);
                }state light_on

   when(setting >= 5.0){
                strcpy(currentstate, "Light Off");
                pvPut(currentstate);

                light=FALSE;
                pvPut(light);
                }state light_off
 }
}
# 1 "../srcextrSncProg.st" 2
