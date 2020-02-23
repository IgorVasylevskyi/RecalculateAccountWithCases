public with sharing class RecalculateAccount implements Schedulable{
    
    public static String CRON_EXP = '0 0 0 ? * *';
    
    public static String scheduleIt() {
        RecalculateAccount recalc = new RecalculateAccount();
        return System.schedule('Daily recalculation', CRON_EXP, recalc);
        //return System.schedule('Daily recalculation', '0 02 * ? * * *', recalc);
    }
    
    public void execute(SchedulableContext sc) {
        /*Id supportCustomerRecTypeId = Schema.SObjectType.Case
                .getRecordTypeInfosByName()
                .get('Support Customer')
                .getRecordTypeId();*/
    
        List<Account>  accountsToUpd = new List<Account>();
        
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Support Customer'];
    
        List<Account> accs = [SELECT Id, Name FROM Account WHERE RecordTypeId = :rt.Id
                                AND End_Of_Contract__c <= :Date.today()];
        
        List<Case> cases = [SELECT Id, AccountId FROM Case WHERE Account.End_Of_Contract__c <= :Date.today()];
        
        Map<Id, List<Case>> accountCases = new Map<Id, List<Case>>();
        
        for (Case c : cases){// Is it better instead list cases use soql expresion?
            if(!accountCases.containsKey(c.AccountId)){
                accountCases.put(c.AccountId, new List<Case>());
                accountCases.get(c.AccountId).add(c);
            }else{
                accountCases.get(c.AccountId).add(c);
            }
        }
        for(Account acc : accs){//Is it better instead list accs use soql expresion?
            acc.Support_Used__c = accountCases.get(acc.Id).size();
            accountsToUpd.add(acc);
        }
        update accountsToUpd;
        
        System.debug(System.now());
    }
}