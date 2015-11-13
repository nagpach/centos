require 'pathname'

task default: 'docker:build'

namespace :docker do
  image_name = 'feduxorg/centos'
  container_name = 'centos1'

  desc 'Build docker image'
  task :build, :nocache do |_, args|
    nocache = args[:nocache]
    proxy = '172.17.0.1'
    docker_file = 'files/latest/Dockerfile'

    cmdline = []
    cmdline << 'docker'
    cmdline << 'build'
    cmdline << '--no-cache=true' if nocache
    cmdline << "--build-arg http_proxy=http://#{proxy}:3128" if ENV.key? 'http_proxy'
    cmdline << "--build-arg https_proxy=https://#{proxy}:3128" if ENV.key? 'https_proxy'
    cmdline << "--build-arg HTTP_PROXY=http://#{proxy}:3128" if ENV.key? 'HTTP_PROXY'
    cmdline << "--build-arg HTTPS_PROXY=https://#{proxy}:3128" if ENV.key? 'HTTPS_PROXY'
    cmdline << "-t #{image_name}"
    cmdline << "-f #{docker_file}"
    cmdline << '.'

    sh cmdline.join(' ')
  end

  desc 'Run docker container'
  task :run, :command do |_, task_args|
    command = task_args[:command]

    mkdir_p %w(var/ssh/authorized_keys var/ssh/host_keys)

    args =[]
    args << '-it'
    args << '--rm'
    args << "--name #{container_name}"
    args << "-p 8022:22"
    args << "-v /sys/fs/cgroup:/sys/fs/cgroup"
    args << "-v #{File.expand_path('var/ssh')}:/var/ssh/" if File.directory? 'var/ssh'
    # args << "-v /var/log/journal:/var/log/journal" if File.directory? '/var/log/journal'

    cmdline = []
    cmdline << 'docker'
    cmdline << 'run'
    cmdline.concat args
    cmdline << image_name
    cmdline << command if command

    sh cmdline.join(' ')
  end
end

task :clean do
  sh 'sudo rm -rf tmp/*'
end
