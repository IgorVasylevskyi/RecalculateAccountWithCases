public with sharing class RecalculateBatch implements Database.Batchable<SObject>{

    public Database.QueryLocator start(Database.BatchableContext bc) {
        /*Id supportCustomerRecTypeId = Schema.SObjectType.Case
                .getRecordTypeInfosByName()
                .get('Support Customer')
                .getRecordTypeId();*/
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Support Customer'];
        Id rtId = rt.Id;
        Date today = Date.today();
        
        String query = 'SELECT Id, Name FROM Account WHERE RecordTypeId = :rtId ' +
                        'AND End_Of_Contract__c <= :today';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts){
        
        RecalculateBatchHelper.updateAccountField(accounts);
        
        /*Map<Id, List<Case>> accountsCasesByIds = new Map<Id, List<Case>>();
        
        for (Account acc : accounts){
            accountsCasesByIds.put(acc.Id, new List<Case>());
        }
        
        List<Case> cases = [SELECT Id, AccountId FROM Case
                            WHERE AccountId IN :accountsCasesByIds.keySet()];
                            
        for (Case c : cases){
                accountsCasesByIds.get(c.AccountId).add(c);
        }
        for (Account acc : accounts){
            acc.Support_Used__c = accountsCasesByIds.get(acc.Id).size();
        }
        update accounts;*/
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch finished: ' + System.now());
    }
    
}