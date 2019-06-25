/**
 * Created by gtandeciarz on 2019-06-24.
 */
({
    init:function(cmp,event,helper){
        helper.getPageRef(cmp);
    },
    getPageReference: function(cmp,event,helper){
        helper.getPageRef(cmp);
    },
    changeState : function changeState (component){
        component.set('v.isexpanded',!component.get('v.isexpanded'));
    }
})