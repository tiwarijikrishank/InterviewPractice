public with sharing class StringAndApexClass {

	public  static void soqlScenarios(){

		List<AggregateResult> aggrList = [select AccountId from contact group by AccountId having count(Id) > 2 ]; // atlease 2 contacts 
		//(having is not allowed in subquery)


		List<AggregateResult> aggrList1 = [select AccountId from contact group by AccountId having count(Id) <= 2 ]; // atmost 2

		List<AggregateResult> aggrList2 = [select Account.Name,Email,count(Id) from contact group by Account.Name,Email ];
		// count of contacts having account name and same email 

		 List<Account> accountList =   [ select Name,Id  from Account where Id not in (select AccountId from contact )];
		 // get accounts with no contacts

		 List<AggregateResult> aggrList3 =[select AccountId, count(Id) from Opportunity where amount > 50000];
		// get opps count for an account having opps amount > 50000

	}


	public static  List<contact> paginationController(integer pageNumber) {

			integer recordsLimit = 10;

			integer offsetValue = (pageNumber - 1) * recordsLimit;

			List<contact> conRecordList = [select FirstName,LastName from Contact limit:recordsLimit offset:offsetValue];

			return conRecordList;
	}

	}