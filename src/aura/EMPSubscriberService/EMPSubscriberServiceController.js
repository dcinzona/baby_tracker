({
    doInit : function(component, event, helper) {

        // Get the empApi component.
        var empApi = component.find("empApiBabyActivity");

        // Error handler function that prints the error to the console.
        var errorHandler = function (message) {
            console.log("Received error ", JSON.parse(JSON.stringify(message)));
        }.bind(this);

        // Register error listener and pass in the error handler function.
        empApi.onError(errorHandler);

        // Get the channel from the input box.
        var channel = '/data/';

        var sObjectName = component.get('v.sObjectName');
        if (sObjectName.endsWith('__c')) {
            // Custom object
            channel = channel + sObjectName.substring('0', sObjectName.length-3) + '__ChangeEvent';
        }
        else {
            // Standard object
            channel = channel + sObjectName + 'ChangeEvent';
        }

        var replayId = '-2';//'-1';

        // Callback function to be passed in the subscribe call.
        // After an event is received, this callback prints the event
        // payload to the console.
        var callback = function (message) {

            var modifiedRecords = message.data.payload.ChangeEventHeader.recordIds;
            var commitUser = message.data.payload.ChangeEventHeader.commitUser;
            var currentRecordId = component.get('v.recordId');
            var userId = $A.get("$SObjectType.CurrentUser.Id")
            console.log(JSON.stringify(message));
            /*
            if (modifiedRecords.includes(currentRecordId)
                && commitUser != userId) {

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": "Someone else modified the record you're viewing!",
                    "type": "warning",
                    "mode": "sticky"
                });
                toastEvent.fire();
            }*/
        }.bind(this);


        // Subscribe to the channel and save the returned subscription object.
        empApi.subscribe(channel, replayId, callback).then(function(value) {
            console.log("Subscribed to channel " + channel);
        });
    }
})