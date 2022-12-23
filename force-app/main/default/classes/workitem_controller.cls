//EJERCICIO 2
public class workitem_controller {
    public String statusselected {get;set;}

    public workitem_controller(){
        this.statusselected = '%%';
    }

    public List<Work_Item__c> getWorkItems() {
        string currentid = ApexPages.currentPage().getParameters().get('id');
        //GET WORK ITEM
        Work_Item__c[] workitem = [SELECT ID,Sprint__c,Story_Points__c FROM Work_Item__c WHERE id = :currentid];
        //GET THE PROJECT ID
        Sprint__c[] sprint = [SELECT Project__c FROM Sprint__c WHERE id = :workitem[0].Sprint__c];
        //LIST WORK ITEMS SAME PROJECT AND STORY POINTS
        List<Work_Item__c> results = [
            SELECT ID,Name, Story_Points__c, Status__c
            FROM Work_Item__c 
            WHERE 
            Sprint__r.Project__c = :sprint[0].Project__c 
            AND Story_Points__c = :workitem[0].Story_Points__c 
            AND ID != :workitem[0].ID
            AND Status__c LIKE :statusselected
        ];
        return results;
    }

    public void setStatus(string s) {
        this.statusselected = s;
    }

    public List<SelectOption> getStatus(){
        List<SelectOption> pickListValuesList= new List<SelectOption>();
         Schema.DescribeFieldResult fieldResult = Work_Item__c.Status__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         pickListValuesList.add(new SelectOption('%%','All'));
         for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(new SelectOption(pickListVal.getLabel(),pickListVal.getLabel()));
         }     
         return pickListValuesList;
    }

    /*
    Observación -> Preferible obtener los datos del propio picklist

    public List<SelectOption> getStatus() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('%%','All'));
        options.add(new SelectOption('Not Started','Not Started'));
        options.add(new SelectOption('In Progress','In Progress'));
        options.add(new SelectOption('Done','Done'));
        return options;
    }
    */
}
