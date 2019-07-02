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

    handleChange: function (component, event, helper) {
        let changeValue = event.getParam("value");
        localStorage.setItem('selectedType', changeValue);
        //component.set('v.selectedType', changeValue);
        helper.getItems(component);
    }
});