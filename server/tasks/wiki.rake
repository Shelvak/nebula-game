require File.expand_path(File.dirname(__FILE__) + '/helpers/assets')

namespace :wiki do
  desc "Initialize wiki environment"
  task :load => :environment

  namespace :files do
    desc "Synchronize files with latest versions from wiki."
    task :sync => "wiki:load" do
      puts
      
      agent = WikiMechanize.instance
      base = AssetBase.new
      processor = Processor.new(base)
      remote_missing = []
      local_missing = []

      remote_hashes = JSON.parse(agent.get_content("FileHashes"))
      local_hashes = Assets.load_hashes(Assets::DOWNLOADED_FILE_HASHES)

      total = 0
      updated = 0
      in_sync = 0
      remote_count = base.remote_count
      current = 0

      begin
        base.each do |wiki, local, info|
          current += 1
          total += 1
          if local_hashes[local]
            local_hash, old_opts = local_hashes[local].split("-", 2)
          else
            local_hash, old_opts = "", "{}"
          end
          current_opts = base.opts_string(wiki)

          local_is_missing = (local_hash == Assets::MISSING_HASH)

          if remote_hashes[wiki].nil?
            remote_missing.push(wiki)
          elsif local_hash == remote_hashes[wiki] \
              and old_opts == current_opts
            in_sync += 1
          else
            puts
            puts "+" + ("-" * 79)
            puts "| File no.   : #{current} / #{remote_count}"
            puts "| Remote file: #{wiki}"
            puts "| Remote hash: #{remote_hashes[wiki]}"
            puts "| Local file : #{local}"
            puts "| Local hash : #{local_hash}"
            puts "| Opts differ: #{old_opts != current_opts}"
            puts "+" + ("-" * 79)

            success, hash, file = nil, nil, nil
            begin
              success, hash, file = agent.download_wiki_file(wiki)
            rescue Exception => error
              puts "Error: #{error}"
              puts "Retrying."
              retry
            end

            if success
              updated += 1
              local_is_missing = false

              begin
                processor.process(file, local, info)
              ensure
                file.close
                FileUtils.rm_f file.path
              end
              
              # Store hash if everything went fine
              local_hashes[local] = "#{hash}-#{current_opts}"

              # Store downloaded file hashes after each file.
              Assets.store_hashes(Assets::DOWNLOADED_FILE_HASHES,
                local_hashes)
            end
          end

          local_missing.push(local) if local_is_missing
        end
      rescue BadExitStatusError => error
        puts error
        puts "Cancelling further processing."
      end

      puts
      puts "Files synced:"
      puts "  In sync       : #{in_sync}"
      puts "  Updated       : #{updated}"
      puts "  Local missing : #{local_missing.size}"
      puts "  Remote missing: #{remote_missing.size}"
      puts "  Total         : #{total}"
      puts

      [
        ['remote', remote_missing],
        ['local', local_missing]
      ].each do |name, list|
        if list.size > 0
          puts "These files were missing (#{name}):"
          list.each do |file|
            puts "  * #{file}"
          end
          puts
        end
      end
    end
  end

  desc "Sync all wiki resources and compile flex module."
  task :sync => ['wiki:files:sync', 'wiki:list:store', 'flex:assets:build']

  desc "List all remote wiki files."
  task :list => "wiki:load" do
    width = 100
    format = "  %-40s %-40s %-10s"

    base = AssetBase.new
    base.each_bundle do |bundle|
      puts "Bundle: #{bundle.name} (#{bundle.dir})"
      puts
      puts format % ["Local name", "Remote name", "Target"]
      puts "  %s  " % ("-" * 92)
      bundle.each do |local, remote, info|
        puts format % [local, remote, info[:target]]
        puts "    #{info[:opts].inspect}\n\n" unless info[:opts].blank?
      end
      puts
      puts "-" * 96
    end
  end

  namespace :list do
    desc "Store asset list to our wiki."
    task :store => "wiki:load" do
      content = "'''This page is autogenerated.'''\n"

      base = AssetBase.new
      base.each_bundle do |bundle|
        content +=<<EOF
== #{bundle.name} ==

{| border="1" cellspacing="0" cellpadding="5"
|+ #{bundle.dir}
|-
! Local file
! Wiki file
! Target
EOF
        bundle.each do |local, remote, info|
          if remote.match(ARCHIVE_RE)
            file_info = "[[File:#{remote}]]"
          else
            file_info = "[[File:#{remote}|frameless|width=600px]]"
          end
          content +=<<EOF
|-
| #{local}
| #{file_info}
| #{info[:target]}
EOF
          unless info[:opts].blank?
            content +=<<EOF
|-
| colspan="3" | <pre>#{info[:opts].inspect}</pre>
EOF
          end
        end

        content += "|}\n"
      end

      agent = WikiMechanize.instance
      agent.store_wiki_page("Nebula 44:Assets", content)
    end
  end

  desc "Convert all zip files to tgz ones."
  task :zip_to_tgz => "wiki:load" do
    agent = WikiMechanize.instance
    base = AssetBase.new
    base.each do |wiki, local, info|
      if wiki.ends_with?(".tar.gz")
        puts "Processing #{wiki}"
        success, hash, tempfile = agent.download_wiki_file(wiki)
        if success
          tmpdir = Dir.mktmpdir("zip-to-tgz")

          cmd = "tar -xzf #{tempfile.path} -C #{tmpdir}"
          puts " > #{cmd}"
          `#{cmd}`

          tmpfile = Tempfile.new("zip-to-tgz")
          cmd = "tar -czf #{tmpfile.path} #{tmpdir}/*"
          puts " > #{cmd}"
          `#{cmd}`
          
          puts agent.upload_wiki_file(wiki.sub(/\.tar\.gz$/, '.tgz'),
            tempfile.path)
          tmpfile.unlink

          FileUtils.rm_rf tmpdir
          tempfile.unlink
        end

      end
    end
  end
end
