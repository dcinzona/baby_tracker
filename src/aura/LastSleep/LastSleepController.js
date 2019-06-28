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
    resume:function (cmp, event, helper) {
        helper.resumeSleep(cmp);
    }
});