/**
 * Created by gmt on 2019-06-18.
 */


({

    init: function(cmp){
        var action = cmp.get("c.getAverageSleepPerDay");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var payload = response.getReturnValue();
                var ml = payload.AverageAmountPerDay;
                console.log(payload);
                cmp.set("v.total", ml);
                cmp.set("v.numberOfDays", payload.AverageDays);
                var pageReference = {
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'Baby_Activity__c',
                        actionName: 'list'
                    },
                    state: {
                        filterName: "All"
                    }
                };
                cmp.set('v.pageReference', pageReference);
            }

        });
        $A.enqueueAction(action);

    }

});