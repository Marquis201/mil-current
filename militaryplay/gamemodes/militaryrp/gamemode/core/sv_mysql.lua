hook.Add("DatabaseInitialized", "DatabaseInitialized", function()
	local dp = mysql.connect_config

	dp:Query([[
		CREATE TABLE IF NOT EXISTS metahub_player_data (
			id INT AUTO_INCREMENT PRIMARY KEY,
			steam_id VARCHAR(25),
			community_id VARCHAR(64),
			player VARCHAR(255),
			money INT DEFAULT 0,
			vehicles TEXT,
			items TEXT
		);
	]])

	dp:Query([[
		CREATE TABLE IF NOT EXISTS metahub_characters (
			character_id INT AUTO_INCREMENT PRIMARY KEY,
			player_id INT,
			rpid INT,
			c_rank VARCHAR(255),
			features VARCHAR(255),
			team_id VARCHAR(255),
			character_name VARCHAR(255),
			model VARCHAR(255),
			data TEXT
		);
	]])

	dp:Query([[
		CREATE TABLE IF NOT EXISTS metahub_spawnpoints (
			map VARCHAR(255),
			vector VARCHAR(64),
			category VARCHAR(255)
		);
	]])

	dp:Query([[
		CREATE TABLE IF NOT EXISTS metahub_player_levelsystem (
			steam_id VARCHAR(25) PRIMARY KEY,
			level INT DEFAULT 1,
			experience INT DEFAULT 0
		);
	]])
end)
