/*public with sharing class RecalculateBatch implements Database.Batchable{

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return null;
    }

    public void execute(Database.BatchableContext bc, List<Object> param2) {

    }

    public void finish(Database.BatchableContext param1) {
        System.debug('Batch finished: ' + System.now());
    }
}*/
public with sharing class RecalculateBatch{}