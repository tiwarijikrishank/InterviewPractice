public class AccountNameReversalBatch implements Database.Batchable<sObject>,Database.Stateful {
	List<Account> accountListUpdated = new List<Account>();
	public Database.QueryLocator start (Database.BatchableContext bc) {

		//string accountName   = 'Reshu'+'%';
		string query = 'select Id,Name from Account order by lastmodifieddate desc limit 1';//where name like :accountName';
		 return database.getQueryLocator(query);
	}

	public void execute (Database.BatchableContext bc, list<Account> scope) {
		system.debug(scope.size());
		for(Account account : scope){
			if(string.isNotBlank(account.Name)){
				string[] splitNameWithSpaceList = account.Name.split(' '); // Reshu Tiwari = ['reshu','tiwari']
				string nameWithoutSpace = 	string.join(splitNameWithSpaceList,''); //'reshutiwari'
				string[] splitNameWithCharsList = account.Name.split(''); //['r','e'..so on]
				List<string>	reversedCharList = new List<string>();
				for(integer i=splitNameWithCharsList.size()-1 ; i>=0 ; i--) {
					reversedCharList.add(splitNameWithCharsList[i]);
				}
				string reversedName = string.join(reversedCharList,''); //reversedName
				account.Name = reversedName;
			}
		}
		update scope;
		accountListUpdated.addAll(scope);

	}

	public void Finish (Database.BatchableContext bc) {
		system.debug(accountListUpdated.size());
	}


}