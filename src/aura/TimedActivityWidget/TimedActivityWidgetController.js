/**
 * Created by gmt on 2019-07-02.
 */

({
    init:function(cmp, event, helper){
        helper.resetComponent(cmp);
        helper.loadData(cmp);
    },
    startTracking: function (cmp, event, helper) {
        helper.startTracking(cmp);
    },
    endTracking: function (cmp, event, helper) {
        helper.endTracking(cmp);
    },
    updateRecord: function (cmp, event, helper) {
        console.log(event.getParam("record"));
        console.log(JSON.stringify(cmp.get('v.recordData')));
        helper.saveRecord(cmp, false);
    }
});