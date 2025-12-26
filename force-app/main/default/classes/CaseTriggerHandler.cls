public class CaseTriggerHandler {
	
	public static void restrictCaseClosureBasedOnTask(list<case> newCaseList, Map<Id,Case> oldCaseMap) {
		
		if(trigger.isUpdate){
				Map<Id,case> impactedCaseMap = new Map<Id,case>();
			for(Case caseRecord : newCaseList) {
				if(caseRecord.Status != oldCaseMap.get(caseRecord.Id).Status &&
						caseRecord.Status =='Closed' )
				{
					impactedCaseMap.put(caseRecord.Id,caseRecord);
				}
			}
			
			if(!impactedCaseMap.keyset().isEmpty()){
					List<Task> taskList = [select Id,Status,whatid,isClosed from task where whatId IN: impactedCaseMap.keyset()];
					if(!taskList.isEmpty()){
						Map<Id,List<Task>>  parentCaseAndChildTasksMap = new Map<Id,List<task>>();
							for(Task taskRecord: taskList) {
								if(!taskRecord.isClosed){
									if(!parentCaseAndChildTasksMap.keyset().contains(taskRecord.whatId)){
											parentCaseAndChildTasksMap.put(taskRecord.whatId, new List<task>());
									}
										parentCaseAndChildTasksMap.get(taskRecord.whatId).add(taskRecord);
								}
							}
							if(!impactedCaseMap.isEmpty()){
								for(Case caseRecord : impactedCaseMap.values()){
										if(parentCaseAndChildTasksMap.keyset().contains(caseRecord.Id) && 
											parentCaseAndChildTasksMap.get(caseRecord.Id).size() > 0
										){
											caseRecord.addError('Parent case cannot be closed if any child is opened');
										}
								}
							}
					}
				
			}
		}
	}
}