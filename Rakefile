ENV['HOMEBREW_CASK_OPTS'] = "--appdir=/Applications"

def brew_install(package, *options)
  `brew list #{package}`
  return if $?.success?

  sh "brew install #{package} #{options.join ' '}"
end

def install_github_bundle(user, package)
  unless File.exist? File.expand_path("~/.vim/bundle/#{package}")
    sh "git clone https://github.com/#{user}/#{package} ~/.vim/bundle/#{package}"
  end
end

def brew_cask_install(package, *options)
  output = `brew cask info #{package}`
  return unless output.include?('Not installed')

  sh "brew cask install #{package} #{options.join ' '}"
end

def step(description)
  description = "-- #{description} "
  description = description.ljust(80, '-')
  puts
  puts "\e[32m#{description}\e[0m"
end

def app_path(name)
  path = "/Applications/#{name}.app"
  ["~#{path}", path].each do |full_path|
    return full_path if File.directory?(full_path)
  end

  return nil
end

def app?(name)
  return !app_path(name).nil?
end

def get_backup_path(path)
  number = 1
  backup_path = "#{path}.bak"
  loop do
    if number > 1
      backup_path = "#{backup_path}#{number}"
    end
    if File.exists?(backup_path) || File.symlink?(backup_path)
      number += 1
      next
    end
    break
  end
  backup_path
end

def link_file(original_filename, symlink_filename)
  original_path = File.expand_path(original_filename)
  symlink_path = File.expand_path(symlink_filename)
  if File.exists?(symlink_path) || File.symlink?(symlink_path)
    if File.symlink?(symlink_path)
      symlink_points_to_path = File.readlink(symlink_path)
      return if symlink_points_to_path == original_path
      # Symlinks can't just be moved like regular files. Recreate old one, and
      # remove it.
      ln_s symlink_points_to_path, get_backup_path(symlink_path), :verbose => true
      rm symlink_path
    else
      # Never move user's files without creating backups first
      mv symlink_path, get_backup_path(symlink_path), :verbose => true
    end
  end
  ln_s original_path, symlink_path, :verbose => true
end

def unlink_file(original_filename, symlink_filename)
  original_path = File.expand_path(original_filename)
  symlink_path = File.expand_path(symlink_filename)
  if File.symlink?(symlink_path)
    symlink_points_to_path = File.readlink(symlink_path)
    if symlink_points_to_path == original_path
      # the symlink is installed, so we should uninstall it
      rm_f symlink_path, :verbose => true
      backups = Dir["#{symlink_path}*.bak"]
      case backups.size
      when 0
        # nothing to do
      when 1
        mv backups.first, symlink_path, :verbose => true
      else
        $stderr.puts "found #{backups.size} backups for #{symlink_path}, please restore the one you want."
      end
    else
      $stderr.puts "#{symlink_path} does not point to #{original_path}, skipping."
    end
  else
    $stderr.puts "#{symlink_path} is not a symlink, skipping."
  end
end

namespace :install do
  desc 'Update or Install Brew'
  task :brew do
    step 'Homebrew'
    unless system('which brew > /dev/null || ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"')
      raise "Homebrew must be installed before continuing."
    end
  end

  desc 'Install Homebrew Cask'
  task :brew_cask do
    step 'Homebrew Cask'
    unless system('brew tap | grep phinze/cask > /dev/null') || system('brew tap phinze/homebrew-cask')
      abort "Failed to tap phinze/homebrew-cask in Homebrew."
    end

    brew_install 'brew-cask'
  end

  desc 'Install The Silver Searcher'
  task :the_silver_searcher do
    step 'the_silver_searcher'
    brew_install 'the_silver_searcher'
  end

  desc 'Install iTerm'
  task :iterm do
    step 'iterm2'
    unless app? 'iTerm'
      brew_cask_install 'iterm2'
    end
  end

  desc 'Install ctags'
  task :ctags do
    step 'ctags'
    brew_install 'ctags'
  end

  desc 'Install reattach-to-user-namespace'
  task :reattach_to_user_namespace do
    step 'reattach-to-user-namespace'
    brew_install 'reattach-to-user-namespace'
  end

  desc 'Install tmux'
  task :tmux do
    step 'tmux'
    brew_install 'tmux'
  end

  desc 'Install MacVim'
  task :macvim do
    step 'MacVim'
    unless app? 'MacVim'
      brew_cask_install 'macvim'
    end

    bin_dir = File.expand_path('~/bin')
    bin_vim = File.join(bin_dir, 'vim')
    unless ENV['PATH'].split(':').include?(bin_dir)
      puts 'Please add ~/bin to your PATH, e.g. run this command:'
      puts
      puts %{  echo 'export PATH="~/bin:$PATH"' >> ~/.bashrc}
      puts
      puts 'The exact command and file will vary by your shell and configuration.'
    end

    FileUtils.mkdir_p(bin_dir)
    unless File.executable?(bin_vim)
      File.open(bin_vim, 'w', 0744) do |io|
        io << <<-SHELL
#!/bin/bash
exec /Applications/MacVim.app/Contents/MacOS/Vim "$@"
        SHELL
      end
    end
  end

  desc 'Install Vundle'
  task :vundle do
    step 'vundle'
    install_github_bundle 'gmarik','vundle'
    sh 'vim -c "BundleInstall" -c "q" -c "q"'
  end

end

def filemap(map)
  map.inject({}) do |result, (key, value)|
    result[File.expand_path(key)] = File.expand_path(value)
    result
  end.freeze
end

COPIED_FILES = filemap(
  'vimrc.local'         => '~/.vimrc.local',
  'vimrc.bundles.local' => '~/.vimrc.bundles.local'
)

LINKED_FILES = filemap(
  'vim'           => '~/.vim',
  'vimrc'         => '~/.vimrc',
  'vimrc.bundles' => '~/.vimrc.bundles'
  'screenrc'      => '~/.screenrc'
  'bashrc'        => '~/.bashrc'
)

desc 'Install these config files.'
task :install do
  step 'symlink'

  LINKED_FILES.each do |orig, link|
    link_file orig, link
  end

  COPIED_FILES.each do |orig, copy|
    cp orig, copy, :verbose => true unless File.exist?(copy)
  end
  unless File.exists?(File.expand_path('~/bin'))
    FileUtils.mkdir_p(File.expand_path('~/bin'))
  end
  cp_r Dir.glob('bin/*'), File.expand_path('~/bin'), :verbose => true

  # Install Vundle and bundles
  Rake::Task['install:vundle'].invoke

end

desc 'Uninstall these config files.'
task :uninstall do
  step 'un-symlink'

  # un-symlink files that still point to the installed locations
  LINKED_FILES.each do |orig, link|
    unlink_file orig, link
  end

  # delete unchanged copied files
  COPIED_FILES.each do |orig, copy|
    rm_f copy, :verbose => true if File.read(orig) == File.read(copy)
  end

  step 'homebrew'
  puts
  puts 'Manually uninstall homebrew if you wish: https://gist.github.com/mxcl/1173223.'

  step 'iterm2'
  puts
  puts 'Run this to uninstall iTerm:'
  puts
  puts '  rm -rf /Applications/iTerm.app'

  step 'macvim'
  puts
  puts 'Run this to uninstall MacVim:'
  puts
  puts '  rm -rf /Applications/MacVim.app'
end

task :default => :install
