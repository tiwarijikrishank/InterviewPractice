public class ContactTriggerHandler {
    
    public static void validateDuplicateEmailAcrossOrg( List<contact> newConList, Map<Id,Contact> triggerOldMap){
        set<string> contactEmails = new set<string>();
        for(Contact conRecord : newConList){
            if(string.isNotBlank(conRecord.Email)){
                if(trigger.isUpdate){
                    if(conRecord.Email != triggerOldMap.get(conRecord.Id).Email) {
                            contactEmails.add(conRecord.Email);
                    }
                }
                else {
                    contactEmails.add(conRecord.Email);
                }
            }
        }
        if(!contactEmails.isEmpty()){
             Map<string,List<contact>> mapofEmailAndContacts = new  map<string,List<contact>>();
            List<contact> existingContacts = [ select Email,Id from Contact where email in: contactEmails];
            if(!existingContacts.isEmpty()){
                for(Contact conRecord: existingContacts){
                        if(!mapofEmailAndContacts.keyset().contains(conRecord.Email)){
                            mapofEmailAndContacts.put(conRecord.Email,new List<Contact>());
                        }
                        mapofEmailAndContacts.get(conRecord.Email).add(conRecord);
                }
            }
            
            for(Contact conRecord : newConList){
                if(mapofEmailAndContacts.keyset().contains(conRecord.Email)){
                    if(trigger.isInsert || trigger.isUpdate){
                        if(mapofEmailAndContacts.get(conRecord.Email).size() > 0){
                            conRecord.addError('contact with duplicate email cannot be inserted or updated with same email');
                        }
                    }
                    else{
                        if(mapofEmailAndContacts.get(conRecord.Email).size() > 1){
                            conRecord.addError('contact with duplicate email cannot be undeleted');
                        }
                    
                    }
                
                }
            
            }
        
        }
    }

    public static void validateDuplicateEmailAcrossAccount( List<contact> newConList, Map<Id,Contact> triggerOldMap){
        set<string> contactEmails = new set<string>();
        set<string> accountIds = new set<string>();
        for(Contact conRecord : newConList){
            if(string.isNotBlank(conRecord.Email)){
                if(trigger.isUpdate){
                    if(conRecord.Email != triggerOldMap.get(conRecord.Id).Email ||
                    conRecord.AccountId != triggerOldMap.get(conRecord.Id).AccountId) {
                            contactEmails.add(conRecord.Email);
                            accountIds.add(conRecord.AccountId);
                    }
                }
                else {
                    contactEmails.add(conRecord.Email);
                    accountIds.add(conRecord.AccountId);
                }
            }
        }
        if(!contactEmails.isEmpty()){
             Map<string,List<contact>> mapofEmailAndContacts = new  map<string,List<contact>>();
            List<contact> existingContacts = [ select AccountId,Email,Id from Contact where email in: contactEmails 
                and AccountId In: accountIds];
            if(!existingContacts.isEmpty()){
                for(Contact conRecord: existingContacts){
                        string key = conRecord.Email +'_'+ conRecord.AccountId;
                        if(!mapofEmailAndContacts.keyset().contains(key)){
                            mapofEmailAndContacts.put(key ,new List<Contact>());
                        }
                        mapofEmailAndContacts.get(key).add(conRecord);
                }
            }
            
            for(Contact conRecord : newConList){
                string key = conRecord.Email +'_'+ conRecord.AccountId;
                if(mapofEmailAndContacts.keyset().contains(key)){
                    if(trigger.isInsert || trigger.isUpdate){
                        if(mapofEmailAndContacts.get(key).size() > 0){
                            conRecord.addError('contact with duplicate email cannot be inserted or updated with same email on same account');
                        }
                    }
                    else{
                        if(mapofEmailAndContacts.get(key).size() > 1){
                            conRecord.addError('contact with duplicate email cannot be undeleted on same account');
                        }
                    
                    }
                
                }
            
            }
        
        }
    }

    public static void validatePrimaryOnAccount(List<contact> conList , Map<Id,Contact> oldMap, List<contact> oldConList) {
        set<string> accountIds = new set<string>();
		set<Contact> impactedContacts = new Set<Contact>();
		if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
            for(Contact con : conList){
				if(con.isPrimary__c){
					if(trigger.isUpdate){
						if(con.isPrimary__c != oldMap.get(con.id).isPrimary__c ||
							con.AccountId != oldMap.get(con.id).AccountId
						){
							accountIds.add(con.accountId);
							impactedContacts.add(con);
						}
						
					}
					else{
							accountIds.add(con.accountId);
							impactedContacts.add(con);
					}
				
				}
			}
        }
		if(trigger.isDelete){
		  for(Contact con : oldConList){
				if(con.isPrimary__c){
					accountIds.add(con.accountId);
					impactedContacts.add(con);
				}
			}	
		
		}
		
		if(!accountIds.isEmpty()){
			List<Contact> contactList = [select Id,AccountId,isPrimary__c from Contact where accountId in :  accountIds];
			if(!contactList.isEmpty()){
				Map<Id,List<contact>> mapofAccountIdAndPrimaryContacts = new Map<Id,List<contact>>();
				for (Contact con : contactList){
					if(con.isPrimary__c){
						if(!mapofAccountIdAndPrimaryContacts.keyset().contains(con.AccountId)) {
							mapofAccountIdAndPrimaryContacts.put(con.AccountId, new List<contact>());
						}
						mapofAccountIdAndPrimaryContacts.get(con.AccountId).add(con);
					}
				
				}
				
				for(Contact con : impactedContacts){
					if(mapofAccountIdAndPrimaryContacts.keyset().contains(con.AccountId)){
						if(trigger.isInsert || trigger.isUpdate){
							if(mapofAccountIdAndPrimaryContacts.get(con.AccountId).size() > 0){
								con.addError('more than one primary not allowed on insert or update');
							
							}
						}
						else if (trigger.isUndelete){
							if(mapofAccountIdAndPrimaryContacts.get(con.AccountId).size() > 1){
								con.addError('more than one primary not allowed on undelete');
							
							}
						}
						else if (trigger.isDelete){
							if(mapofAccountIdAndPrimaryContacts.get(con.AccountId).size() == 1){
								con.addError('primary not allowed to be deleted');
							
							}
						
						}
					
					}
				
				
				}
			
			}
		
		}
		
		
    }

}