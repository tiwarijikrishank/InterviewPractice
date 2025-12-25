trigger Scenario21 on contact (before insert, before update , after undelete){

    if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
		Set<String> accountIds = new Set<String>();
		Set<String> emailIds = new Set<String>();
		for(Contact conRecord : trigger.new){
			if(trigger.isUpdate){
				if(conRecord.AccountId != trigger.oldMap.get(conRecord.Id).AccountId ||
					conRecord.Email != trigger.oldMap.get(conRecord.Id).Email 
				){
					emailIds.add(conrecord.Email);
					accountIds.add(conRecord.AccountId);
				}
			}
			else{
				accountIds.add(conRecord.AccountId);
				emailIds.add(conrecord.Email);
			}
		}
		
		if(!accountIds.isEmpty()){
		
			List<contact> contactList = [select Email,AccountId from Contact where accountId in : accountIds and email in : emailIds];
			
			if(!contactList.isEmpty()){
				Map<Id,List<Contact>>	accountIdWithExistingEmailContactsMap = new Map<Id,List<Contact>>();
				for (Contact conRecord :contactList){
					if(!accountIdWithExistingEmailContactsMap.keyset().contains(conRecord.AccountId)){
						accountIdWithExistingEmailContactsMap.put(conRecord.AccountId, new List<Contact>());
					}
					accountIdWithExistingEmailContactsMap.get(conRecord.AccountId).add(conRecord);
			
				}
				
				for(Contact conRecord : trigger.new){
					if(accountIdWithExistingEmailContactsMap.keyset().contains(conRecord.AccountId)){
						if(!trigger.isUndelete){
							if(accountIdWithExistingEmailContactsMap.get(conRecord.AccountId).size() >0){
								conRecord.addError('Duplicate Contact With Same Email');
							}
						}
						else{
							if(accountIdWithExistingEmailContactsMap.get(conRecord.AccountId).size() >1){
								conRecord.addError('Duplicate Contact With Same Email');
							}
						}
						
					}
				}
			}
		}
        
    }

}