//EJERCICIO 2
trigger autocreate_sprint on Project__c (after insert) {
    List<sprint__c> sprintList = new List<sprint__c>();
    for (Project__c p : Trigger.new) {
        sprintList.add(
            new sprint__c(
                Name = 'Backlog', 
                Project__c = p.Id, 
                Start_Date__c = Date.today(), 
                End_Date__c = Date.today()
            )
        );
    }
    insert sprintList;
}