/**
 * Created by gmt on 2019-07-06.
 */

public with sharing class RecordTypeHelper {


    public static Id getRecordTypeIdForName(String devName){
        return getBabyActivityRecordTypeIdMap().get(devName.toLowerCase());
    }

    public static Map<String, Id> getBabyActivityRecordTypeIdMap(){
        Map<String, Id> rtMap = new Map<String, Id>();
        Schema.SObjectType  objType = Baby_Activity__c.SObjectType;
        for(RecordTypeInfo rt : objType.getDescribe().getRecordTypeInfos()){
            rtMap.put(rt.getDeveloperName().toLowerCase(),rt.getRecordTypeId());
        }
        return rtMap;
    }
}