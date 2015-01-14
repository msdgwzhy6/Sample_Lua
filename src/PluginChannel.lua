require "ClassBase"

local user_plugin = nil
local iap_plugin_maps = nil

local function onUserLogin(plugin,code,msg)
	if code == UserActionResultCode.kInitSuccess then
	    --do
	    cclog("sdk init success!")
	end
end
local function onPayResult( code, msg, info )
    print("pay result----", code, msg)
    if code == PayResultCode.kPaySuccess then
        --do
        cclog("pay success.")
    end
end

PluginChannel = class()
function PluginChannel:ctor()
    --for anysdk
    local agent = AgentManager:getInstance()
    cclog("agent is---" .. type(agent))
    --init
    --anysdk
    local appKey = "CED525C0-8D41-F514-96D8-90092EB3899A";
    local appSecret = "a29b4f22aa63b8274f7f6e2dd5893d9b";
    local privateKey = "963C4B4DA71BC51C69EB11D24D0C7D49";

    local oauthLoginServer = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php";
    agent:init(appKey,appSecret,privateKey,oauthLoginServer)
    --load
    agent:loadALLPlugin()

    -- get user plugin
    user_plugin = agent:getUserPlugin()
    cclog("getUserPlugin()--" .. type(user_plugin))
    user_plugin:setActionListener(onUserLogin)

    iap_plugin_maps = agent:getIAPPlugin()
    for key, value in pairs(iap_plugin_maps) do
        print("key:" .. key)
        cclog("value: " .. type(value))
        value:setResultListener(onPayResult)
    end

    agent:setIsAnaylticsEnabled(true)
end

function PluginChannel:login()
	if user_plugin ~= nil then
	    user_plugin:login()
	end
end

function PluginChannel:logout()
	if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("logout") then
            user_plugin:callFuncWithParam("logout")
        end
	end
end

function PluginChannel:enterPlatform()
	if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("enterPlatform") then
            user_plugin:callFuncWithParam("enterPlatform")
        end
	end
end

function PluginChannel:showToolBar()
	if user_plugin ~= nil then
	    if user_plugin:isFunctionSupported("showToolBar") then
	        local param1 = PluginParam:create(ToolBarPlace.kToolBarTopLeft)
	        user_plugin:callFuncWithParam("showToolBar", {param1})
	    end
	end
end

function PluginChannel:hideToolBar()
	if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("hideToolBar") then
            user_plugin:callFuncWithParam("hideToolBar")
        end
	end
end

function PluginChannel:accountSwitch()
	if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("accountSwitch") then
            user_plugin:callFuncWithParam("accountSwitch")
        end
	end
end

function PluginChannel:realNameRegister()
	if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("realNameRegister") then
            user_plugin:callFuncWithParam("realNameRegister")
        end
	end
end

function PluginChannel:antiAddictionQuery()
	if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("antiAddictionQuery") then
            user_plugin:callFuncWithParam("antiAddictionQuery")
        end
	end
end

function PluginChannel:submitLoginGameRole()
	if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("submitLoginGameRole") then
            local data = PluginParam:create({roleId="123456",roleName="test",roleLevel="10",zoneId="123",zoneName="test",dataType="1",ext="login"})
            user_plugin:callFuncWithParam("submitLoginGameRole", data)
        end
	end
end

function PluginChannel:pay()
	if iap_plugin_maps ~= nil then
        local info = {
                Product_Price="0.1", 
                Product_Id="monthly",  
                Product_Name="gold",  
                Server_Id="13",  
                Product_Count="1",  
                Role_Id="1001",  
                Role_Name="asd"
            }
        -- analytics_plugin:logEvent("pay", info)
        for key, value in pairs(iap_plugin_maps) do
            print("key:" .. key)
            cclog("value: " .. type(value))
            value:payForProduct(info)
        end
	end
end
