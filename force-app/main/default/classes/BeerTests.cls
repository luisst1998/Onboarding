@isTest
private class BeerTests {
    //TEST NUMBER OF ROWS FROM API WITH PAGE PARAMETER
    @isTest static void BeerCalloutLIST(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('BeerCallout');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, mock);
        HTTPResponse res = BeerRequest.BeerCallout(1,1);
        List<Object> jsonResponse = (List<Object>)JSON.deserializeUntyped(res.getBody());
        
        System.assertEquals(200,res.getStatusCode());
        System.assertEquals('application/json', res.getHeader('Content-Type'));
        System.assertEquals(30, jsonResponse.size());
    }
    //TEST NUMBER OF ROWS AND VALUES FROM API
    @isTest static void BeerCalloutINDIVIDUAL(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('BeerCalloutINDIVIDUAL');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, mock);
        HTTPResponse res = BeerRequest.BeerCallout(1,0);
        List<Object> jsonResponse = (List<Object>)JSON.deserializeUntyped(res.getBody());
        
        System.assertEquals(200,res.getStatusCode());
        System.assertEquals('application/json', res.getHeader('Content-Type'));
        System.assertEquals(1, jsonResponse.size(),'List must equal to 1 beer');
        for (Object eq : jsonResponse){
			Map<String,Object> mapJson = (Map<String,Object>)eq;
            System.assertEquals(1, (Integer) mapJson.get('id'));
            System.assertEquals('Buzz', (String) mapJson.get('name'));
        }
    }
    @isTest static void BeerIdentityStatus(){
        /************** GET ALL BEERS FROM API ************/
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('BeerCallout');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        HTTPResponse res = BeerRequest.BeerCallout(1,1);
        /**************************************************/
        /*************** INSERT 10 BEERS *******************/
        List<Beer__c> newBeers = new List<Beer__c>();
        for(Integer i = 1; i<11; i++){
            Beer__c beer = new Beer__c();
            beer.Externalid__c = i;
            beer.Name = 'Beer ' + i;
            beer.Description__c = 'Description ' + i;
            beer.Tagline__c = 'Tagline ' + i;
            newBeers.add(beer);
        }
        insert newBeers;
        /**************************************************/
        List<Object> jsonResponse = (List<Object>)JSON.deserializeUntyped(res.getBody());
        Test.startTest();
		List<Beer__c> beerList = BeerRequest.getBeers(jsonResponse);
        Test.stopTest();
        List<Beer__c> beerSaved = new List<Beer__c>();
        List<Beer__c> beerNotSaved = new List<Beer__c>();
        for(Beer__c b: beerList){
            if(b.Status__c == 'Saved'){
                beerSaved.add(b);
            }else{
                beerNotSaved.add(b);
            }
        }
        System.assertEquals(10, beerSaved.size());
        System.assertEquals(20, beerNotSaved.size());
    }
}