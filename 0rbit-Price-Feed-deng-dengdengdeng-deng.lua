-- EClb_xtuALtRTGUy6RG96DFveNRzlGrj3cLVE_8CCbE

local json = require("json")
 
_0RBIT = "WSXUI2JjYUldJ7CKq9wE1MGwXs-ldzlUlHOQszwQe0s"
 
BASE_URL = "https://api.coingecko.com/api/v3/simple/price"


function handleError(msg, errormsg)
    ao.send({
        Target = msg.From,
        Tags = {
            Action = "Error",
            ["MessageId"] = msg.Id,
            Error = errormsg
        }
    })
end


Handlers.add(
    "deng-dengdengdeng-deng",
    Handlers.utils.hasMatchingTag("Action", "Sponsored-Get-Request"),
    function(msg)
        local token = msg.Tags.Token
        if not token then
            handleError(msg, "Need token symbol to provide.")
            return
        end

        url = BASE_URL .. "?ids=" .. token .. "&vs_currencies=usd"
        Send({
            Target = _0RBIT,
            Action = "Get-Real-Data",
            Url = url
        })
        print(Colors.green .. "Pricefetch request sent for " .. token)
    end
)


Handlers.add(
    "Receive-Data",
    Handlers.utils.hasMatchingTag("Action", "Receive-Response"),
    function(msg)
        local res = json.decode(msg.Data)
        local price = res[token].usd
        local token = msg.Tags.Token
        if price then
            ao.send({
                Target = msg.From,
                Tags = {
                    Action = "Price-Feed",
                    ["MessageId"] = msg.Id,
                    Price = price
                }
            })
            print("Price of " .. token .. " is $" .. price)
        else
            handleError(msg, "Failed to fetch price, try later.")
        end
    end
)
