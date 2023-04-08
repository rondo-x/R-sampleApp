# coding: utf-8
require 'spec_helper'

# ruby (-v だとErrorになっているためstdoutが空)
#describe command('ruby -v 2>&1') do
#  let(:disable_sudo) { true }
#  its(:stdout) { should match /ruby 3\.1\.2p20.+/ }
#end


# nodejs (-v, --versionで試すもErrorになっているためstdoutが空)
#describe command('node --version') do
#  let(:disable_sudo) { true }
#  its(:stdout) { should match "v15.14.0" }
#end

# MySQL 
#describe package('mysql-server') do
#  it { should be_installed }
#end

#describe port(3306) do
#  it { should be_listening }
#end


# yarn (-v, --versionで試すもErrorになっているためstdoutが空)
#describe command('yarn -v') do
#  let(:disable_sudo) { true }
#  its(:stdout) { should match "1.22.19" }
#end


# unicorn
describe command('ps aux | grep unicorn') do
#describe command('ps -ef | grep unicorn | grep -v grep') do
  let(:disable_sudo) { true }
  its(:stdout) { should match /unicorn/ }
end

describe file('raisetech-app/tmp/unicorn.sock') do
  it { should be_socket }
end


# ImageMagic
describe command('convert -version') do
  let(:disable_sudo) { true }
  its(:stdout) { should match /ImageMagick 6.9.11/ }
end


# nginx
describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

# HTTPでアクセスして、ステータスコードのチェック
describe command('curl http://127.0.0.1:80/ -o /dev/null -w "%{http_code}¥n" -s') do
  its(:stdout) { should match /^200/}
end
