/**
 * Created by gmt on 2019-06-15.
 */

({
    init:function(cmp){
        var pageReference = cmp.get('v.pageReference');
        console.log(pageReference);
        cmp.set('v.containerClass', pageReference == null ? '' : 'cursor');
    },
    handleClick:function(cmp,event){
        var navService = cmp.find("navService");
        var pageReference = cmp.get('v.pageReference');
        if(pageReference != null){
            navService.navigate(pageReference);
        }
    }
});