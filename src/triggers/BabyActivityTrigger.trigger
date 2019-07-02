trigger BabyActivityTrigger on Baby_Activity__c (before insert, before update) {

    //check for end time that is a different day than start time
    if(trigger.isBefore){
        BabyTriggerHelper.checkForActiveSleepRecordsBeforeInsert(trigger.new);
        if(BabyTriggerHelper.singlerun == false){
            BabyTriggerHelper.processOvernightSleepRecords(Trigger.new);
        }
    }

}