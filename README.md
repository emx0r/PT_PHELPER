# PT_PHELPER
Addon script for Profit Trailer to automatically enable SOM for a specific pair if it goes beyond specified limit


This is a very simple Bourne Shell script aimed to help avoiding bags in Profit Trailer.
It scans % difference for last 24 hours of all coins and if the percentage has crossed the limit, the PT_PHELPER
enables a SOM mode for the specific pair.

You can avoid buying a pair if it grew or dropped more than x% you specify as a parameter

### Instructions:

point FILE variable to your PT PAIRS.properties file
setup a crontab statement to run the script every 5 minutes or so:

** */5     *       *       *       * /var/scripts/pairs_helper.sh 15

The argument after the script defines the limit beyound which we want to trigger SOM +-15% in this specific example

#### Result:
The PT_PHELPER modifies your active PAIR.properties file changing all affected coins to SOM.

e.g.

#PAIRS_HELPER@MK
#Tue 13 Feb 19:00:01 UTC 2018
BTC-UCASH_sell_only_mode = true
 -42.00% < -15%
BTC-R_sell_only_mode = true
 23.30% > 15%
BTC-ZCL_sell_only_mode = true
 28.35% > 15%
BTC-LINK_sell_only_mode = true
 23.98% > 15%
BTC-SMART_sell_only_mode = true
 -17.54% < -15%

Even though it is a very simple script any donations are welcome :)))

