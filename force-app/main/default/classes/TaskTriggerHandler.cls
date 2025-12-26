public class TaskTriggerHandler {


	public static void validateParentCaseStatus(List<Task> newTaskList, Map<Id,Task> oldMapTask){
		set<String> parentCases = new Set<String>();
		for(Task taskRecord : newTaskList){
			if( taskRecord.Status != oldMapTask.get(taskRecord.Id).Status &&
				taskRecord.Status == 'Completed' && string.isNotBlank(taskRecord.WhatId)){
				
				parentCases.add(taskRecord.WhatId);
			}
		}
		
		if(!parentCases.isEmpty()){
			
			Map<Id, Case>  parentCaseMap = new Map<Id,Case>([select Id,Status,isClosed from Case where Id IN: parentCases]);
			
			for(Task taskRecord : newTaskList){
			if( taskRecord.Status != oldMapTask.get(taskRecord.Id).Status &&
				taskRecord.Status =='Completed' && string.isNotBlank(taskRecord.WhatId)){
					
					if(parentCaseMap.keyset().contains(taskRecord.whatId) 
						&& !parentCaseMap.get(taskRecord.whatId).isClosed ){
						
						taskRecord.addError('child task cannot be closed if parent case is not closed');
					
					}
			}
		}
		
		}
	}

	public static void updateCaseStatusBasedOnTask (list<task> newTaskList, map<Id,task> oldTaskMap, list<task> oldTaskList ){
		 set<string> caseIds = new Set<String>();
		 set<task> impactedTaskSet = new Set<task>();
		if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
			
			for(Task taskRecord : newTaskList){
				if(trigger.isUpdate) {
					if(taskRecord.status != oldTaskMap.get(taskRecord.Id).Status 
						&& String.isNotBlank(taskRecord.whatId)){
							caseIds.add(taskRecord.whatId);
							impactedTaskSet.add(taskRecord);
					}
				}
                
				else {
					caseIds.add(taskRecord.whatId);
					impactedTaskSet.add(taskRecord);
				}
			}
		}
		
		if(trigger.isDelete){
			for(Task taskRecord : oldTaskList){
				if(String.isNotBlank(taskRecord.whatId)){
					caseIds.add(taskRecord.whatId);
					impactedTaskSet.add(taskRecord);
				}
			}
		}
		
		if(!caseIds.isEmpty()){
			List<Task> existingTaskList = [select Id,Status,WhatId from task where whatId In: caseIds];
			Map<Id,List<task>> caseIdAndAllTasksMap = new Map<Id,List<task>>();
			Map<Id,List<task>> caseIdAndClosedTasksMap = new Map<Id,List<task>>();
			if(!existingTaskList.isEmpty()) {
				for(Task taskRecord : existingTaskList){
					if(!caseIdAndAllTasksMap.keyset().contains(taskRecord.whatId)){
						caseIdAndAllTasksMap.put(taskRecord.whatId, new List<task>());
					}
					caseIdAndAllTasksMap.get(taskRecord.whatId).add(taskRecord);
					
					if(taskRecord.Status == 'Completed'){
						if(!caseIdAndClosedTasksMap.keyset().contains(taskRecord.whatId)){
							caseIdAndClosedTasksMap.put(taskRecord.whatId, new List<task>());
					}
						caseIdAndClosedTasksMap.get(taskRecord.whatId).add(taskRecord);
					}
				}
				if(!impactedTaskSet.isEmpty()){
					 Map<Id,Case> mapofCaseIdAndCaseRecord = new Map<Id,Case>();
					for(Task taskRecord: impactedTaskSet){
						if(caseIdAndAllTasksMap.keyset().contains(taskRecord.whatId)){
                           Integer totalTasks = caseIdAndAllTasksMap.get(taskRecord.whatId).size();
                            if(caseIdAndClosedTasksMap.keyset().contains(taskRecord.whatId) 
                             && totalTasks  == caseIdAndClosedTasksMap.get(taskRecord.whatId).size()
                             )  {
							        mapofCaseIdAndCaseRecord.put(taskRecord.whatId, new Case(Id = taskRecord.whatId, Status ='Closed' ));
                                    // update case to open if all child tasks are not closed
                             }
                             else{
								    mapofCaseIdAndCaseRecord.put(taskRecord.whatId, new Case(Id = taskRecord.whatId, Status ='Open' ));
                                 // update case to closed if all child tasks are not closed
							    }
						    }
						}
                        if(!mapofCaseIdAndCaseRecord.isEmpty()){
						update mapofCaseIdAndCaseRecord.values();
					
					}
						
					}
					
					
				}
			
			}
		
		}	
    
}