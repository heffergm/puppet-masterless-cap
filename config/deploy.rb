# start deploying
namespace :deploy do
  task :start do ; end
  task :stop do ; end

  task :cleanup, :except => { :no_release => true } do
    count = fetch(:keep_releases, 2).to_i
    cmd = "ls -xt #{releases_path}"
    run cmd do |channel, stream, data|
      local_releases = data.split.reverse
      if count >= local_releases.length
        logger.info "\e[0;31;1mNOTICE:\e[0m No old releases to clean up on #{channel[:server]}"
      else
        logger.info "\e[0;31;1mNOTICE:\e[0m Keeping #{count} of #{local_releases.length} deployed releases on #{channel[:server]}"
        (local_releases - local_releases.last(count)).each { |release|
          run "rm -rf #{File.join(releases_path, release)}", :hosts => [channel[:server]]
        }
      end
    end
  end

  # set max_hosts on update_code
  task :update_code, :except => { :no_release => true }, :max_hosts => "#{max_hosts}" do
    logger.info "\e[0;31;1mNOTICE:\e[0m Pulling repo from #{repository}: max_hosts => '#{max_hosts}'"
    on_rollback { run "rm -rf #{release_path}; true" }
    strategy.deploy!
    finalize_update
  end

  # run puppet
  task :run_puppet, :roles => :app do
    if ENV['NOOP'] == nil
      if ENV['TAGS'] == nil
        logger.info "\e[0;31;1mATTENTION:\e[0m Applying full puppet manifest..."
        run "puppet apply --factpath=#{current_path}/facter/lib --modulepath=#{current_path}/modules #{current_path}/manifests/site.pp"
      else
        logger.info "\e[0;31;1mATTENTION:\e[0m Applying puppet manifests with tags: #{ENV['TAGS']}"
        run "puppet apply --factpath=#{current_path}/facter/lib --modulepath=#{current_path}/modules --tags #{tags} #{current_path}/manifests/site.pp"
      end
    else
      if ENV['TAGS'] == nil
        logger.info "\e[0;31;1mATTENTION:\e[0m Applying full puppet manifest with --noop set (no changes will be made)..."
        run "puppet apply --noop --factpath=#{current_path}/facter/lib --modulepath=#{current_path}/modules #{current_path}/manifests/site.pp"
      else
        logger.info "\e[0;31;1mATTENTION:\e[0m Applying puppet manifests with tags: #{ENV['TAGS']}, --noop is set (no changes will be made)..."
        run "puppet apply --noop --factpath=#{current_path}/facter/lib --modulepath=#{current_path}/modules --tags #{tags} #{current_path}/manifests/site.pp"
      end
    end
  end
end

