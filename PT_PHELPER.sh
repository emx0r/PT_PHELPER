#!/bin/sh
# Instructions:
# -------------
# put the path to your PT PAIRS.properties file into the file
# variable.
# Let the script run from cron, passing your limit as a parameter
#
# e.g. */5 * * * * /var/scripts/pairs_helper.sh 15
#
# Donations are welcome
# ----------------------
# BTC: 127vURZ3MwzFCmNLp1TubfGyxU7bb5BwQc
# ETH: 0xe254cd63d727ed63eb7e4fa78bf5af8c4f5fe328
# LTC: LP4x1TfDe36QcCj7o79Br8mWxTipLNdhY5


limit=$1
dt=`date`

file=/path_to_your/PAIRS.properties #change here

list=`curl --silent https://api.coinmarketcap.com/v1/ticker/ | grep -e symbol -e percent_change_24h | cut -f4 -d'"' | xargs -n 2 | awk '{ print $1":"$2 }'`
btcPct=`curl --silent https://api.coinmarketcap.com/v1/ticker/bitcoin/ | grep percent_change_24h | cut -f4 -d'"'`


`sed -i '/#PAIRS_HELPER@MK/,$d' $file`
echo "#PAIRS_HELPER@MK" >> $file
echo "# $dt" >> $file
for i in $list
do
        coin=`echo $i | cut -f1 -d':'`;
        pct=`echo $i | cut -f2 -d':'`;

        diffPct=`echo "$pct - $btcPct" | bc`;



        a=$diffPct
        b=$limit
        case `echo "a=$a;b=$b;r=-1;if(a==b)r=0;if(a>b)r=1;r"|bc` in
           1) echo "BTC-"$coin"_sell_only_mode = true" >> $file; echo "# $diffPct% > $limit%" >> $file
           ;; esac
        b=`echo "$limit * -1" | bc`
        case `echo "a=$a;b=$b;r=-1;if(a==b)r=0;if(a<b)r=1;r"|bc` in
           1) echo "BTC-"$coin"_sell_only_mode = true" >> $file; echo "# $diffPct% < $b%" >> $file
           ;; esac

done
