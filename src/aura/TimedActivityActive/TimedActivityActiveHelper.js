/**
 * Created by gmt on 2019-07-02.
 */

({
    durationInterval: null,

    startTiming: function(component){
        this.calculateTime(component);
    },

    calculateTime: function(component){
        let record = component.get('v.record');
        if(record){
            var now = new Date();
            var start = new Date(record.startDate);

            // get total seconds between the times
            var delta = Math.abs(now - start) / 1000;

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
            component.set('v.duration', data);

            this.durationInterval =  setTimeout($A.getCallback(() => this.calculateTime(component)), 1000);
        }
    }
});