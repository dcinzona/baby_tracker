/**
 * Created by gtandeciarz on 2019-07-15.
 */

@IsTest
private class RecordTypeUtility_TEST {
    @IsTest
    static void requireSObjectAPIName() {
        RecordTypeUtility rtUtil = new RecordTypeUtility();
        try{
            rtUtil.getRecordTypeIdByDeveloperName('Test');
            System.assert(false, 'Should have thrown an error');
        } catch(Exception ex){
            System.assert(true);
        }
    }

    @IsTest
    static void test_getRecordTypeIdByDeveloperName() {
        RecordTypeUtility rtUtil = new RecordTypeUtility();
        List<RecordType> rtSOQL = [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType LIMIT 1];
        if(rtSOQL.size() > 0){
            RecordType src = rtSOQL[0];
            Test.startTest();
            rtUtil.forObject(src.SobjectType);
            System.assertEquals(rtUtil.getRecordTypeIdByDeveloperName(src.DeveloperName), src.Id);
            Test.stopTest();
        }
    }

    @IsTest
    static void test_getRecordTypeInfoMap() {
        RecordTypeUtility rtUtil = new RecordTypeUtility();
        List<RecordType> rtSOQL = [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType LIMIT 1];
        if(rtSOQL.size() > 0){
            RecordType src = rtSOQL[0];
            Map<String, Schema.SObjectType> sobjTypeMap = Schema.getGlobalDescribe();
            Schema.SObjectType sobjectType = sobjTypeMap.get(src.SobjectType);
             sobjectType.getDescribe().getRecordTypeInfosByDeveloperName();
            Test.startTest();
            rtUtil.forObject(src.SobjectType);
            System.assertEquals(rtUtil.getRecordTypeIdByDeveloperName(src.DeveloperName), src.Id);
            Test.stopTest();
        }
    }
}