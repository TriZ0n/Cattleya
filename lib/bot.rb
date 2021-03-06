#create botfiles directory if it doesn't exist
unless File.exist?("botfiles")
	Dir.mkdir("botfiles")
end

#load env variables
Dotenv.load

#load other variables
$players = Hash.new
$players = loadJSON($players, "botfiles/players.json")

#sets bot prefix
$prefix = '#'

#Loads and establishes $bot object
$bot = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'], client_id: ENV['CLIENT'], prefix: $prefix, advanced_functionality: false

#Load permissions from file
permarray = Array.new
permarray = loadPerm(permarray,"botfiles/perm")
pos = 0
begin
	$bot.set_user_permission(permarray[pos],permarray[pos+1])
	pos += 3
end while pos < permarray.length
puts "Permission Loaded!"

#Load all commands
Commands.constants.each do |x|
	$bot.include! Commands.const_get x
end

#Load events
$bot.include! Events

#Turn off debugging and run async
$bot.debug = false
$bot.run :async
	
#Set game status from file
if File.file?("botfiles/game")
	$bot.game = getline("botfiles/game",1)
else
	$bot.game = 0
end

puts $bot.invite_url

#start cron
cronjobs_start

puts 'Cattleya ready to serve!'
$bot.sync
