/**
 * Created by gmt on 2019-06-19.
 */

({
    init: function(cmp){
        var action = cmp.get("c.getLastHeal");
        //action.setStorable();
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.record", response.getReturnValue());

                var pageReference = {
                    "type": "standard__recordPage",
                    "attributes": {
                        "recordId": cmp.get('v.record.Id'),
                        "objectApiName": "Baby_Activity__c",
                        "actionName": "view"
                    }
                };

                cmp.set('v.pageReference', pageReference);
            }
        });
        $A.enqueueAction(action);
    }

});