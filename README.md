# MoneyPlan

1. API relative information
* Name : News API
* Url : https://newsapi.org/docs/get-started
* Description : We adopt Top headlines API for our project.This endpoint provides live top and breaking articles for a country, specific category in a country, single source, or multiple sources. You can also search with keywords. Articles are sorted by the earliest date published first.


2. Data elements

* status : If the request was successful or not. Options: ok, error. In the case of error a code and message property will be populated. 
* totalResults : The total number of results available for your request.
* articles :The results of the request.  
* source : The identifier id and a display name name for the source this article came from. 
*  author : The author of the article 
* title : The title of the article web page. 
* content : The unformatted content of the article, where available. This is truncated to 200 chars.
* description : A description or snippet from the article. 
* url : The direct URL to the article.  
* urlToImage : The URL to a relevant image for the article.  
* publishedAt : The date and time that the article was published, in UTC (+000)   
* content : The unformatted content of the article, where available. This is truncated to 200 chars.

3. Entities : ![ERD](https://user-images.githubusercontent.com/103323426/195989801-fdff892f-ee32-4d46-b479-c91d2713b0b5.png)
