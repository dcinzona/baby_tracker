/**
 * Created by gmt on 6/24/2019.
 */

({
    init : function(component, event, helper) {
        //Get data from controller
        console.log('init...')
        var action = component.get("c.getActivityTimeline");

        /*
        //set method paramaters
        action.setParams({
            "recordId" : '0034P00002Tv9HHQAZ'
        });

         */

        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                console.log(ret);
                component.set("v.timeLineItems", ret);
            } else if(state = "ERROR"){
                let errorMsg = response.getError()[0];
                let toastParams = {
                    title: "Error",
                    message: errorMsg, // Default error message
                    type: "error"
                };
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams(toastParams);
                toastEvent.fire();
            }
        });

        // queue action on the server
        $A.enqueueAction(action);

    }
});