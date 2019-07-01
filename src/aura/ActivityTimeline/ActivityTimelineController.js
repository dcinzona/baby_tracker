/**
 * Created by gmt on 6/24/2019.
 */

({
    init : function(component, event, helper) {
        let selected = localStorage.getItem('selectedType');
        if(selected){
            component.set('v.selectedType', selected);
        }
        helper.getItems(component);
    },
    getActivityItems:function (component,event,helper) {
        component.set('v.selectedType', 'Activities');
        localStorage.setItem('selectedType', 'Activities');
        helper.getItems(component);
    },
    getMilestones:function (component,event,helper) {
        component.set('v.selectedType', 'Milestones');
        localStorage.setItem('selectedType', 'Milestones');
        helper.getItems(component);
    }
});