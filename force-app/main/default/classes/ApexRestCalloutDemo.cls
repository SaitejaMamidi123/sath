public class ApexRestCalloutDemo {
    /*public static void getUsersFromExternalSystem(){
        
        HTTP http = new HTTP();
        HTTPRequest req = new HTTpRequest();
        req.setEndpoint('https://reqres.in/api/collections/users/records?project_id=22559');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('x-api-key', 'free_user_3DthPX4O0r6lGjg0o2HWEWrOmDY');

        req.setMethod('GET');
        
        HTTPResponse res = new HTTPResponse();
        res = http.send(req);
        
        System.debug('@@response---'+res.getBody());
    }*/
    
    public static void createUsersInExternalSystem(){
        
        HTTP http = new HTTP();
        HTTPRequest req = new HTTpRequest();
        req.setEndpoint('https://reqres.in/api/collections/users/records?project_id=22559');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('x-api-key', 'free_user_3DthPX4O0r6lGjg0o2HWEWrOmDY');

        req.setMethod('POST');
        req.setBody('{"data": {"name": "sathvi","role": "dev", "email": "sathvi.ms1026@gmail.com"}}');
        HTTPResponse res = new HTTPResponse();
        res = http.send(req);
        
        System.debug('@@response---'+res.getBody());
    }

}