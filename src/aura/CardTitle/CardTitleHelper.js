/**
 * Created by gtandeciarz on 2019-06-24.
 */
({
    pageRefUpdated: function (cmp) {
        var pageReference = cmp.get('v.pageReference');
        cmp.set('v.containerClass', pageReference == null ? '' : 'cursor');
    }

})