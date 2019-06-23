/**
 * Created by gmt on 2019-06-14.
 */

({
    init: function(cmp){
        var today = $A.localizationService.formatDate(new Date(), "MMMM dd, yyyy");
        cmp.set('v.today', today);
        var action = cmp.get("c.getTotalFoodMLToday");
        //action.setStorable();
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var ml = parseInt(response.getReturnValue());
                cmp.set("v.totalML", ml);
                cmp.set("v.totalOZ", (ml/30).toFixed(2));
                var pageReference = {
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'Baby_Activity__c',
                        actionName: 'list'
                    },
                    state: {
                        filterName: "Feeds_Today"
                    }
                };
                cmp.set('v.pageReference', pageReference);
            }

        });
        $A.enqueueAction(action);

    }
});