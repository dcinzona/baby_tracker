public class ActivityTimeline_Controller {

    @AuraEnabled
    public static List<ActivityTimeline_Model> getActivityTimeline()
    {
        // Create a return List
        List<ActivityTimeline_Model> returnList = new List<ActivityTimeline_Model>();

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
    public static void addFeeds(List<ActivityTimeline_Model> returnList)
    {
        //List<Task> taskList =[select   Id, Type, Owner.Name, Status, Who.Name, Subject, Description, ActivityDate from     Task where    WhatId =:recordId and (Type = 'Other' OR Type = Null) and ActivityDate != null ];
        LIST<Baby_Activity__c> recs = [SELECT Id,
                Date_Time__c,
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

            returnList.add(taskItem);
        }
    }


}