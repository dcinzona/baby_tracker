/**
 * Created by gmt on 2019-06-27.
 */

({
    getLastPlayRecord : function (component) {
        component.set('v.loading', true);
        //get last record
        let action = component.get("c.getLastPlay");
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                let record = response.getReturnValue();
                component.set("v.record", record);
                this.getMinutes(component);
                component.set('v.loadingData', false);
            }
            else{
                console.log(state);
                component.set('v.loadingData', false);
            }
        });
        $A.enqueueAction(action);
    },

    getMinutes:function (component) {
        let record = component.get('v.record');
        if(record){
            let diff = new Date(record.Sleep_End_Datetime__c) - new Date(record.Date_Time__c);
            let minutes = Math.floor((diff/1000)/60);
            component.set('v.totalMinutes', minutes);
        }
    }
});