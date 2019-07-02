/**
 * Created by gmt on 6/13/2019.
 */

({
    init: function(cmp){
        cmp.set("v.loading", true);
        var action = cmp.get("c.getLastFeed");
        //action.setStorable();
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.lastFeed", response.getReturnValue());

                var pageReference = {
                    "type": "standard__recordPage",
                    "attributes": {
                        "recordId": cmp.get('v.lastFeed.Id'),
                        "objectApiName": "Baby_Activity__c",
                        "actionName": "view"
                    }
                };

                cmp.set('v.pageReference', pageReference);
                cmp.set("v.loading", false);
            }
        });
        $A.enqueueAction(action);
    }

});