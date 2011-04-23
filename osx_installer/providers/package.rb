require 'uri'
#
# Cookbook Name:: osx_installer
# Provider:: package

def load_current_resource
  @osx_installer = Chef::Resource::OsxInstallerPackage.new(new_resource.name)
  @osx_installer.filename(new_resource.name)
  @osx_installer.is_remote(true) if URI.parse(new_resource.source).scheme
  @osx_installer.verbose(new_resource.verbose)
end

action :install do
  if @osx_installer.is_remote
    remote_file new_resource.source do
      Chef::Log.debug("fetching:  #{new_resource.source}")
      source new_resource.source
    end
  end

  osx_pkg_filepaths = []
  new_resource.search_paths.each do |search_path|
    search_path = ::File.expand_path(search_path)
    Dir["#{search_path}/**/*#{new_resource.package_extension}"].each do |path|
      if ::File.basename(path) == @osx_installer.filename
        Chef::Log.debug("Found osx_installer: #{path}")
        osx_pkg_filepaths << ::File.expand_path(path)
      end
    end
  end

  Chef::Log.debug("no osx_installer found...continuing...") if osx_pkg_filepaths.empty?

  osx_pkg_filepaths.each do |package_path|
    Chef::Log.debug("Installing osx_installer: #{package_path}")
    installer_command = "installer -pkg '#{package_path}' -target '#{@osx_installer.destination}'"
    installer_command << " -verbose" if @osx_installer.verbose
    execute installer_command
  end
end

action :info do

end
