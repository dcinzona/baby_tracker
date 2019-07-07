/**
 * Created by gmt on 2019-07-02.
 */

({
    calculateTime: function(component){
        let record = component.get('v.record');
        if(record){
            var start = new Date(record.Date_Time__c);
            var end = new Date(record.Sleep_End_Datetime__c);
            this.setDuration(component, 'v.duration', start, end );
            if(record.Tummy_Time_Milliseconds__c > 0){
                this.msToTime(component, 'v.durationOnTummy', record.Tummy_Time_Milliseconds__c );
            }

        }
    },
    setDuration: function (component, out, start, end) {
        // get total seconds between the times
        let delta = Math.abs(end - start);
        this.msToTime(component, out, delta);
    },

    msToTime: function(component, out, deltaMS){
        if(deltaMS){

            let delta = deltaMS / 1000;

            // calculate (and subtract) whole days
            var days = Math.floor(delta / 86400);
            delta -= days * 86400;

            // calculate (and subtract) whole hours
            var hours = Math.floor(delta / 3600) % 24;
            delta -= hours * 3600;

            // calculate (and subtract) whole minutes
            var minutes = Math.floor(delta / 60) % 60;
            delta -= minutes * 60;

            // what's left is seconds
            var seconds = Math.round(delta % 60);

            var data = {days : days, hours : hours , minutes : minutes, seconds: seconds};
            component.set(out, data);
        }
    }
});