/**
 * Created by gmt on 2019-06-27.
 */

({
    init:function(cmp, event, helper){
        helper.setResetTimeOnUI(cmp);

        var pageReference = {
            "type": "standard__recordPage",
            "attributes": {
                "recordId": cmp.get('v.record.Id'),
                "objectApiName": "Baby_Activity__c",
                "actionName": "view"
            }
        };
        cmp.set('v.pageReference',pageReference);
    },

    startPlay: function (cmp, event, helper) {
        helper.setStartTimeOnUI(cmp);
    },
    endAndSave:function(cmp, event, helper){
        helper.endAndSaveRecord(cmp);
    },
    cancel:function(cmp, event, helper){
        helper.deleteRecord(cmp);
    }
});