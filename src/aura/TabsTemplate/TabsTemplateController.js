/**
 * Created by gmt on 2019-06-30.
 */

({

    selectTab:function(component, event, helper){
        let selected = event.getParam('id');
        console.log(event.getParam('id'));
        component.set('v.selectedTab', selected);
    }
});