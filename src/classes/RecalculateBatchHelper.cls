public with sharing class RecalculateBatchHelper {
    
    public static void updateAccountField(List<SObject> items){
        
        Map<Id, List<Case>> accountsCasesByIds = new Map<Id, List<Case>>();
    
        for (Account acc : (List<Account>)items){
            accountsCasesByIds.put(acc.Id, new List<Case>());
        }
    
        List<Case> cases = [SELECT Id, AccountId FROM Case
        WHERE AccountId IN :accountsCasesByIds.keySet()];
    
        for (Case c : cases){
            accountsCasesByIds.get(c.AccountId).add(c);
        }
        for (Account acc : (List<Account>)items){
            acc.Support_Used__c = accountsCasesByIds.get(acc.Id).size();
        }
        update items;
    }
}