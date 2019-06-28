/**
 * Created by gmt on 2019-06-27.
 */

({

    durationInterval: null,
    recordTypeId: null,

    setStartTimeOnUI:function(component){
        component.set('v.startTime', new Date());
        component.set("v.endTime",null);
        component.set('v.comments','Tummy Time');
        component.set("v.newRecordId", null);
        component.set('v.saving', true);
        this.calculateTime(component);
        this.saveRecord(component);
    },

    calculateTime: function(component){

        component.set("v.playingNow",true);

        var now = new Date();
        var start = component.get('v.startTime');

        // get total seconds between the times
        var delta = Math.abs(now - start) / 1000;

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
        component.set('v.duration', data);

        this.durationInterval =  setTimeout($A.getCallback(() => this.calculateTime(component)), 1000);
    },

    endAndSaveRecord : function(component) {
        component.set("v.playingNow",false);
        component.set("v.endTime",new Date());
        window.clearTimeout(this.durationInterval);
        this.saveRecord(component);
    },

    saveRecord : function(component){
        let action = component.get("c.savePlayRecord");
        action.setParam('startTime',component.get('v.startTime'));
        action.setParam('endTime',component.get('v.endTime'));
        action.setParam('comments',component.get('v.comments'));
        let recId  = component.get('v.newRecordId');
        if(recId){
            console.log(recId);
            action.setParam('recordId', recId);
        }
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                let record = response.getReturnValue();
                component.set("v.record", record);
                component.set("v.newRecordId", record.Id);
                component.set('v.saving', false);
                if(record.Sleep_End_Datetime__c != null){
                    let resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Saved",
                        "message": "The record was saved.",
                        "variant": "success"
                    });
                    resultsToast.fire();
                }
            }
            if (state === 'ERROR'){
                component.set('v.saving', false);
            }
        });
        $A.enqueueAction(action);
    },

    setResetTimeOnUI : function(component) {
        component.set("v.playingNow",false);
        component.set("v.startTime",null);
        component.set("v.endTime",null);
        component.set('v.comments','Tummy Time');
        window.clearTimeout(this.durationInterval);
        this.setUIFromRecord(component);
    },

    setUIFromRecord : function (component) {
        let record = component.get('v.record');
        if(record && record.Sleep_End_Datetime__c == null){
            component.set("v.startTime", new Date(record.Date_Time__c));
            component.set('v.comments',record.Comments__c);
            this.calculateTime(component);
        }
    },

    getRecordTypeId:function(component){

        let action = component.get("c.getRecordTypeIdForName");
        action.setParam('devName','Play');
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                let id = response.getReturnValue();
                this.recordTypeId =  id;
                console.log(this.recordTypeId);
            }
            else{
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    },

    deleteRecord:function (component) {
        component.set('v.saving', true);
        window.clearTimeout(this.durationInterval);
        let recId = component.get('v.record.Id');
        if(recId){
            let action = component.get("c.deleteRecord");
            action.setParam('recordId', recId);
            action.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS") {
                    component.set('v.saving', false);
                    $A.get('e.force:refreshView').fire();
                }
                else{
                    this.setResetTimeOnUI(component);
                    component.set('v.saving', false);
                    console.log(state);
                }
            });
            $A.enqueueAction(action);
        }
        else{
            this.setResetTimeOnUI(component);
            component.set('v.saving', false);
            console.log(component.get('v.record'));
        }
    }


});