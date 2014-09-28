local config = {}
config.nick = "Titanoid"
config.channel = "#titan-studio"

local socket = require("socket")

local s = socket.tcp()
s:connect("irc.freenode.net", 6667)

s:send("USER " .. config.nick .. " " .. " " .. config.nick .. " " .. config.nick .. " " .. ":" .. config.nick .. "\r\n\r\n")
s:send("NICK " .. config.nick .. "\r\n\r\n")
s:send("PRIVMSG nickserv identify password1234\r\n\r\n")
s:send("JOIN " .. config.channel .. "\r\n\r\n")

function string:split(sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        self:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields
end

function sendMsg(msg)
	s:send("PRIVMSG " .. config.channel .. " :" .. msg .. "\r\n\r\n")
end

function sendKick(name, reason)
	s:send("KICK " .. config.channel .. " " .. name .. " :" .. reason .. "\r\n\r\n")
end

while true do
	local recv = s:receive("*l")
	print(recv)

	splitted = recv:split(" ")

	if string.find(recv, "PING :") then
		s:send("PONG :" .. string.sub(recv, (string.find(recv, "PING :") + 6)) .. "\r\n\r\n")
	end

	if splitted[4] == ":!echo" then
		sendMsg("Echo!")
	elseif splitted[4] == ":Titanoid!" then
		temp = splitted[1]:split("!")
		temp = string.gsub(temp[1], ":", "")
		sendMsg(temp .. "!")
	elseif splitted[4] == ":!kick" then
		sendKick(splitted[5], splitted[6])
	end
end