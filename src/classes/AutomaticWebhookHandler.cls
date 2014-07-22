/***************************************
* AutomaticWebhookHandler.cls
* Webhook endpoint for Automatic
***************************************/
<<<<<<< HEAD
@RestResource(urlMapping='/AutoWebHook/*')
=======
@RestResource(urlMapping='/AutomaticWebhook/*')
>>>>>>> 1658ed65238499a52370116b8fbe665b6dfec0dc
global class AutomaticWebhookHandler {
    @HttpPost
    global static void postHandler() {
        // Our request. This will contain the POST body, amongst other things
        RestRequest req = RestContext.request;

        // Our response. We'll use this to tell Automatic whether their webhook callout
        // wa successful or not
        RestResponse res = RestContext.response;

        // The container for our data object from Automatic. I chose to use a map of Objects rather than
        // a dedicated class because of the alpha (and possibly changing) nature of the Automatic API.
        // This choice means we have to cast everything we get from the response, but it also means we
        // can withstand changes to the request object better.
<<<<<<< HEAD
        Map<String, Object> autoResponse;
=======
		Map<String, Object> autoResponse;
>>>>>>> 1658ed65238499a52370116b8fbe665b6dfec0dc
        try {
            autoResponse = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.toString());
        }
        catch (Exception e) {
<<<<<<< HEAD
            // Indicate a failure if we couldn't even deserialize the request. Currently, Automatic does
            // nothing with this failure information
            res.statusCode = 500;
            return;
=======
        	// Indicate a failure if we couldn't even deserialize the request. Currently, Automatic does
        	// nothing with this failure information
        	res.statusCode = 500;
        	return;
>>>>>>> 1658ed65238499a52370116b8fbe665b6dfec0dc
        }

        // For this demo, we're only handling the "trip finished" webhook. Many others are specified in the
        // Automatic API docs

        // We'll use the 'type' key of the request body, and get a class that implements our iAutomaticHandler interface,
        // which consists of a single method that returns a boolean: true for success, false for failure

<<<<<<< HEAD
        System.Type webhookHandlerType = Type.forName('Automatic'+((String)autoResponse.get('type')).replaceAll('[^a-zA-Z0-9\\s]','')+'Handler');
        System.debug('WEBHOOK HANDLER TYPE'+webhookHandlerType);
        IAutomaticHandler autoHandler;
        // Let's try and grab a handler for the type of webhook callout this is
        try {
            autoHandler=(IAutomaticHandler)webhookHandlerType.newInstance();
        }
        // If we can't, let's assume that we don't want to handle whatever type of callout this is, and return a success
        // Alternatively, we could return a 500 to flag an error on the Automatic end. At the moment, both choices result
        // in the same thing, nothing is created on the Salesforce end
        catch (Exception e) {
            System.debug('WEBHOOK HANDLER TYPE'+webhookHandlerType);
            res.statusCode = 200;
            return;
        }

        // If our handler had a problem, return a 500
        if (!autoHandler.handleWebhook(autoResponse)) {
            res.statusCode = 500;
            return;
        }

        // Tell Automatic that everything went ok.
        res.statusCode = 200;
        System.debug('WEBHOOK HANDLER TYPE'+webhookHandlerType);
=======
    	System.Type webhookHandlerType = Type.forName('Automatic'+((String)autoResponse.get('type')).replaceAll('[^a-zA-Z0-9\\s]','')+'Handler');
    	IAutomaticHandler autoHandler;
    	// Let's try and grab a handler for the type of webhook callout this is
    	try {
	    	autoHandler=(IAutomaticHandler)webhookHandlerType.newInstance();
    	}
    	// If we can't, let's assume that we don't want to handle whatever type of callout this is, and return a success
    	// Alternatively, we could return a 500 to flag an error on the Automatic end. At the moment, both choices result
    	// in the same thing, nothing is created on the Salesforce end
    	catch (Exception e) {
	    	res.statusCode = 200;
	    	return;
    	}

    	// If our handler had a problem, return a 500
	    if (!autoHandler.handleWebhook(autoResponse)) {
	    	res.statusCode = 500;
	    	return;
	    }

        // Tell Automatic that everything went ok.
		res.statusCode = 200;
>>>>>>> 1658ed65238499a52370116b8fbe665b6dfec0dc
    }

}