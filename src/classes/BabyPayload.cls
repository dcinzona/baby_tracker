/**
 * Created by gmt on 2019-06-18.
 */

public class BabyPayload {
    @AuraEnabled
    public Integer AverageDays {get;set;}
    @AuraEnabled
    public Double AverageFoodPerDay {get;set;}
    @AuraEnabled
    public Double AverageAmountPerDay {get;set;}
}