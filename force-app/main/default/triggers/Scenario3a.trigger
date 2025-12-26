trigger Scenario3a on Contact (after insert , after update, after undelete,after delete){
    
    
    set<Id> accountIds = new Set<Id>();                                                     
    if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
        for(Contact conRecord : trigger.new){
            if(trigger.isUpdate){
                if(conRecord.accountId != trigger.oldmap.get(conRecord.Id).AccountId){
                        accountIds.add(conRecord.accountId);
                }
            }
            else{
                accountIds.add(conRecord.accountId);
            }
        }
    }
    if(trigger.isDelete){
        for(Contact conRecord : trigger.old){
            accountIds.add(conRecord.accountId);
        }
    }
        
        if(!accountIds.isEmpty()){
            List<Contact> contactList = [select id,FirstName,LastName,AccountId from Contact where accountId in : accountIds];
            if(!contactList.isEmpty()){
                Map<id,Account> accountIdAndAccountMap = new Map<Id,Account>();
                for(Contact conRecord: contactList){
                    string details = conRecord.FirstName +' ' + conRecord.LastName + '\n';
                    if(!accountIdAndAccountMap.keyset().contains(conRecord.AccountId)){
                        accountIdAndAccountMap.put(conRecord.AccountId, new Account());
                    }
                    Account accRecord = accountIdAndAccountMap.get(conRecord.AccountId);
                    accRecord.Description = accRecord.Description != null ?  accRecord.Description + details : details;
                    accRecord.id = conRecord.AccountId;
                    accountIdAndAccountMap.put(conRecord.AccountId,accRecord);
                }
                
                update accountIdAndAccountMap.values();
            }
        }
    
    

}