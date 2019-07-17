/**
 * Created by gtandeciarz on 2019-07-16.
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
            Map<String, RecordTypeInfo> infosMap = sobjectType.getDescribe().getRecordTypeInfosByDeveloperName();
            Test.startTest();
            rtUtil.forObject(src.SobjectType);
            for(String key : infosMap.keySet()){
                //test that the map contains the correct key
                System.assertEquals(infosMap.get(key), rtUtil.getMap().get(key), key + ' was not in record types Infos Map returned by the utility class');
                //test map contains lowercase variant
                System.assertEquals(infosMap.get(key), rtUtil.getMap().get(key.toLowerCase()), key + ' (lowercase) was not in record types Infos Map returned by the utility class');
                //test map contains upper case variant
                System.assertEquals(infosMap.get(key), rtUtil.getMap().get(key.toUpperCase()), key + ' (uppercase) was not in record type Infos Map returned by the utility class');
                //test map of Ids contains the correct value
                System.assertEquals(infosMap.get(key).getRecordTypeId(), rtUtil.getIdsMap().get(key), key + ' was not in record types Ids Map returned by the utility class');
            }

            Test.stopTest();
        }
    }


    @IsTest
    static void test_withPermissions() {
        RecordTypeUtility rtUtil = new RecordTypeUtility().forObject('Account').withPermissions(true);
        System.assert(rtUtil.enforceSharing, 'Sharing should be enforced');
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
    static void test_throwException() {
        RecordTypeUtility rtUtil = new RecordTypeUtility('ObjectDoesntExist__c');
        Test.startTest();
        try{
            rtUtil.getRecordTypeIdByDeveloperName('test');
            System.assert(false, 'This should have thrown an exception');
        } catch (RecordTypeUtility.RecordTypeUtilityException ex){
            System.assert(true, 'RecordTypeUtilityException was thrown');
        }
        Test.stopTest();
    }
}