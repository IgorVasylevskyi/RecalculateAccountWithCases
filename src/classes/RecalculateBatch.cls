public with sharing class RecalculateBatch implements Database.Batchable<SObject>{//Why Account is not allowed this?

    public Database.QueryLocator start(Database.BatchableContext bc) {
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Support Customer'];
        Id rtId = rt.Id;
        Date today = Date.today();
        
        String query = 'SELECT Id, Name FROM Account WHERE RecordTypeId = :rtId ' +
                        'AND End_Of_Contract__c <= :today';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts){
        
        //List<Id> accIds = new List<Id>();
        Map<Id, List<Case>> accountsCasesByIds = new Map<Id, List<Case>>();
        
        for (Account acc : accounts){
            //accIds.add(acc.Id);
            accountsCasesByIds.put(acc.Id, new List<Case>());
        }
        
        List<Case> cases = [SELECT Id, AccountId FROM Case                      //Only 250 cases per account?
                            WHERE AccountId IN :accountsCasesByIds.keySet()];   //Or we can decrease quantity of records in a batch
                                                                                //Should we use batch in batch?
        for (Case c : cases){
            if (!accountsCasesByIds.containsKey(c.AccountId)){          //Maybe always unused
                accountsCasesByIds.put(c.AccountId, new List<Case>());
                accountsCasesByIds.get(c.AccountId).add(c);
            }else {
                accountsCasesByIds.get(c.AccountId).add(c);             // Only 'else' can be always used
            }
        }
        for (Account acc : accounts){
            acc.Support_Used__c = accountsCasesByIds.get(acc.Id).size();
        }
        update accounts;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch finished: ' + System.now());
    }
    
}