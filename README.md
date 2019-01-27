Marketing Campaign Effectiveness
================================

# Introduction

As part of a marketing campaign to increase customer spend and loyalty, client sent out coupons to 4000 buyers by post. 
Each buyer received one coupon for $10 which they could spend on client.com in a two week window between the 5th and 
18th January 2015.Some buyers used their coupon to get money off their purchases in that time (Redeemers) and others 
chose not to (Non-Redeemers). A third group of shoppers (Control) were not sent a coupon but will act as a benchmark 
as we assess whether the coupons successfully boosted customer spending as hoped.


# Datasets

Input data sets are present in input folder. Customer weekly spend information is available in AllUser file. You will also find # of purchase, test or control group in this file. Redeemers customers list present in Redeemers file.

# Business Questions

* What's is the spend distribution over the 12 week period between 24th November 14 and 9th February 15 i.e. 6 weeks before the coupon 'drop date' to 6 weeks after. Please compare the results for each group (Control, Test-Redeemers, Test-NonRedeemers).

* What is the incremental spend in the six weeks after the coupons were sent (additional spend above what we would have expected had no coupon been sent out) for the total Test group (Redeemers and Non-Redeemers) vs. Control?

* What's the ROI of this campaign. 
	* Revenue = Spend x Take Rate (=10%). 
	* Cost of the coupon campaign is equal to the value of a coupon multiplied by the number of coupons redeemed.
	
# Set up Structure

* Input Files would be kept in Input folder.
* Output Files would be saved in Output folder automatically. One sample output is present here for an example.
* src contains all source codes
	* Main Code: Calling all the codes and specifying arguments.
	* UDF: User Defined Function.
	* Required Libraries: Loading all Packages.
	* Data Preparation: Importing csvs and joining tables, checking formats etc.
	* Basic Diagnostic: Group level, customer level analysis.
	* Spend Distribution: Roll up spend at desired level to get an idea how sales are varying over time.
	* Incremental Spends: Roll up spend by different groups and compute incremental w.r.t control group.
	* Computing ROI: Compute ROI for the coupons.
	* Additional Analysis: Profiling of customers based on spends and # of purchase. 

# Future Work

* Create more advanced R-Shiny app for dynamic reports.
* Error Logging to have production level readyness.