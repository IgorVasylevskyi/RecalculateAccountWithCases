@IsTest
public class TestDataRecalculate {
    
    public static Account addAccountWithRecordType(Date endDate) {
        
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Support Customer'];
        Account acc = new Account(Name = 'Test Recalculate ' + Datetime.now().time(),
                                    End_Of_Contract__c = endDate, RecordType = rt,
                                    Support_Used__c = 0);
        insert acc;
        return acc;
    }
    
    public static List<Case> addCases(Id accId, Integer quantity){
        
        List<Case> cases = new List<Case>();
        
        for (Integer i = 0; i < quantity; i++){
            Case c = new Case(Status = 'New', Origin = 'Phone', AccountId = accId);
            cases.add(c);
        }
        insert cases;
        return cases;
    }
}