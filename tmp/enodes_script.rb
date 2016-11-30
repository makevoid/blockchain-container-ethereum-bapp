# enodes script by @mikeh & @makevoid


# simple solution - reads the enodes from the containers (pm2 parity log) - writes parity peers.enodes enodes config file

# use this script after your ethereum "cluster" (nodes) are up and scaled ( `git up && docker-compose build && docker-compose up -d && ./enodes_script` )


path = File.expand_path "../../", __FILE__

system "cd #{path}"
containers = `docker ps -aqf name=bapp2_bapp`.split "\n"

enodes = []

enode_regex = /Public node URL:(.*)$/

containers.each do |container|
  enode_log = `docker exec #{container} cat /root/.pm2/logs/parity-error-0.log | grep enode`
	match = enode_log.match(enode_regex)
  enodes.push match[1].strip if match
end

enodes.uniq!
enodes_str = enodes.join "\n"

puts "\nENODES:\n#{enodes_str} \n\n"

File.open("#{path}/tmp/peers.enodes", "w") do |f|
  f.write enodes_str
end

containers.each do |container|
  puts "container: '#{container}'"
  system "docker cp  #{path}/tmp/peers.enodes #{container}:/www/app/parity/peers.enodes"
  system "docker exec #{container} pm2 restart parity"
  # system %Q{#{d_exec} "echo '#{enodes_str}' > /www/app/parity/peers.enodes"}
end

puts "done! - status:"
containers.each do |container|
  pm2 = "docker exec #{container} /usr/bin/pm2"
  system "#{pm2} status"
end
