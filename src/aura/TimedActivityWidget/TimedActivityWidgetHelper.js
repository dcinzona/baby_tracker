/**
 * Created by gmt on 2019-07-02.
 */

({
    recordData : {
        startDate : null,
        endDate : null,
        recordId : null,
        comments : null,
        onTummy : false,
        testing : false,
        recordTypeName : null
    },

    resetComponent:function (cmp) {
        cmp.set('v.currentRecord', null);
        cmp.set('v.previousRecord', null);
        cmp.set('v.records', null);
        cmp.set('v.isActive', false);
        cmp.set('v.saving', false);
        cmp.set('v.noRecords', false);
        cmp.set('v.loading', true);
    },

    loadData:function (cmp) {
        cmp.set('v.loading', true);
        let rt = cmp.get('v.recordTypeName');
        let action = cmp.get("c.getLastTimedActivity");
        action.setParam('recordTypeName',rt);
        action.setParam('testing',cmp.get('v.testing'));
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                let records = response.getReturnValue();
                cmp.set('v.records', records);
                switch (records.length) {
                    case 0:
                        cmp.set('v.noRecords', true);
                        break;
                    case 1:
                        cmp.set('v.currentRecord', records[0]);
                        break;
                    case 2:
                        cmp.set('v.currentRecord', records[0]);
                        cmp.set('v.previousRecord', records[1]);
                        break;
                }
                if(records.length > 0){
                    this.processRecords(cmp);
                } else {
                    cmp.set('v.noRecords', true);
                    cmp.set('v.loading', false);
                }

            }
            if (state === 'ERROR'){
                cmp.set('v.noRecords', true);
                cmp.set('v.loading', false);
                this.toast('Error','error', response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    processRecords:function(cmp){
        cmp.set('v.noRecords', false);
        cmp.set('v.loading', false);
        let currentRecord = cmp.get('v.currentRecord');
        cmp.set('v.isActive', currentRecord.Sleep_End_Datetime__c == null);
        cmp.set('v.testing', currentRecord.Test_Record__c);
        this.setRecordData(cmp, currentRecord);

        var pageReference = {
            "type": "standard__recordPage",
            "attributes": {
                "recordId": cmp.get('v.currentRecord.Id'),
                "objectApiName": "Baby_Activity__c",
                "actionName": "view"
            }
        };
        cmp.set('v.pageReference',pageReference);
    },

    startTracking: function(cmp){
        cmp.set('v.currentRecord', null);
        cmp.set('v.saving', true);

        this.recordData = {};
        this.recordData.startDate = new Date();
        this.recordData.endDate = null;
        this.recordData.recordId = null;
        this.recordData.comments = cmp.get('v.recordTypeName') == 'Play' ? 'Tummy Time' : '';
        this.recordData.onTummy = true;
        this.recordData.testing = cmp.get('v.testing');
        this.recordData.recordTypeName = cmp.get('v.recordTypeName');

        this.saveRecord(cmp, true);
    },

    endTracking: function(cmp){
        cmp.set('v.saving', true);
        this.recordData = cmp.get('v.recordData');
        this.recordData.endDate = new Date();
        this.saveRecord(cmp, true);
    },

    saveRecord:function(cmp, reload){

        cmp.set('v.saving', true);
        let action = cmp.get("c.saveRecord");

        action.setParam('payload', this.recordData);

        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.saving', false);
                cmp.set('v.currentRecord', response.getReturnValue());
                if(reload){
                    this.resetComponent(cmp);
                    this.loadData(cmp);
                }
            }
            else if(state == 'ERROR') {
                cmp.set('v.saving', false);
                this.resetComponent(cmp);
                this.loadData(cmp);
                this.toast('Error','error', response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    setRecordData:function(cmp,record){
        let params = {
            startDate : record.Date_Time__c,
            endDate : record.Sleep_End_Datetime__c,
            recordId : record.Id,
            comments : record.Comments__c,
            onTummy : record.On_Tummy__c,
            testing : record.Test_Record__c,
            recordTypeName : cmp.get('v.recordTypeName')
        }
        this.recordData = params;
        cmp.set('v.recordData', this.recordData);
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
    /*
    action.setParam('startTime',component.get('v.startTime'));
    action.setParam('endTime',component.get('v.endTime'));
    action.setParam('comments',component.get('v.comments'));
    */
});