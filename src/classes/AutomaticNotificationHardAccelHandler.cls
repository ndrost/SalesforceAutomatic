public with sharing class AutomaticNotificationHardAccelHandler implements IAutomaticHandler {
    public Boolean handleWebhook(Map<String, Object> webhookRequestBody) {
        Map<String, Object> vehicle=(Map<String, Object>)webhookRequestBody.get('vehicle');
        Map<String, Object> location=(Map<String, Object>)webhookRequestBody.get('location');
        Map<String, Object> autoUser=(Map<String, Object>)webhookRequestBody.get('user');

        String vehicleId=(String)vehicle.get('id');
        String autoUserId=(String)autoUser.get('id');
        Vehicle__c v;
        // Let's see if we have an existing vehicle with the request body's vehicle's automatic id (which
        // we've set as a unique, external id in salesforce)
        try {
            v=[select id, name, automatic_id__c, year__c, make__c, model__c, color__c from Vehicle__c where automatic_id__c = :vehicleId];
        }
        Catch (Exception e) {
            // If not, create a new vehicle
            v=new Vehicle__c();
            v.Automatic_Id__c=(String)vehicle.get('id');
            v.name=(String)vehicle.get('display_name');
            v.year__c=String.valueOf((Integer)vehicle.get('year'));
            v.make__c=(String)vehicle.get('make');
            v.model__c=(String)vehicle.get('model');
            v.color__c=(String)vehicle.get('color');
            insert v;
        }

        // Now let's get the driver of the vehicle, found by matching the request body user id with an authentication custom setting
        // for thenAutomatic user id we saved. We're querying our hierarchiical custom object using SOQL here, rather than the
        // regular getInstance method
        String userId;
        try {
            AutomaticAPI__c aAPI= [select id, SetupOwnerId from AutomaticAPI__c where Automatic_Id__c = :autoUserId];
            userId=aAPI.SetupOwnerId;
        }

        // For our purposes, we won't handle the case where we can't find a user, and will just leave this info blank in our
        // final saved record
        Catch (Exception e) {
        }

        // Now let'e create a new trip, populating it with information from the request body. (Note all the casting we
        // have to do.)
        HardAccelEvent__c hae = new HardAccelEvent__c();
        hae.Driver__c = userId;

        hae.Vehicle__c=v.id;
        hae.g_force__c = (Double)webhookRequestBody.get('g_force');
        hae.Location__Latitude__s = (Double)location.get('lat');
        hae.Location__Longitude__s = (Double)location.get('lon');

        try {
            insert hae;
        }
        Catch (Exception e) {
            return false;
        }
        return true;
    }
}