
# PT_PHELPER
Addon script for Profit Trailer to automatically enable SOM for a specific pair if it goes beyond specified limit


This is a very simple Bourne Shell script aimed to help avoiding bags in Profit Trailer.
It scans % difference for last 24 hours of all coins and if the percentage has crossed the limit, the PT_PHELPER
enables a SOM mode for the specific pair.

You can avoid buying a pair if it grew or dropped more than x% you specify as a parameter

### Instructions:

point FILE variable to your PT PAIRS.properties file
setup a crontab statement to run the script every 5 minutes or so:

*/5     *       *       *       * /var/scripts/pairs_helper.sh 15

The argument after the script defines the limit beyound which we want to trigger SOM +-15% in this specific example

#### Result:
The PT_PHELPER modifies your active PAIR.properties file changing all affected coins to SOM.

e.g.

BTC-UCASH_sell_only_mode = true

BTC-ZCL_sell_only_mode = true

Even though it is a very simple script any donations are welcome :)))

BTC: 127vURZ3MwzFCmNLp1TubfGyxU7bb5BwQc
ETH: 0xe254cd63d727ed63eb7e4fa78bf5af8c4f5fe328
LTC: LP4x1TfDe36QcCj7o79Br8mWxTipLNdhY5
