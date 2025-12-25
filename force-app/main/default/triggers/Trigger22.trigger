trigger Trigger22 on contact(before insert, before update,before delete, after undelete) {
	
		if(trigger.isInsert || trigger.isUpdate|| trigger.isUndelete){
			//ContactTriggerHandler.validateDuplicateEmailAcrossOrg(trigger.new, trigger.oldMap);
           //ContactTriggerHandler.validateDuplicateEmailAcrossAccount(trigger.new, trigger.oldMap);
           
		}

        if(
            trigger.isInsert ||
            trigger.isUpdate ||
            trigger.isUndelete ||
            trigger.isDelete
        ){
            ContactTriggerHandler.validatePrimaryOnAccount(trigger.new,trigger.oldMap,trigger.old);

        }
	
	}