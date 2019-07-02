/**
 * Created by gmt on 2019-06-27.
 */

public with sharing class AuraDataWriter {

    @AuraEnabled
    public static Baby_Activity__c savePlayRecord(Datetime startTime, Datetime endTime, String comments, Id recordId){
        Baby_Activity__c record = new Baby_Activity__c();
        record.Date_Time__c = startTime;
        record.RecordTypeId = getRecordTypeIdForName('Play');
        record.Sleep_End_Datetime__c = endTime;
        record.Comments__c = comments;
        if(recordId != null){
            record.Id = recordId;
        }
        upsert record;
        record = [SELECT Id, Name, Date_Time__c, RecordTypeId, Sleep_End_Datetime__c, Comments__c, Icon__c FROM Baby_Activity__c WHERE Id =: record.Id LIMIT 1];
        return record;
    }

    @AuraEnabled
    public static void updateSleepRecord(Id recordId, Datetime endDate){
        if(recordId != null){
            Baby_Activity__c rec = new Baby_Activity__c(Id = recordId, Sleep_End_Datetime__c = endDate);
            System.debug(rec);
            update rec;
        } else {
            throw new saveException('No record ID was provided');
        }
    }

    @AuraEnabled
    public static void startNewSleepRecord(Datetime startTime){

        List<Id> active = BabyTriggerHelper.getActiveSleepIds();
        if(active.size() > 0){
            throw new saveException('An active sleep record already exists: ' + String.join(active,','));
        }

        if(startTime == null){
            startTime = System.now();
        }
        Baby_Activity__c rec = new Baby_Activity__c(Date_Time__c = startTime, RecordTypeId =getRecordTypeIdForName('Sleep'));

        insert rec;
    }

    @AuraEnabled
    public static void deleteRecord(Id recordId){
        if(recordId == null){
            throw new deleteException('No record ID was provided');
        }
        delete [SELECT Id FROM Baby_Activity__c WHERE Id =: recordId LIMIT 1];
    }


    @AuraEnabled(Cacheable=true)
    public static Id getRecordTypeIdForName(String devName){
        return getMapOfRecordTypes().get(devName.toLowerCase());
    }


    @AuraEnabled(Cacheable=true)
    public static Map<String, Id> getMapOfRecordTypes(){

        Map<String, Id> rtMap = new Map<String, Id>();
        Schema.SObjectType  objType = Baby_Activity__c.SObjectType;
        for(RecordTypeInfo rt : objType.getDescribe().getRecordTypeInfos()){
            rtMap.put(rt.getDeveloperName().toLowerCase(),rt.getRecordTypeId());
        }
        return rtMap;
    }

    public class deleteException extends Exception{

    }
    public class saveException extends Exception{

    }
}