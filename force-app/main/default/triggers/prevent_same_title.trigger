//EJERCICIO 2
trigger prevent_same_title on Work_Item__c (before insert, before update) {
    
    for(Work_Item__c wi1 : Trigger.new){
        //GET THE PROJECT ID
        List<Sprint__c> sprint = [SELECT Project__c FROM Sprint__c WHERE id = :wi1.Sprint__c];
        //LIST WORK ITEM RELATED WITH THE PROJECT     
        List<Work_Item__c> list_wi;
        if(trigger.IsUpdate){        
            list_wi = [SELECT ID,Name FROM Work_Item__c WHERE Sprint__r.Project__c = :sprint[0].Project__c AND ID != :wi1.ID];
        }else{
         	list_wi = [SELECT ID,Name FROM Work_Item__c WHERE Sprint__r.Project__c = :sprint[0].Project__c];   
        }
        
        //COMPARE NAMES
        for(Work_Item__c wi2 : list_wi){
            if(wi1.Name == wi2.Name){
                wi1.addError('The title is already registered in the sprint');
            }
        }
    }
}

/*
Observación -> El trigger solo reconoce el primer insert o update y no todos

trigger prevent_same_title on Work_Item__c (before insert, before update) {
    Work_Item__c[] wi1 = Trigger.new;
    Sprint__c[] sprint = [SELECT Project__c FROM Sprint__c WHERE id = :wi1[0].Sprint__c];
    List<Work_Item__c> list_wi = [SELECT ID,Name FROM Work_Item__c WHERE Sprint__r.Project__c = :sprint[0].Project__c AND ID != :wi1[0].ID];
    //COMPARE NAMES
    for(Work_Item__c wi2 : list_wi){
        if(wi1[0].Name == wi2.Name){
        	Trigger.oldMap.get(wi1[0].Id).addError('The title is already registered in the sprint');
        }
    }
}
*/