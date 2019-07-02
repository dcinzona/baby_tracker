/**
 * Created by gmt on 2019-06-15.
 */

({
    getLastSleep: function(cmp){
        cmp.set("v.loading", true);

        var action = cmp.get("c.getLastSleep");

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
                    cmp.set("v.loading", false);
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

        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var record = response.getReturnValue();
                cmp.set("v.record", record);
                cmp.set("v.loading", false);
            }
        });
        $A.enqueueAction(action);
    },

    durationInterval: null,
    getSleepingSinceText:function(cmp){
        var rec = cmp.get('v.currentRecord');
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

            // what's left is seconds
            var seconds = Math.round(delta % 60);

            var data = {days : days, hours : hours , minutes : minutes, seconds: seconds};

            cmp.set('v.sleepingSince', data);
        }
        this.durationInterval =  setTimeout($A.getCallback(() => this.getSleepingSinceText(cmp)), 1000);
    },

    endSleep:function(component){
        if(this.durationInterval){
            window.clearTimeout(this.durationInterval);
        }
        let recId = component.get('v.currentRecord.Id');
        this.saveRecord(component, recId, new Date());
    },

    startSleep:function(component){
        if(component.get("v.currentlySleeping") == false){
            if(this.durationInterval){
                window.clearTimeout(this.durationInterval);
            }
            component.set('v.saving', true);

            let action = component.get("c.startNewSleepRecord");
            action.setParam('startDate', new Date());
            action.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS") {
                    this.resetComponent(component);
                } else if(state = "ERROR"){
                    this.toast('Error', 'error',response.getError()[0]);
                }
                component.set('v.saving', false);
            });
            $A.enqueueAction(action);
        }
        else{
            //throw toast
            this.toast('Error', 'error','A sleep record is already in progress');
        }

    },

    saveRecord:function(component, recId, endDate){

        component.set('v.saving', true);
        if(recId){
            let action = component.get("c.updateSleepRecord");
            action.setParam('recordId', recId);
            action.setParam('endDate', endDate);
            action.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS") {
                    component.set('v.saving', false);
                    this.resetComponent(component);
                }
                else{
                    component.set('v.saving', false);
                    console.log(state);
                }
            });
            $A.enqueueAction(action);
        }
        else{
            component.set('v.saving', false);
            console.log(component.get('v.record'));
        }
    },
    resetComponent:function (cmp) {

        cmp.set("v.record", null);
        cmp.set("v.currentRecord", null);
        cmp.set('v.sleepingSince', null);
        cmp.set('v.pageReference', null);
        cmp.set("v.currentlySleeping", false);
        cmp.set('v.saving', false);
        cmp.set('v.loading', false);
        this.getLastSleep(cmp);

    },
    toast:function(title,type, message){

        let toastParams = {
            title: title,
            message: message, // Default error message
            type: type
        };
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    }
});