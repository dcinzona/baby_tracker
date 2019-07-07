/**
 * Created by gmt on 2019-07-02.
 */

({
    init:function (cmp, event, helper) {
        console.log('activityActive init');
        helper.startTiming(cmp);
    },
    startTiming:function(cmp, event, helper){
        console.log('startTiming');
        helper.startTiming(cmp);
    },
    cancel:function (cmp, event, helper) {
        console.log('cancel clicked');
    },
    toggleTummyTime:function(cmp, event, helper){
        var buttonstate = cmp.get('v.record.onTummy');
        cmp.set('v.record.onTummy', !buttonstate);
        let compEvent = cmp.getEvent("updateRecord");
        compEvent.setParams({record: JSON.stringify(cmp.get('v.record'))});
        compEvent.fire();
    }
});