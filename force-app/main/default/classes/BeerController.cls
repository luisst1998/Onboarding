public class BeerController {
	public Integer pagination {get;set;}
    public Integer externalid {get;set;}

    public BeerController(){
        this.pagination = 1;
    }
    public void Previous() {
        if(pagination > 1){
        	pagination --;
        }
    }
    public void Next(){
        if(pagination < 11){
        	pagination ++;
        }
    }
    // GET ALL BEERS FROM API IDENTIFYING IF THEY ARE SAVED OR NOT
    public List<Beer__c> getBeers(){
        HttpResponse response = BeerRequest.BeerCallout(pagination,1);
        List<Beer__c> beerList = new List<Beer__c>();
        if (response.getStatusCode() == 200){
            List<Object> jsonResponse = (List<Object>)JSON.deserializeUntyped(response.getBody());
            beerList = BeerRequest.getBeers(jsonResponse);
        }
        return beerList;
    }
    
    public PageReference Insertbeer(){
        PageReference pageRef = ApexPages.currentPage();
        //GET ONLY ONE BEER 
        HttpResponse response = BeerRequest.BeerCallout(externalid,0);
        List<Beer__c> beerList = new List<Beer__c>();
        if (response.getStatusCode() == 200){
            List<Object> jsonResponse = (List<Object>)JSON.deserializeUntyped(response.getBody());
            beerList = BeerRequest.getBeers(jsonResponse);
        }
        upsert beerList Externalid__c;
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference SaveAll(){
        PageReference pageRef = ApexPages.currentPage();
        //GET ALL BEERS FROM PAGE
        HttpResponse response = BeerRequest.BeerCallout(pagination,1);
        List<Beer__c> beerList = new List<Beer__c>();
        if (response.getStatusCode() == 200){
            List<Object> jsonResponse = (List<Object>)JSON.deserializeUntyped(response.getBody());
            beerList = BeerRequest.getBeers(jsonResponse);
        }
        upsert beerList Externalid__c;
        pageRef.setRedirect(true);
        return pageRef;
    }
}