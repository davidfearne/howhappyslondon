# How Happys London Project

## Abstract
How Happys London (2HL) was devised as a way for easily demonstrating the power of large-scale analytics. By looking at multiple freely available data sources and applying simplistic weighting algorithms it is possible to get a point in time consensus as to the happiness of London. This demonstration is designed to give the observer an idea of how to take the methods and theories employed in 2HL and apply them inside their own business. 
2HL is a demonstration of both net result and visual analytics. It leverages both structured and semi structured data sources to process 2.6 billion data points a day to answer 1 single point in time question accurately “Is London happy?”

## Overview
Whenever faced with an analytics problem it is important to define first what the required outcome will be. From this point you can work backwards from the business need rather than up to an outcome that may not match what the business required. This is critical of all major technology projects undertaken today but few have such large business impact as analytics. Its entire goal is to aid and inform better business decision making. It’s also important to define the final purpose of the analytics process. Will the result drive automated changes, display greater details or provide point in time or predictive single decision assistance. 
The goal set for 2HL was to design a system that could show the power of analytics in such a way that its message could be understood by the board room executives, operational executives and middle management. 
This required an approach that could engage a user helping them to understand how to gain a point in time snapshot of their business or organization but also from this delve deeper into the data to identify opportunities to gain a business advantage over the competition. 
The demonstration needed to show how this is achieved using large sets of data that were unrelated in themselves but once used to enrich the initial data streams became valuable insights that were simply unachievable via conventional methods such as Excel.
2HL uses data sources found in London to create a point in time predictive analysis of weather London is generally happy, indifferent or unhappy. This is then used to control a video representation of a face that, Smiles frowns or look sad. Around the outside of the face we then display the various data breakout points were we have processed certain data to create our indexes.
Note. 2HL is not a best practice implementation. It is designed to be a demonstration of different methodologies and techniques that could be implemented to help businesses gain commercial or intellectual advantage. The goal of the system and this paper is to be used as a reference architecture to be extended and consolidated to provide a more focused solution.

# How Happys London Public API (BETA) 
The happiness of London project presents it data via Open RESTful API's. These API's are used to access the indexes for either the point in time values or a range of values based on a URL encoded time start and time end stamp.

## Authorisation
An API key is required to access the API. This is required to be presented as an API key header keys are issued by david.fearne@arrow.com

```https
apiKey:		jd1384y13ruc93480ry3498ry329t8y2
```
Request size limiting was implemented via the key rate limiting and is currently set at 1440 requests per day or 1 per minute per API key.
Query limiting is implemented using query request inspection in the API engine. At current we have limited the request sizes to 1 month of histographic data. This will return 44640 data points.

All API calls are GET requests

## API Calls

### Happiness of London Now

#### Request

```https
curl --header "apiKey: jd1384y13ruc93480ry3498ry329t8y2" 
https://api.arrowdemo.center/v1/theface/now
```
#### Response

```JSON
{"value":"indifferent","index":"0.530952380952381”}
```
### Happiness of London Over time
This API call requests for a range of indexes to represent the happiness of London over time 
The range of time is deterimed by time start `ts` and time end `te`. The time and data stamps are formatted as YYYY-MM-DD HH-MM-SS and URL encoded

Request
```https
curl --header "apiKey: jd1384y13ruc93480ry3498ry329t8y2" https://api.arrowdemo.center/v1/theface/range?ts=2015-10-23%2000%3A50%3A48&te=2015-10-23%2000%3A59%3A48

```
Response 
```JSON
{
	"value": [
		{
			"value": "happy",
			"index": "0.873886269070735",
			"datetime": "2015-10-23T00:50:48.000"
		},
		{
			"value": "happy",
			"index": "0.873886269070735",
			"datetime": "2015-10-23T00:51:48.000"
		},
		{
			"value": "happy",
			"index": "0.873886269070735",
			"datetime": "2015-10-23T00:52:48.000"
		},
		{
			"value": "happy",
			"index": "0.873886269070735",
			"datetime": "2015-10-23T00:53:48.000"
		},
		{
			"value": "happy",
			"index": "0.873886269070735",
			"datetime": "2015-10-23T00:54:48.000"
		},
		{
			"value": "happy",
			"index": "0.8738815331010453",
			"datetime": "2015-10-23T00:55:48.000"
		},
		{
			"value": "happy",
			"index": "0.8738815331010453",
			"datetime": "2015-10-23T00:56:48.000"
		},
		{
			"value": "happy",
			"index": "0.8738815331010453",
			"datetime": "2015-10-23T00:57:48.000"
		},
		{
			"value": "happy",
			"index": "0.8738815331010453",
			"datetime": "2015-10-23T00:58:48.000"
		},
		{
			"value": "happy",
			"index": "0.8738815331010453",
			"datetime": "2015-10-23T00:59:48.000"
		}
	]
}
```
### Recalling individual indexs over time
As part of the API set we have also exposed access to the individual indexs that go towards creating the overall happiness index. 
The range of time is deterimed by time start `ts` and time end `te`. The time and data stamps are formatted as YYYY-MM-DD HH-MM-SS and URL encoded
The item required is determined by the `i` parameter in the request string. Currently we support

1. Wether Data courtesy of the MetOffice
  1. Current tempreature in London determined by the `i=temperature`
  2. Chance of rainfall determined by the `i=precipitation`
  3. Predicted type of wether `i=weathertype`

2. Travel Data courtesy of Transport for London (TfL)
  1. Underground tube line status determined by the `i=tube`  
  2. Road congestion status determined by the `i=road`  
  3. Bus line status determined by the `i=bus`  

3. Socail data courtesy of Twitter
  1. Socail semitent index of London determined by the `i=social` 

#### Request

```https
curl --header "apiKey: jd1384y13ruc93480ry3498ry329t8y2"
https://api.arrowdemo.center/v1/items/range?i=precipitation&ts=2016-2-23%2000%3A50%3A48&te=2016-2-23%2000%3A59%3A48
```
#### Response 

```JSON
{
	"item": [
		{
			"index": "0.97",
			"datetime": "2016-02-23T00:53:11.000"
		},
		{
			"index": "0.97",
			"datetime": "2016-02-23T00:57:11.000"
		},
		{
			"index": "0.97",
			"datetime": "2016-02-23T00:52:11.000"
		},
		{
			"index": "0.97",
			"datetime": "2016-02-23T00:56:11.000"
		},
		{
			"index": "0.97",
			"datetime": "2016-02-23T00:59:11.000"
		},
		{
			"index": "0.97",
			"datetime": "2016-02-23T00:54:11.000"
		},
		{
			"index": "0.97",
			"datetime": "2016-02-23T00:58:11.000"
		},
		{
			"index": "0.97",
			"datetime": "2016-02-23T00:51:11.000"
		},
		{
			"index": "0.97",
			"datetime": "2016-02-23T00:55:11.000"
		}
	]
}

