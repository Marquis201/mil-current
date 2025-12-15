--[[
MySQLite.initialize({
    EnableMySQL = true,
    Host = DP.Host,
    Username = DP.Username,
    Password = DP.Password,
    Database_name = DP.Database,
    Database_port = DP.Port
})
--]]


local DP = util.JSONToTable(file.Read("db_connect.dat"))
mysql.connect_config = mysql.Connect(DP.Host, DP.Username, DP.Password, DP.Database, DP.Port)
