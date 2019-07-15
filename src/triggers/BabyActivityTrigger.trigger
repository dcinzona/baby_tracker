trigger BabyActivityTrigger on Baby_Activity__c (before insert, before update) {

    //check for end time that is a different day than start time
    if(trigger.isBefore){
        BabyTriggerHelper.checkForActiveSleepRecordsBeforeInsert(Trigger.new);
        if(BabyTriggerHelper.singlerun == false){
            BabyTriggerHelper.processOvernightSleepRecords(Trigger.new);
        }
        if(trigger.isUpdate){
            //BabyTriggerHelper.processPlayRecords(Trigger.oldMap, Trigger.newMap);
        }
    }

}