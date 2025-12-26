trigger TriggerSet14 on Case(before update) {

	if(trigger.isUpdate){
		CaseTriggerHandler.restrictCaseClosureBasedOnTask(trigger.new,trigger.oldMap);
	}

}