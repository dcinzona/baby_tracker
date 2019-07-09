public with sharing virtual class TimedActivityController {

    private static Boolean loadTestRecords = false;

    @AuraEnabled
    public static List<Baby_Activity__c> getLastTimedActivity(String recordTypeName, Boolean testing){
        loadTestRecords = testing;
        return getRecords(null, recordTypeName, 2);

    }

    @AuraEnabled
    public static Baby_Activity__c saveRecord(AuraObject_TimedActivity payload){

        loadTestRecords = payload.testing;

        if(String.isEmpty(payload.recordTypeName + payload.recordId))
        {
            throw new AuraHandledException('recordTypeDevName parameter is required in order to save a new record');
        }

        Baby_Activity__c record = new Baby_Activity__c();


        if(payload.testing != null){
            record.Test_Record__c = payload.testing;
        }

        record.Id = payload.recordId;
        Boolean endingRecord = false;

        Baby_Activity__c prevVersion = payload.recordId != null ? getRecordById(payload.recordId) : null;

        if(String.isEmpty(payload.recordId)){
            record.RecordTypeId = RecordTypeHelper.getRecordTypeIdForName(payload.recordTypeName);
        }

        if(payload.startDate != null){
            record.Date_Time__c = payload.startDate;
        }

        if(payload.comments != null){
            record.Comments__c = payload.comments;
        }

        if(payload.onTummy != null){
            record.On_Tummy__c = payload.onTummy;
            if(payload.onTummy){
                record.On_Tummy_Last_Toggled__c = System.now();
            }
        }

        if(payload.endDate != null){
            record.Sleep_End_Datetime__c = payload.endDate;
            endingRecord = prevVersion != null;
            record.On_Tummy__c = false;
        }

        if(!record.On_Tummy__c && prevVersion != null && prevVersion.On_Tummy__c){
            Long diff = calculateTimeDifference(prevVersion.On_Tummy_Last_Toggled__c, System.now());
            record.Tummy_Time_Milliseconds__c = prevVersion.Tummy_Time_Milliseconds__c += diff;
        }

        try{
            upsert record;
        } catch (Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }

        return getRecordById(record.Id);
    }

    @AuraEnabled
    public static Baby_Activity__c toggleTummyTime(Id recordId, Boolean onTummy){

        Baby_Activity__c record = getRecordById(recordId);

        Boolean previouslyOnTummy = record.On_Tummy__c;
        if(onTummy != previouslyOnTummy){
            //calculate time from now (use last modified date/time or create a new field?
            if(onTummy){
                //turned on to tummy when previously not on tummy
                record.On_Tummy_Last_Toggled__c = System.now();
            }
            else{ //taken off tummy
                Datetime start = record.On_Tummy_Last_Toggled__c == null ? record.Date_Time__c : record.On_Tummy_Last_Toggled__c;
                //now lets calculate how long baby was on tummy
                Long diff = System.now().getTime() - start.getTime();
                record.Tummy_Time_Milliseconds__c += diff;
            }
        }

        update record;
        return record;
    }

    private static Long calculateTimeDifference(Datetime startDate, Datetime endDate){
        return endDate.getTime() - startDate.getTime();
    }

    private static Baby_Activity__c getRecordById(Id recId){
        return getRecords(recId, null, null)[0];
    }
    private static List<Baby_Activity__c> getRecords(Id recId, String recordTypeName, Integer limitNumber){

        if(String.isEmpty(recId + recordTypeName)){
            throw new queryException('You must specify either a record Id OR a record type');
        }
        String recTypeId = '';

        String query = 'SELECT {0} FROM Baby_Activity__c WHERE {1} {2} {3}';

        List<String> fields = new List<String>{
                'Id',
                'Name',
                'Amount__c',
                'Comments__c',
                'Date_Time__c',
                'Hours_Slept__c',
                'Icon__c',
                'On_Tummy__c',
                'On_Tummy_Last_Toggled__c',
                'RecordTypeId',
                'RecordType.DeveloperName',
                'RecordType.Name',
                'Sleep_End_Datetime__c',
                'Tummy_Time__c',
                'Tummy_Time_Milliseconds__c',
                'Test_Record__c'
                };

        List<string> filters = new List<String>();

        if(String.isEmpty(recId)){
            recTypeId = RecordTypeHelper.getRecordTypeIdForName(recordTypeName);
            filters.add(' RecordTypeId =: recTypeId');
        } else{
            filters.add(' Id =: recId');
        }

        filters.add('Test_Record__c =: loadTestRecords ');

        query = String.format(query, new List<String>{
                String.join(fields, ', '),
                String.join(filters, ' AND '),
                'ORDER BY Date_Time__c DESC ',
                'LIMIT ' + (limitNumber == null ? 1 : limitNumber)
        });

        return Database.query(query);
    }

    public class deleteException extends Exception{

    }
    public class saveException extends Exception{

    }
    public class queryException extends Exception{

    }
}