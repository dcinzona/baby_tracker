public class ActivityTimeline_Controller {

    @AuraEnabled
    public static List<Baby_Activity__c> getActivityTimeline()
    {
        // Create a return List
        List<Baby_Activity__c> returnList = new List<Baby_Activity__c>();

            // Add Tasks Types
            addFeeds(returnList);
            //addCalls(returnList, recordId);
            //addMeetings(returnList, recordId);
            //addEmails(returnList, recordId);
            // Sort List
            //returnList.sort();


        return returnList;

    }

    @AuraEnabled
    public static void addFeeds(List<Baby_Activity__c> returnList)
    {
        //List<Task> taskList =[select   Id, Type, Owner.Name, Status, Who.Name, Subject, Description, ActivityDate from     Task where    WhatId =:recordId and (Type = 'Other' OR Type = Null) and ActivityDate != null ];
        List<Baby_Activity__c> recs = [SELECT Id,
                Date_Time__c,
                Amount__c,
                Date__c,
                Time__c,
                Hours_Slept__c,
                Sleep_End_Datetime__c,
                Icon__c,
                RecordType.Name,
                Comments__c,
                Owner.Name,
                Baby__r.Name
                FROM Baby_Activity__c
                //WHERE RecordType.DeveloperName = 'Feed'
                WHERE Date_Time__c >= YESTERDAY
                ORDER BY Date_Time__c DESC
            ];
        for(Baby_Activity__c t: recs)
        {
            ActivityTimeline_Model taskItem = new ActivityTimeline_Model();

            taskItem.RecordId = t.Id;
            taskItem.ActivityTimelineType = 'Feed';
            taskItem.Subject = t.RecordType.Name;//t.Subject;
            taskItem.Detail = t.Comments__c;
            taskItem.ActualDate = t.Date_Time__c;
            taskItem.ShortDate = t.Date_Time__c.format();
            taskItem.Recipients = t.Baby__r.Name;
            taskItem.Assigned = t.Owner.Name;
            taskItem.Icon = t.Icon__c;

            returnList.add(t);
        }
    }


}