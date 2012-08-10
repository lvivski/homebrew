require 'formula'

class Beanstalk < Formula
  homepage 'http://kr.github.com/beanstalkd/'
  url 'https://github.com/downloads/kr/beanstalkd/beanstalkd-1.6.tar.gz'
  sha1 '1909e7641cb75a5f9eb00df2b6a194cee9c7c1bc'

  def install
    system "make", "install", "PREFIX=#{prefix}"

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats
    tod = "~/Library/LaunchAgents"
    to = "#{tod}/#{plist_name}"
    from = "#{opt_prefix}/#{plist_name}"

    <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p #{tod}
        ln -s #{from} #{tod}
        launchctl load -w #{to}

    If this is an upgrade and you already have #{plist_name} loaded:
        launchctl unload -w #{to}
        launchctl load -w #{to}

      To start beanstalk manually:
        beanstalkd
    EOS
  end

  def startup_plist
    <<-EOPLIST.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{HOMEBREW_PREFIX}/bin/beanstalkd</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>UserName</key>
        <string>#{`whoami`.chomp}</string>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/beanstalkd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/beanstalkd.log</string>
      </dict>
    </plist>
    EOPLIST
  end
end
