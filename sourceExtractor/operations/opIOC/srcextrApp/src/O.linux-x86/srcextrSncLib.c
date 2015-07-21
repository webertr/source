/* SNC Version 2.0.12: Fri Aug  5 14:01:52 2011: srcextrSncLib.i */

/* Event flags */

/* Program "srcextrSnc" */
#include "seqCom.h"

#define NUM_SS 1
#define NUM_CHANNELS 4
#define NUM_EVENTS 0
#define NUM_QUEUES 0

#define MAX_STRING_SIZE 40

#define ASYNC_OPT FALSE
#define CONN_OPT TRUE
#define DEBUG_OPT FALSE
#define MAIN_OPT FALSE
#define NEWEF_OPT TRUE
#define REENT_OPT FALSE

extern struct seqProgram srcextrSnc;

/* Variable declarations */
static double	setting;
static short	light;
static short	fault;
static char	currentstate[MAX_STRING_SIZE];

/* Not used (avoids compilation warnings) */
struct UserVar {
	int	dummy;
};

/* Entry handler */
static void entry_handler(SS_ID ssId, struct UserVar *pVar)
{
}

/* Code for state "light_on" in state set "set_lights" */

/* Delay function for state "light_on" in state set "set_lights" */
static void D_set_lights_light_on(SS_ID ssId, struct UserVar *pVar)
{
# line 31 "../srcextrSncLib.st"
# line 39 "../srcextrSncLib.st"
}

/* Event function for state "light_on" in state set "set_lights" */
static long E_set_lights_light_on(SS_ID ssId, struct UserVar *pVar, short *pTransNum, short *pNextState)
{
# line 31 "../srcextrSncLib.st"
	if (setting >= 5.0)
	{
		*pNextState = 1;
		*pTransNum = 0;
		return TRUE;
	}
# line 39 "../srcextrSncLib.st"
	if (setting > 10.0)
	{
		*pNextState = 2;
		*pTransNum = 1;
		return TRUE;
	}
	return FALSE;
}

/* Action function for state "light_on" in state set "set_lights" */
static void A_set_lights_light_on(SS_ID ssId, struct UserVar *pVar, short transNum)
{
	switch(transNum)
	{
	case 0:
		{
# line 26 "../srcextrSncLib.st"
			strcpy(currentstate, "Light Off");
			seq_pvPut(ssId, 3 /* currentstate */, 0);
# line 29 "../srcextrSncLib.st"
			light = 0;
			seq_pvPut(ssId, 1 /* light */, 0);
		}
		return;
	case 1:
		{
# line 34 "../srcextrSncLib.st"
			strcpy(currentstate, "Fault");
			seq_pvPut(ssId, 3 /* currentstate */, 0);
# line 37 "../srcextrSncLib.st"
			light = 1;
			seq_pvPut(ssId, 2 /* fault */, 0);
		}
		return;
	}
}
/* Code for state "light_off" in state set "set_lights" */

/* Delay function for state "light_off" in state set "set_lights" */
static void D_set_lights_light_off(SS_ID ssId, struct UserVar *pVar)
{
# line 49 "../srcextrSncLib.st"
# line 57 "../srcextrSncLib.st"
}

/* Event function for state "light_off" in state set "set_lights" */
static long E_set_lights_light_off(SS_ID ssId, struct UserVar *pVar, short *pTransNum, short *pNextState)
{
# line 49 "../srcextrSncLib.st"
	if (setting < 5.0)
	{
		*pNextState = 0;
		*pTransNum = 0;
		return TRUE;
	}
# line 57 "../srcextrSncLib.st"
	if (setting > 10.0)
	{
		*pNextState = 2;
		*pTransNum = 1;
		return TRUE;
	}
	return FALSE;
}

/* Action function for state "light_off" in state set "set_lights" */
static void A_set_lights_light_off(SS_ID ssId, struct UserVar *pVar, short transNum)
{
	switch(transNum)
	{
	case 0:
		{
# line 44 "../srcextrSncLib.st"
			strcpy(currentstate, "Light On");
			seq_pvPut(ssId, 3 /* currentstate */, 0);
# line 47 "../srcextrSncLib.st"
			light = 1;
			seq_pvPut(ssId, 1 /* light */, 0);
		}
		return;
	case 1:
		{
# line 52 "../srcextrSncLib.st"
			strcpy(currentstate, "Fault");
			seq_pvPut(ssId, 3 /* currentstate */, 0);
# line 55 "../srcextrSncLib.st"
			light = 1;
			seq_pvPut(ssId, 2 /* fault */, 0);
		}
		return;
	}
}
/* Code for state "fault" in state set "set_lights" */

/* Delay function for state "fault" in state set "set_lights" */
static void D_set_lights_fault(SS_ID ssId, struct UserVar *pVar)
{
# line 66 "../srcextrSncLib.st"
# line 74 "../srcextrSncLib.st"
}

/* Event function for state "fault" in state set "set_lights" */
static long E_set_lights_fault(SS_ID ssId, struct UserVar *pVar, short *pTransNum, short *pNextState)
{
# line 66 "../srcextrSncLib.st"
	if (setting < 5.0)
	{
		*pNextState = 0;
		*pTransNum = 0;
		return TRUE;
	}
# line 74 "../srcextrSncLib.st"
	if (setting >= 5.0)
	{
		*pNextState = 1;
		*pTransNum = 1;
		return TRUE;
	}
	return FALSE;
}

/* Action function for state "fault" in state set "set_lights" */
static void A_set_lights_fault(SS_ID ssId, struct UserVar *pVar, short transNum)
{
	switch(transNum)
	{
	case 0:
		{
# line 61 "../srcextrSncLib.st"
			strcpy(currentstate, "Light On");
			seq_pvPut(ssId, 3 /* currentstate */, 0);
# line 64 "../srcextrSncLib.st"
			light = 1;
			seq_pvPut(ssId, 1 /* light */, 0);
		}
		return;
	case 1:
		{
# line 69 "../srcextrSncLib.st"
			strcpy(currentstate, "Light Off");
			seq_pvPut(ssId, 3 /* currentstate */, 0);
# line 72 "../srcextrSncLib.st"
			light = 0;
			seq_pvPut(ssId, 1 /* light */, 0);
		}
		return;
	}
}

/* Exit handler */
static void exit_handler(SS_ID ssId, struct UserVar *pVar)
{
}

/************************ Tables ***********************/

/* Database Blocks */
static struct seqChan seqChan[NUM_CHANNELS] = {
  {"MOD1:VacuumPressure.VAL", (void *)&setting, "setting", 
    "double", 1, 1, 0, 1, 0, 0, 0},

  {"MOD1:bit16", (void *)&light, "light", 
    "short", 1, 2, 0, 0, 0, 0, 0},

  {"MOD1:bit17", (void *)&fault, "fault", 
    "short", 1, 3, 0, 0, 0, 0, 0},

  {"MOD1:CurrentVacuumState", (void *)&currentstate[0], "currentstate", 
    "string", 1, 4, 0, 0, 0, 0, 0},

};

/* Event masks for state set set_lights */
	/* Event mask for state light_on: */
static bitMask	EM_set_lights_light_on[] = {
	0x00000002,
};
	/* Event mask for state light_off: */
static bitMask	EM_set_lights_light_off[] = {
	0x00000002,
};
	/* Event mask for state fault: */
static bitMask	EM_set_lights_fault[] = {
	0x00000002,
};

/* State Blocks */

static struct seqState state_set_lights[] = {
	/* State "light_on" */ {
	/* state name */       "light_on",
	/* action function */ (ACTION_FUNC) A_set_lights_light_on,
	/* event function */  (EVENT_FUNC) E_set_lights_light_on,
	/* delay function */   (DELAY_FUNC) D_set_lights_light_on,
	/* entry function */   (ENTRY_FUNC) 0,
	/* exit function */   (EXIT_FUNC) 0,
	/* event mask array */ EM_set_lights_light_on,
	/* state options */   (0)},

	/* State "light_off" */ {
	/* state name */       "light_off",
	/* action function */ (ACTION_FUNC) A_set_lights_light_off,
	/* event function */  (EVENT_FUNC) E_set_lights_light_off,
	/* delay function */   (DELAY_FUNC) D_set_lights_light_off,
	/* entry function */   (ENTRY_FUNC) 0,
	/* exit function */   (EXIT_FUNC) 0,
	/* event mask array */ EM_set_lights_light_off,
	/* state options */   (0)},

	/* State "fault" */ {
	/* state name */       "fault",
	/* action function */ (ACTION_FUNC) A_set_lights_fault,
	/* event function */  (EVENT_FUNC) E_set_lights_fault,
	/* delay function */   (DELAY_FUNC) D_set_lights_fault,
	/* entry function */   (ENTRY_FUNC) 0,
	/* exit function */   (EXIT_FUNC) 0,
	/* event mask array */ EM_set_lights_fault,
	/* state options */   (0)},


};

/* State Set Blocks */
static struct seqSS seqSS[NUM_SS] = {
	/* State set "set_lights" */ {
	/* ss name */            "set_lights",
	/* ptr to state block */ state_set_lights,
	/* number of states */   3,
	/* error state */        -1},
};

/* Program parameter list */
static char prog_param[] = "";

/* State Program table (global) */
struct seqProgram srcextrSnc = {
	/* magic number */       20000315,
	/* *name */              "srcextrSnc",
	/* *pChannels */         seqChan,
	/* numChans */           NUM_CHANNELS,
	/* *pSS */               seqSS,
	/* numSS */              NUM_SS,
	/* user variable size */ 0,
	/* *pParams */           prog_param,
	/* numEvents */          NUM_EVENTS,
	/* encoded options */    (0 | OPT_CONN | OPT_NEWEF),
	/* entry handler */      (ENTRY_FUNC) entry_handler,
	/* exit handler */       (EXIT_FUNC) exit_handler,
	/* numQueues */          NUM_QUEUES,
};
#include "epicsExport.h"


/* Register sequencer commands and program */

void srcextrSncRegistrar (void) {
    seqRegisterSequencerCommands();
    seqRegisterSequencerProgram (&srcextrSnc);
}
epicsExportRegistrar(srcextrSncRegistrar);

