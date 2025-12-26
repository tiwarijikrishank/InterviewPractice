trigger TriggerSet16 on Task (before insert,before update,before delete,after insert,after update,after delete,after undelete){

	if(Trigger.isUpdate && Trigger.isBefore){
        //scenario 16a
		//TaskTriggerHandler.validateParentCaseStatus(trigger.new,trigger.oldMap);
	}
    if(trigger.isAfter){
         //scenario 16
        TaskTriggerHandler.updateCaseStatusBasedOnTask(trigger.new,trigger.oldMap,trigger.old);
    }
}