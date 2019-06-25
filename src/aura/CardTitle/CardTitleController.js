/**
 * Created by gmt on 2019-06-15.
 */

({
    init:function(cmp, event, helper){
        helper.pageRefUpdated(cmp);
    },

    handleClick:function(cmp,event){
        var navService = cmp.find("navService");
        var pageReference = cmp.get('v.pageReference');
        if(pageReference != null){
            navService.navigate(pageReference);
        }
    }
});