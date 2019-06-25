/**
 * Created by gtandeciarz on 2019-06-25.
 */
({
    getPageRef:function (cmp) {
        var pageReference = {
            "type": "standard__recordPage",
            "attributes": {
                "recordId": cmp.get('v.record.Id'),
                "objectApiName": "Baby_Activity__c",
                "actionName": "view"
            }
        };

        cmp.set('v.pageReference', pageReference);
    }
})