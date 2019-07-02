/**
 * Created by gmt on 6/13/2019.
 */

public with sharing class ApexHelperController {

    @AuraEnabled//(Cacheable=true)
    public static Baby_Activity__c getLastFeed(){

        LIST<Baby_Activity__c> acts = [SELECT Id,
                Date_Time__c,
                Amount_ML__c,
                Amount_OZ__c,
                Vitamin_D_Drops__c,
                Food_Type__c,
                Time__c,
                Icon__c,
                Amount__c
                FROM Baby_Activity__c
                WHERE RecordType.DeveloperName = 'Feed'
                ORDER BY Date_Time__c DESC
                LIMIT 1 ];

        return acts.size() > 0 ? acts[0] : null;

    }

    @AuraEnabled//(Cacheable=true)
    public static Baby_Activity__c getLastSleep(){

        LIST<Baby_Activity__c> acts = [SELECT Id,
                Date_Time__c,
                Sleep_End_Datetime__c,
                Hours_Slept__c,
                Icon__c,
                Amount__c
        FROM Baby_Activity__c
        WHERE RecordType.DeveloperName = 'Sleep'
        ORDER BY Date_Time__c DESC
        LIMIT 1 ];

        return acts.size() > 0 ? acts[0] : null;

    }

    @AuraEnabled//(Cacheable=true)
    public static Baby_Activity__c getLastCompletedSleep(){

        LIST<Baby_Activity__c> acts = [SELECT Id,
                Date_Time__c,
                Sleep_End_Datetime__c,
                Hours_Slept__c,
                Icon__c,
                Amount__c
        FROM Baby_Activity__c
        WHERE RecordType.DeveloperName = 'Sleep'
        AND Sleep_End_Datetime__c != null
        ORDER BY Date_Time__c DESC
        LIMIT 1 ];

        return acts.size() > 0 ? acts[0] : null;

    }


    @AuraEnabled //(Cacheable=true)
    public static Baby_Activity__c getLastHeal(){

        LIST<Baby_Activity__c> acts = [SELECT Id,
                Date_Time__c,
                Medicine__c,
                Medicine_Amount__c,
                Medicine_Units__c,
                Comments__c,
                Time__c,
                Icon__c
        FROM Baby_Activity__c
        WHERE RecordType.DeveloperName = 'Heal'
        ORDER BY Date_Time__c DESC
        LIMIT 1 ];

        return acts.size() > 0 ? acts[0] : null;

    }

    @AuraEnabled//(Cacheable=true)
    public static Baby_Activity__c getLastPlay(){

        LIST<Baby_Activity__c> acts = [SELECT Id,
                Name,
                Date_Time__c,
                Sleep_End_Datetime__c,
                Icon__c,
                Amount__c,
                Comments__c,
                RecordType.Name,
                RecordTypeId
        FROM Baby_Activity__c
        WHERE RecordType.DeveloperName = 'Play'
        ORDER BY Date_Time__c DESC
        LIMIT 1 ];

        return acts.size() > 0 ? acts[0] : null;

    }

    @AuraEnabled(Cacheable=true)
    public static Integer getTotalVitaminDToday(){

        LIST<Baby_Activity__c> acts = [SELECT Id,
                Date_Time__c,
                Vitamin_D_IU__c,
                Icon__c
                FROM Baby_Activity__c
                WHERE RecordType.Name = 'Feed'
                AND Date__c = TODAY
        ];
        integer total = 0;
        for(Baby_Activity__c item : acts){
            total += Integer.valueOf(item.Vitamin_D_IU__c);
        }
        return total;
    }

    @AuraEnabled//(Cacheable=true)
    public static decimal getTotalSleepToday(){

        LIST<Baby_Activity__c> acts = [SELECT Id,
                Date_Time__c,
                Sleep_End_Datetime__c,
                Date__c,
                Time__c,
                Hours_Slept__c,
                Icon__c
        FROM Baby_Activity__c
        WHERE RecordType.DeveloperName = 'Sleep'
        AND Sleep_End_Datetime__c = TODAY
        ];
        decimal total = 0;
        for(Baby_Activity__c item : acts){
            total += item.Hours_Slept__c;
        }
        return total;
    }

    @AuraEnabled//(Cacheable=true)
    public static Integer getTotalFoodMLToday(){

        LIST<Baby_Activity__c> acts = [SELECT Id,
                Date_Time__c,
                Amount_ML__c,
                Icon__c
        FROM Baby_Activity__c
        WHERE RecordType.DeveloperName = 'Feed'
        AND Date_Time__c = TODAY
        ];
        integer totalML = 0;
        for(Baby_Activity__c item : acts){
            totalML += Integer.valueOf(item.Amount_ML__c);
        }
        return totalML;
    }

    @AuraEnabled(Cacheable=true)
    public static BabyPayload getAverageFoodPerDay(){
        LIST<AggregateResult> acts = [SELECT Date__c,
                SUM(Amount_ML__c)
                FROM Baby_Activity__c
                WHERE RecordType.DeveloperName = 'Feed'
                AND Date_Time__c = LAST_N_DAYS:7
                AND Date_Time__c < TODAY
                GROUP BY Date__c
        ];
        integer totalML = 0;
        for(AggregateResult item : acts){
            system.debug(item);
            totalML += Integer.valueOf(item.get('expr0'));
        }
        Integer numberOfRecords = acts.size();
        Double avg = totalML / numberOfRecords;

        BabyPayload payload = new BabyPayload();
        payload.AverageDays = numberOfRecords;
        payload.AverageAmountPerDay = avg;
        return payload;
    }

    @AuraEnabled(Cacheable=true)
    public static BabyPayload getAverageSleepPerDay(){
        LIST<AggregateResult> acts = [SELECT Date__c,
                SUM(Hours_Slept__c)
        FROM Baby_Activity__c
        WHERE RecordType.DeveloperName = 'Sleep'
        AND Date_Time__c = LAST_N_DAYS:7
        AND Date_Time__c < TODAY
        GROUP BY Date__c
        ];
        integer totalML = 0;
        for(AggregateResult item : acts){
            system.debug(item);
            totalML += Integer.valueOf(item.get('expr0'));
        }
        Integer numberOfRecords = acts.size();
        Double avg = totalML / numberOfRecords;

        BabyPayload payload = new BabyPayload();
        payload.AverageDays = numberOfRecords;
        payload.AverageAmountPerDay = avg;
        return payload;
    }


    @AuraEnabled(Cacheable=true)
    public static CT_Defaults__c getDefaults(){
        return CT_Defaults__c.getOrgDefaults();
    }


    @AuraEnabled(Cacheable=true)
    public static Id getRecordTypeIdForName(String devName){
        return AuraDataWriter.getRecordTypeIdForName(devName);
    }

    @AuraEnabled
    public static Baby_Activity__c updateSleepRecord(Id recordId, Datetime endDate){
        AuraDataWriter.updateSleepRecord(recordId,endDate);
        return getLastSleep();
    }
}