@IsTest
private class RecalculateAccountTest {
    
    static String CRON_EXP = '0 0 0 1 3 ? 2020';
    static Integer casesQuantity = 10;
    
    @IsTest
    static void testScheduled() {
        
        Test.startTest();
            Account acc = TestDataRecalculate.addAccountWithRecordType(Date.today());
            List<Case> cases = TestDataRecalculate.addCases(acc.Id, casesQuantity);
            RecalculateAccount.scheduleIt();
        Test.stopTest();
        
        Account acc2 = [SELECT Support_Used__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(cases.size(), acc2.Support_Used__c);
    }
    
    @IsTest
    static void testDateMoreThanToday(){
        
        Test.startTest();
            Account acc = TestDataRecalculate.addAccountWithRecordType(Date.today().addDays(1));
            List<Case> cases = TestDataRecalculate.addCases(acc.Id, casesQuantity);
            RecalculateAccount.scheduleIt();
        Test.stopTest();
        
        Account acc2 = [SELECT Support_Used__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, acc2.Support_Used__c);
    }
}