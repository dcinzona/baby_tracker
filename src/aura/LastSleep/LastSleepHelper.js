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
    }
});