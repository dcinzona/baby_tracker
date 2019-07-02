/**
 * Created by gmt on 2019-06-14.
 */

({
    init:function(cmp, event, helper){
        helper.getLastSleep(cmp);
    },
    endSleep:function (cmp, event, helper) {
        helper.endSleep(cmp);
    },
    startSleep:function (cmp, event, helper) {
        helper.startSleep(cmp);
    }
});