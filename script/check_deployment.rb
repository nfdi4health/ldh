output = `curl --verbose --silent http://localhost:3000/statistics/application_status 2>&1`
if $?.success? && output.match?(/is running \| search is enabled \| \d+ delayed jobs running/)
  exit 0
else
  puts "::group::Docker logs"
  puts `docker compose --file docker-compose.yml --file docker-compose.build.yml logs`
  puts "::endgroup::"
  puts "::group::curl output"
  puts output
  puts "::endgroup::"
  exit 1
end
