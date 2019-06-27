/**
 * Created by gmt on 2019-06-15.
 */

({
    getLastSleep: function(cmp){
        var action = cmp.get("c.getLastSleep");
        //action.setStorable();
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var record = response.getReturnValue();
                var linkId = record.Id;
                if(record.Sleep_End_Datetime__c == null){
                    cmp.set("v.currentRecord", record);
                    this.getSleepingSinceText(cmp);
                    this.getLastCompletedSleep(cmp);
                    cmp.set("v.currentlySleeping", true);
                } else{
                    cmp.set("v.record", record);
                    cmp.set("v.currentlySleeping", false);
                }

                var pageReference = {
                    "type": "standard__recordPage",
                    "attributes": {
                        "recordId": linkId,
                        "objectApiName": "Baby_Activity__c",
                        "actionName": "view"
                    }
                };

                cmp.set('v.pageReference', pageReference);
            }
        });
        $A.enqueueAction(action);
    },
    getLastCompletedSleep:function(cmp){
        var action = cmp.get("c.getLastCompletedSleep");
        //action.setStorable();
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var record = response.getReturnValue();
                cmp.set("v.record", record);
            }
        });
        $A.enqueueAction(action);
    },
    getSleepingSinceText:function(cmp){
        var rec = cmp.get('v.currentRecord');
        var timer = setInterval(function() {
            if(rec != undefined){
                var now = new Date();
                var fellAsleep = new Date(rec.Date_Time__c);

                // get total seconds between the times
                var delta = Math.abs(now - fellAsleep) / 1000;

                // calculate (and subtract) whole days
                var days = Math.floor(delta / 86400);
                delta -= days * 86400;

                // calculate (and subtract) whole hours
                var hours = Math.floor(delta / 3600) % 24;
                delta -= hours * 3600;

                // calculate (and subtract) whole minutes
                var minutes = Math.floor(delta / 60) % 60;
                delta -= minutes * 60;

                var data = {days : days, hours : hours , minutes : minutes};//"Asleep for: " + hours + " hours, " + minutes + " minutes"
                cmp.set('v.sleepingSince', data);
                //console.log(data);

            }
        },1000);
    }
});