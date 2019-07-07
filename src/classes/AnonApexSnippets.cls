/**
 * Created by gmt on 2019-07-06.
 */

public with sharing class AnonApexSnippets {

    private void updatePlaytimeRecordsFromComments(){
        List<Baby_Activity__c> recsToFix = new List<Baby_Activity__c>();

        for(Baby_Activity__c rec : [SELECT id, Comments__c,Tummy_Time__c,Tummy_Time_Milliseconds__c, Date_Time__c, Sleep_End_Datetime__c fROM Baby_Activity__c where RecordType.DeveloperName = 'Play' AND Test_Record__c = false])
        {
            Pattern pat = Pattern.compile('([0-9]+)');
            if(!String.isEmpty(rec.Comments__c)) {
                Matcher matcher = pat.matcher(rec.Comments__c);
                Boolean matches = matcher.find();
                try{
                    if(matches){
                        System.debug(rec.Comments__c);
                        System.debug('result:' + matcher.group(1));
                        Integer minutes = Integer.valueOf(matcher.group(1));
                        Long milliseconds = minutes * 60000;
                        System.debug(milliseconds);
                        rec.Tummy_Time_Milliseconds__c = milliseconds;
                        recsToFix.add(rec);
                    }
                } catch(Exception ex){

                }
            }

        }
        update recsToFix;
    }
    private void deleteTestRecords(){
        delete [select id from Baby_Activity__c where Test_Record__c = true];
    }
}