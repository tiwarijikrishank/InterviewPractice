trigger Scenario22 on Contact(before Insert, before update , after undelete ) {
    
    if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
        set<string> emailIds = new set<string>();
        for(Contact conRecord: trigger.new){
            if(trigger.isUpdate){
                if(conRecord.Email != trigger.newMap.get(conRecord.Id).Email || 
                    conRecord.AccountId != trigger.newMap.get(conRecord.Id).AccountId
                )
                {
                    emailIds.add(conRecord.email);
                }
                }   
                else{
                    emailIds.add(conRecord.email);
                }
            
        }
        
        if(!emailIds.isEmpty()){
            list<contact> contactList = [select Id,Email from contact where email IN: emailIds];// and Id Not IN: trigger.newMap.keyset()];
            Map<string,List<contact>> existingEmailWithContatMap = new Map<string,List<contact>>();
            set<string> existingEmailIds = new set<string>();
            if(!contactList.isEmpty()){
                for(Contact conRecord : contactList){
                    existingEmailIds.add(conRecord.Email);
                    
                     // if undelete ko bi use krna hai toh yahan pr (email, contact with that email ki list bna lo fir count check krlo)
                    if(!existingEmailWithContatMap.keyset().contains(conRecord.Email)){
                        existingEmailWithContatMap.put(conRecord.Email, new List<contact>());
                    }
                    existingEmailWithContatMap.get(conRecord.Email).add(conRecord);
                }
            }
            for(Contact con : trigger.new){
                if(!trigger.isUndelete){
                    if(existingEmailIds.contains(con.Email)){
                        con.addError('duplicte email record');
                    }
                }
                else{
                        if(existingEmailWithContatMap.keyset().contains(con.Email)){
                            if(existingEmailWithContatMap.get(con.Email).size() > 1){
                                con.addError('duplicte email record');
                            }
                    }
                }
            }
        }
    }


}