/**
 * Created by gmt on 2019-06-14.
 */

({
    init: function(cmp){
        cmp.set('v.loading', true);
        var today = $A.localizationService.formatDate(new Date(), "MMMM dd, yyyy");
        cmp.set('v.today', today);
        var action = cmp.get("c.getTotalSleepToday");
        //action.setStorable();
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.HoursSleptToday", response.getReturnValue());
                var pageReference = {
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'Baby_Activity__c',
                        actionName: 'list'
                    },
                    state: {
                        filterName: "Sleeps_Today"
                    }
                };
                cmp.set('v.pageReference', pageReference);
            }

            cmp.set('v.loading', false);
        });
        $A.enqueueAction(action);
    }
});