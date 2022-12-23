public class BeerRequest {
    //METHOD TO CALL API (PAGINATION OR INDIVIDUAL)
    public static HttpResponse BeerCallout(Integer page,Integer type){
    	String BEERS_PAGINATION = 'https://api.punkapi.com/v2/beers?page={page}&per_page=30';
    	String BEERS_INDIVIDUAL = 'https://api.punkapi.com/v2/beers/{page}';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        if(type == 1){
        	request.setEndpoint(BEERS_PAGINATION.replace('{page}', String.valueOf(page)));
        }else{
        	request.setEndpoint(BEERS_INDIVIDUAL.replace('{page}', String.valueOf(page)));
        }
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return response;
    }
    
    //METHOD TO IDENTIFY IF THE BEERS FROM API ARE SAVED OR NOT
    public static List<Beer__c> getBeers(List<Object> ListBeersAPI){
        List<Beer__c> ListBeers = new List<Beer__c>();
        
        Map<Decimal, Beer__c> ListBeersBD = new Map<Decimal, Beer__c>();
        for (Beer__c b : [SELECT ID, EXTERNALID__C, NAME, TAGLINE__C, DESCRIPTION__C FROM beer__c]) {
        	ListBeersBD.put(b.Externalid__c, b);
        }
        
        for (Object eq : ListBeersAPI){
			Map<String,Object> mapJson = (Map<String,Object>)eq;
            Beer__c beer = new Beer__c();
            beer.Externalid__c = (Integer) mapJson.get('id');
            beer.Name = (String) mapJson.get('name');
            beer.Tagline__c = (String) mapJson.get('tagline');
            beer.Description__c = (String) mapJson.get('description');
            if(ListBeersBD.get((Decimal)mapJson.get('id')) == null){
            	beer.Status__c = 'Not saved';
            }else{
            	beer.Status__c = 'Saved';
            }
         	ListBeers.add(beer);
        }
        return ListBeers;
    }
}