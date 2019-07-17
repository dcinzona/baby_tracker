/**
 * Created by gtandeciarz on 2019-07-16.
 * Sharing can be enforce by specifying .withPermissions(true) which checks to see if the running user has access to the record type
 */
public without sharing class RecordTypeUtility {

    @TestVisible
    private Boolean enforceSharing = false;
    private String objectAPIName {get;set;}
    private List<RecordTypeInfo> allRecordTypes_priv {get; private set;}
    private List<RecordTypeInfo> allRecordTypes {get {
        if(String.isEmpty(this.objectAPIName)){
            throw new RecordTypeUtilityException('Missing SObject API Name');
        }
        if(this.allRecordTypes_priv == null){
            List<RecordTypeInfo> infos = new List<RecordTypeInfo>();
            try{
                if(!String.isEmpty(this.objectAPIName)){
                    Map<String, Schema.SObjectType> sobjTypeMap = Schema.getGlobalDescribe();
                    Schema.SObjectType sobjectType = sobjTypeMap.get(this.objectAPIName);
                    infos = sobjectType.getDescribe().getRecordTypeInfos();
                }
            } catch( Exception ex ){
                throw new RecordTypeUtilityException('## RecordTypeUtility Error: ' + ex.getMessage());
            }
            this.allRecordTypes_priv = infos;
        }
        return this.allRecordTypes_priv;
    }}

    public RecordTypeUtility(){
        this.objectAPIName = null;
    }

    public RecordTypeUtility forObject(String objectApiName){
        this.objectAPIName = objectApiName;
        return this;
    }

    public RecordTypeUtility withPermissions(Boolean checkPermission){
        this.enforceSharing = checkPermission;
        return this;
    }

    public RecordTypeUtility(String objectAPIName){
        this.objectAPIName = objectAPIName;
    }

    public Map<String, RecordTypeInfo> getMap(){
        Map<String, RecordTypeInfo> rtMap = new Map<String, RecordTypeInfo>();
        for(RecordTypeInfo info : this.getAllowedRecordTypesList()){
            rtMap.put(info.getDeveloperName().toLowerCase(), info);
            rtMap.put(info.getDeveloperName(), info);
            rtMap.put(info.getDeveloperName().toUpperCase(), info);
        }
        return rtMap;
    }

    /****
     *
     *
     * @return Map with lowercase keys
     */
    public Map<String, Id> getIdsMap(){
        Map<String, Id> rtMap = new Map<String, Id>();
        for(RecordTypeInfo info : this.getAllowedRecordTypesList()){
            rtMap.put(info.getDeveloperName().toLowerCase(), info.getRecordTypeId());
            rtMap.put(info.getDeveloperName(), info.getRecordTypeId());
            rtMap.put(info.getDeveloperName().toUpperCase(), info.getRecordTypeId());
        }
        return rtMap;
    }

    public Id getRecordTypeIdByDeveloperName(String recordTypeDeveloperName) {
        return this.getIdsMap().get(recordTypeDeveloperName.toLowerCase());
    }

    public List<RecordTypeInfo> getAllowedRecordTypesList(){
        List<RecordTypeInfo> infos = new List<RecordTypeInfo>();
        for(RecordTypeInfo info : this.allRecordTypes){
            if(this.enforceSharing){
                if(info.isAvailable()){
                    infos.add(info);
                }
            } else {
                infos.add(info);
            }
        }
        return infos;
    }

    public class RecordTypeUtilityException extends Exception {}
}
