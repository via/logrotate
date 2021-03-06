#
# Cookbook Name:: logrotate
# Definition:: logrotate_instance
#
# Copyright 2009, Scott M. Likens
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

define :logrotate_app, :enable => true, :frequency => nil, :template => "logrotate.erb", :cookbook => "logrotate", :rotate => nil, :create => nil, :options => [] do
  include_recipe "logrotate"

  acceptable_options = ['missingok', 'compress', 'delaycompress', 'copytruncate', 'notifempty', 'delaycompress', 'ifempty', 'mailfirst', 'nocompress', 'nocopy', 'nocopytruncate', 'nocreate', 'nodelaycompress', 'nomail', 'nomissingok', 'noolddir', 'nosharedscripts', 'notifempty', 'sharedscripts']
  path = params[:path].respond_to?(:each) ? params[:path] : params[:path].split
  options = params[:options].respond_to?(:each) ? params[:options] : params[:options].split

  if params[:enable]

    invalid_options = options - acceptable_options
    if invalid_options.size == 1
        Chef::Application.fatal! "The passed value [#{invalid_options[0]}] is not an acceptable value"
    end

    template "/etc/logrotate.d/#{params[:name]}" do
      source params[:template]
      cookbook params[:cookbook]
      mode 0440
      owner "root"
      group "root"
      backup false
      variables(
        :path => path,
        :create => params[:create],
        :frequency => params[:frequency],
        :rotate => params[:rotate],
        :options => options
      )
    end

  else

    execute "rm /etc/logrotate.d/#{params[:name]}" do
      only_if FileTest.exists?("/etc/logrotate.d/#{params[:name]}")
      command "rm /etc/logrotate.d/#{params[:name]}"
    end

  end
end

