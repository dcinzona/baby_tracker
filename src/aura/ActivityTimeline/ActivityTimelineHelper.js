/**
 * Created by gmt on 2019-07-01.
 */

({
    getItems:function(component){
        component.set("v.loading", true);
        let selected = component.get('v.selectedType');
        let action;
        switch (selected) {
            case 'Milestones':
                action = component.get("c.getAchievements");
                break;
            default:
                action = component.get("c.getActivityTimeline");
                break;

        }
        this.callService(component,action);
    },
    callService:function(component, action){
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                console.log(ret);
                component.set("v.timeLineItems", ret);
                component.set("v.loading", false);
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
                component.set("v.loading", false);
            }
        });
        // queue action on the server
        $A.enqueueAction(action);
    }

});