/**
 * Created by gmt on 2019-06-14.
 */

public with sharing class BabyTriggerHelper {

    public static boolean singlerun = false;

    public static void processOvernightSleepRecords(List<Baby_Activity__c> records){
        if(!singlerun){
            singlerun = true;

            List<Baby_Activity__c> sleepActivities = new List<Baby_Activity__c>();
            Id sleepRecTypeId = BabyTriggerHelper.getRecordTypeId('Sleep');

            for(Baby_Activity__c rec : records){
                if(rec.RecordTypeId == sleepRecTypeId){
                    sleepActivities.add(rec);
                }
            }

            System.debug(sleepActivities);

            List<Baby_Activity__c> overnightRecordsToInsert = new List<Baby_Activity__c>();

            for(Baby_Activity__c rec : sleepActivities){
                if(rec.Sleep_End_Datetime__c != null && rec.Sleep_End_Datetime__c > rec.Date_Time__c){
                    //check if start and end dates are different
                    if(!isSameDayEST(rec.Date_Time__c, rec.Sleep_End_Datetime__c)){
                        //update the end date time of the original record and create a new sleep record for the new day
                        Integer year = rec.Sleep_End_Datetime__c.year();
                        Integer month = rec.Sleep_End_Datetime__c.month();
                        Integer day = rec.Sleep_End_Datetime__c.dayGmt();
                        Datetime startOfNextDay = DateTime.newInstance(year, month, day, 0,0,0);

                        //create a new record for the next day
                        Baby_Activity__c newRec = new Baby_Activity__c();
                        newRec.RecordTypeId = rec.RecordTypeId;
                        newRec.Date_Time__c = startOfNextDay;
                        newRec.Sleep_End_Datetime__c = rec.Sleep_End_Datetime__c;
                        //add to list to insert
                        overnightRecordsToInsert.add(newRec);

                        //set the end date/time of the original to the end of the first day
                        rec.Sleep_End_Datetime__c =  startOfNextDay.addSeconds(-1);
                    }
                }
            }

            insert overnightRecordsToInsert;
        }
    }

    public static boolean isSameDayEST(Datetime a, Datetime b){
        return a.dayOfYear() == b.dayOfYear();
    }

    public static Id getRecordTypeId(String recordTypeDeveloperName){
        Id recordTypeId = Schema.SObjectType.Baby_Activity__c.getRecordTypeInfosByDeveloperName()
                .get(recordTypeDeveloperName).getRecordTypeId();
        return recordTypeId;
    }
}