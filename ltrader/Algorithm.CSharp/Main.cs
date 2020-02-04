// Basic historical data query checks.

using System;
using System.Collections.Generic;
using System.Linq;
using QuantConnect.Data;
using QuantConnect.Data.Custom;
using QuantConnect.Data.Market;
using QuantConnect.Securities.Equity;
using QuantConnect.Interfaces;

namespace QuantConnect.Algorithm.CSharp
{
    public class LTraderAlgorithm : QCAlgorithm
    {

        public override void Initialize()
        {
            SetStartDate(2020, 2, 1);
            SetStartDate(2020, 2, 1);
            SetCash(1000);
            
            var SPY = AddSecurity(SecurityType.Equity, "JNJ", Resolution.Daily).Symbol;
            
            var tradeBarHistory = History<TradeBar>("JNJ", TimeSpan.FromDays(8));
            Debug("Daily history query result: ");
            Debug(tradeBarHistory.ToList().Count());
            
            tradeBarHistory = History<TradeBar>("JNJ", 14, Resolution.Minute);
            Debug("Minute history query result: ");
            Debug(tradeBarHistory.ToList().Count());
        }

        public override void OnData(Slice data)
        {
            if (LiveMode)
            {
            	Debug("On data: ");
            	Debug(data["JNJ"].Open);
            }
        }

    }
}

