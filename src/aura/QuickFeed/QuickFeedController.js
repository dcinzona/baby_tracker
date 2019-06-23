/**
 * Created by gmt on 6/14/2019.
 */

({
    quickFeed : function( cmp, event, helper ) {
        var actionAPI = cmp.find("quickActionAPI");
        var args = { actionName: "Log_Baby_Feed" };
       actionAPI.invokeAction(args);
    }
})