/**
 * Created by gmt on 2019-06-15.
 */

({
    init: function(cmp){
        var action = cmp.get("c.getDefaults");
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                //saving custom setting to attribute
                var defaults = response.getReturnValue();
                cmp.set("v.defaults", defaults);
                console.log(defaults);
                var targetCategory = cmp.get('v.targetCategory');

                switch(targetCategory){
                    case 'sleep':
                        cmp.set('v.targetValue', defaults.Sleep_Target_Hours__c + ' hours');
                        break;
                    case 'food':
                        cmp.set('v.targetValue', defaults.Food_Target_ML__c + ' ml');
                        break;
                    case 'vitaminD':
                        cmp.set('v.targetValue', defaults.Vitamin_D_IU_Target__c + ' IUs');
                        break;
                    default:
                        break;
                }
            }
        });

        $A.enqueueAction(action);
    }
});