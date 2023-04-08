# coding: utf-8
require 'spec_helper'

# ssh
describe command('ssh rt-ap-svr') do
  its(:stdout) { should match OK }
end

describe command('exit') do
  its(:stdout) { should match OK }
end

# nginx
describe package('nginx') do
  it { should be_installed }
end
