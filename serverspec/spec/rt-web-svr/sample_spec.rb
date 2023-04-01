# coding: utf-8
require 'spec_helper'

# nginx
describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
#  it { should be_enabled } # 自動起動はしない 
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

# HTTPでアクセスして、ステータスコードのチェック
describe command('curl http://127.0.0.1:80/ -o /dev/null -w "%{http_code}¥n" -s') do
  its(:stdout) { should match /^200/}
end
