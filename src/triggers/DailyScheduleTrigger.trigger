trigger DailyScheduleTrigger on Daily_Schedule__c (before insert, after insert, before update, after update) {



    if(trigger.isBefore){

        //check name is a date
        for(Daily_Schedule__c rec : Trigger.new){
            Datetime sched = datetime.newInstance(rec.Scheduled_Date__c.year(), rec.Scheduled_Date__c.month(), rec.Scheduled_Date__c.day());
            rec.Name = sched.format('MMMM dd, yyyy');
        }

    }

    if(trigger.isAfter){
        Map<Id, Daily_Schedule__c> schedules = Trigger.newMap;

    }

}