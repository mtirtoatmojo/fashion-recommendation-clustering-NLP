# fashion-recommendation-clustering-NLP

**Fashion Retail Trend Identification and Production Optimisation: Harnessing Clustering and Sentiment Analysis for Sustainable Trend Production and Recommendations** 

**Intro** 
* In today's digital age, e-commerce and fashion retail are experiencing a significant transformation due to rapidly evolving consumer behaviors and expectations. Modern buyers are increasingly conscious of their purchasing decisions, considering not only the style, color, and price of a garment but also its quality, sustainability, and longevity. Therefore, the need for trend recommendation is crucial to ensure that the company is optimizing revenue growth while also considering sustainability efforts through predicting the right fashion trends. By leveraging data analysis and visualizations in R, we aim to identify and capitalize on emerging fashion trends before they reach their peak in popularity. This proactive approach will allow us to optimize production schedules, reduce excess inventory, and lower production costs. 

* Our data-driven strategy for identifying fashion trends and what items are popular will position retailers at the forefront of the dynamic fashion industry. By utilizing clustering, sentiment analysis, and text mining, we can increase the production of on-trend clothing items, decrease production costs, and ultimately drive revenue growth.

**Dataset** 

* Two datasets are being utilized for this project; Dataset A consists of fashion product data while Dataset B consists of ratings and reviews of said products. Dataset A comprises 43 columns and encompasses a wide range of fashion products including clothing, accessories, footwear, and beauty products. It covers various categories such as casual wear, formal wear, athleisure, swimwear, lingerie, and more. 
Each category includes detailed information about each product such as color, pattern, material, price, product display page (PDP) links as well as numerical ratings (scale 1-5 stars). 
Dataset B consists of 11 columns, revolving around the reviews written by customers for fashion products in Dataset A. 

**Dataset A Key Variable Description** 
* Title: String variable of product name
* Title_Orig: String variable of product name, without special characters ($%&*!@#)
* Price: Integer variable original price
* Retail_Price: Integer variable of the price unit is sold at
* Currency_Buyer: String variable of currency (EUR)
* Units_Sold: Integer variable of inventory sold
* Rating: Integer variable of product rating (1-5 star scale)
* Rating_Count: Integer variable of number of ratings submitted for a product
* Ratings_Five_Count, Ratings_Four_Count, Ratings_Three_Count, Ratings_Two_Count, Ratings_One_Count: Integer variable of fraction of ratings (out of total ratings) that received a 5, 4, 3, 2, 1 star review.
* Tags: String variable consisting of comma separated tags applied to each product by the company (eg collection ,season, holiday etc tags)
* Product_Color: String variable of the product color
* Product_Variation_Size_Id: String variable of product size
* Product_Variation_Iventory: Integer variable of units of product left in stock
* Product_Url: String consisting of PDP link for a product
* Prduct_Id: String variable of item ids (unique on size, colourway and style level)
* Theme: String variable of collection item is categorised as

**Dataset B Variable Description**
* Clothing ID: Integer Categorical variable that refers to the specific piece being reviewed.
* Age: Positive Integer variable of the reviewers age.
* Title: String variable for the title of the review.
* Review Text: String variable for the review body.
* Rating: Positive Ordinal Integer variable for the product score granted by the customer from 1 Worst, to 5 Best.
* Recommended IND: Binary variable stating where the customer recommends the product where 1 is recommended, 0 is not recommended.
* Positive Feedback Count: Positive Integer documenting the number of other customers who found this review positive.
* Division Name: Categorical name of the product high level division.
* Department Name: Categorical name of the product department name.
* Class Name: Categorical name of the product class name.


