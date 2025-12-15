public without sharing class lwcMethodsController {
    
    @auraEnabled(cacheable = true)
        public static List<Contact> getContactsWithName(string nameSearch){
            string nameSearchKey = '%' + nameSearch + '%';
            List<Contact> conList = [SELECT Id, Name, Email, Phone FROM Contact WHERE name Like :nameSearchKey LIMIT 3];
            return conList;
    }

    @auraEnabled
        public static Account createAccountWithName(string accountName){
            
            Account acc = new Account(Name = accountName);
            insert acc;
            return acc;
    }

    @auraEnabled
        public static void updateContactName(string searchContactName, string contactName){
            string nameSearchKey = '%' + searchContactName + '%';
            Contact con = [SELECT Id, Name FROM Contact WHERE name like  :nameSearchKey   LIMIT 1];
            con.lastName = contactName + ' - Updated';
            con.FirstName = '';
            update con;
    }
}