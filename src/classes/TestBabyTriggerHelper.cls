/**
 * Created by gmt on 2019-06-14.
 */

@IsTest
private class TestBabyTriggerHelper {
    @IsTest
    static void testOvernightSplit() {
        Baby_Activity__c rec = new  Baby_Activity__c();
        rec.Date_Time__c = Datetime.newInstance(Date.today().year(), Date.today().month(), Date.today().day(), 22, 12, 0);
        rec.Sleep_End_Datetime__c = rec.Date_Time__c.addHours(6);
        rec.RecordTypeId = BabyTriggerHelper.getRecordTypeId('Sleep');
        insert rec;

        Test.startTest();

        List<Baby_Activity__c> babyActivities = [SELECT id, Date_Time__c, Sleep_End_Datetime__c
        FROM Baby_Activity__c
        ORDER BY Date_Time__c ASC];

        Baby_Activity__c first = babyActivities[0];

        System.assertEquals(2, babyActivities.size());

        Baby_Activity__c last = babyActivities[1];

        System.assert( BabyTriggerHelper.isSameDayEST(first.Date_Time__c, last.Date_Time__c) == false);

        Test.stopTest();
    }

    @IsTest
    static void testOvernightSplitNotRequired() {
        Baby_Activity__c rec = new  Baby_Activity__c();
        rec.Date_Time__c = Datetime.newInstance(Date.today().year(), Date.today().month(), Date.today().day(), 22, 12, 0);
        rec.Sleep_End_Datetime__c =  rec.Date_Time__c.addHours(1);
        rec.RecordTypeId = BabyTriggerHelper.getRecordTypeId('Sleep');
        insert rec;

        Test.startTest();
        System.assertEquals(1,  [SELECT Id FROM Baby_Activity__c].size());
        Test.stopTest();
    }

    @IsTest
    static void testAnotherActiveRecordExists() {
        Baby_Activity__c active = new  Baby_Activity__c();
        active.Date_Time__c = Datetime.newInstance(Date.today().year(), Date.today().month(), Date.today().day(), 22, 12, 0);
        //rec.Sleep_End_Datetime__c =  rec.Date_Time__c.addHours(1);
        active.RecordTypeId = BabyTriggerHelper.getRecordTypeId('Sleep');
        insert active;

        Test.startTest();
        Baby_Activity__c rec = new  Baby_Activity__c();
        try{
            rec.Date_Time__c = Datetime.newInstance(Date.today().year(), Date.today().month(), Date.today().day(), 22, 12, 0);
            //rec.Sleep_End_Datetime__c =  rec.Date_Time__c.addHours(1);
            rec.RecordTypeId = BabyTriggerHelper.getRecordTypeId('Sleep');
            insert rec;
        }catch (Exception ex){
            active.Sleep_End_Datetime__c =  active.Date_Time__c.addHours(1);
            update active;

        } finally{
            System.assertEquals(1,  [SELECT Id FROM Baby_Activity__c].size());
            //try inserting again (should pass)
            insert rec;
            System.assertEquals(2,  [SELECT Id FROM Baby_Activity__c].size());
        }
        Test.stopTest();
    }

    @IsTest
    static void testClearingOutEndDateOnSleepRecord() {
        Baby_Activity__c completed = new  Baby_Activity__c();
        completed.Date_Time__c = Datetime.newInstance(Date.today().year(), Date.today().month(), Date.today().day(), 22, 12, 0);
        completed.Sleep_End_Datetime__c =  completed.Date_Time__c.addHours(1);
        completed.RecordTypeId = BabyTriggerHelper.getRecordTypeId('Sleep');
        insert completed;
        Baby_Activity__c active = new  Baby_Activity__c();
        active.Date_Time__c = Datetime.newInstance(Date.today().year(), Date.today().month(), Date.today().day(), 22, 12, 0);
        active.RecordTypeId = BabyTriggerHelper.getRecordTypeId('Sleep');
        insert active;

        Test.startTest();
        try{
            completed.Sleep_End_Datetime__c = null;
            update completed;
            System.assert(false, 'You should not be able to clear out the end date of a record if another active record already exists');
        }catch (Exception ex){
            System.assertEquals(1,  [SELECT Id FROM Baby_Activity__c WHERE Sleep_End_Datetime__c = null].size());
            System.assertEquals(2,  [SELECT Id FROM Baby_Activity__c].size());
        }
        Test.stopTest();
    }
}