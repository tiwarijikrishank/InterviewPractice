trigger Trigger22 on contact(before insert, before update,before delete, after undelete) {
	
		if(trigger.isInsert || trigger.isUpdate|| trigger.isUndelete){
			//ContactTriggerHandler.validateDuplicateEmailAcrossOrg(trigger.new, trigger.oldMap); // Secenrio 22
           //ContactTriggerHandler.validateDuplicateEmailAcrossAccount(trigger.new, trigger.oldMap); // scenario 21
           
		}

        if(
            trigger.isInsert ||
            trigger.isUpdate ||
            trigger.isUndelete ||
            trigger.isDelete
        ){
            ContactTriggerHandler.validatePrimaryOnAccount(trigger.new,trigger.oldMap,trigger.old); // scenario 19

        }
	
	}