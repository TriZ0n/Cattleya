module Events
	extend Discordrb::EventContainer
	message do |event|
		if event.message.channel.pm?
			#does nothing
		else
			newtime = event.timestamp
			if $players.key?(event.user.id.to_s)
				if $players[event.user.id.to_s].key?('time')
					oldtime = $players[event.user.id.to_s]['time']
				else
					oldtime = "2017-01-01 00:00:00 +0000"
				end
				if TimeDifference.between(oldtime, newtime).in_seconds > 30
					$players[event.user.id.to_s]['xp'] += rand(15..25)
					$players[event.user.id.to_s]['time'] = newtime
				end
			else
				$players[event.user.id.to_s] = {'xp'=>0, 'level'=>0, 'hr'=>0, 'zenny'=>100, 'time'=>newtime, 'inv'=>{'0'=>1}}
			end
			if $players[event.user.id.to_s]['level'] < 100
				if $players[event.user.id.to_s]['xp'] > $levels[$players[event.user.id.to_s]['level']+1]
					zenny = (rand(0..9) * 10) + (rand(0..9) * 100) + (($players[event.user.id.to_s]['level'] / 4).floor * 1000)
					$players[event.user.id.to_s]['level'] += 1
					if $players[event.user.id.to_s].key?("messages")
						if $players[event.user.id.to_s]['messages']
							$bot.user(event.user.id.to_s).pm("Congratulations! You have leveled up to Level #{$players[event.user.id.to_s]['level']}\nYou have earned yourself #{zenny} Zenny and a few items you can trade or use!")
						end
					end
					$players[event.user.id.to_s]['zenny'] += zenny
					numitems = rand(3..5)
					newitems = []
					numitems.times do
						item = rand(0..($items.length-1))
						newitems.push(item)
						item = item.to_s
						if $players[event.user.id.to_s]['inv'].key?(item)
							$players[event.user.id.to_s]['inv'][item] += 1
						else
							$players[event.user.id.to_s]['inv'][item] = 1
						end
					end
					if $players[event.user.id.to_s].key?("messages")
						if $players[event.user.id.to_s]['messages']
							$bot.user(event.user.id.to_s).pm.send_embed '', newItems(newitems, event.user.name.to_s)
						end
					end
				end
			end
		end
	end
end
