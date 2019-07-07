/**
 * Created by gmt on 2019-07-03.
 */

({
    calculateTime:function(cmp){
        let startDate = component.get('v.startDate');
        let endDate = component.get('v.endDate');
        var start = new Date(startDate);
        var end = endDate ? new Date(endDate) : new Date();

        // get total seconds between the times
        var delta = Math.abs(end - start) / 1000;

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
        component.set('v.returnDataObject', data);
    }

});