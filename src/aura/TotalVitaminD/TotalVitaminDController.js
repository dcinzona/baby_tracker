/**
 * Created by gmt on 6/13/2019.
 */

({

    init: function(cmp){
        cmp.set('v.loading', true);
        var action = cmp.get("c.getTotalVitaminDToday");
        //action.setStorable();
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.VitaminDToday", response.getReturnValue());
                var setStyle = cmp.get('c.setStyle');
                $A.enqueueAction(setStyle);

            }
            cmp.set('v.loading', false);
        });
        $A.enqueueAction(action);
    },

    setStyle: function(cmp){
        var total = parseInt( cmp.get('v.VitaminDToday') );
        switch (true) {
            case (total < 350) :
                cmp.set('v.style','warning');
                break;
            case (total >= 350 && total <= 450):
                cmp.set('v.style','good');
                break;
            case (total > 450):
                cmp.set('v.style','bad');
                break;
            default:
                break;

        }

    }

});