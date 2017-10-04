require 'logger'  

module Puppet::Parser::Functions
  newfunction(:getTemplatesList, :type => :rvalue) do |args|

    log = Logger.new(STDOUT)
    log.level = Logger::INFO

    # Pentaho search paths function argument
    base_dir = args[0]

    # Avoid duplicated path due to missing variables
    search_paths_tmp = []
    base_dir.each do |dir|
      search_paths_tmp.push(dir.chomp("/"))
    end

    search_paths = search_paths_tmp.uniq

    result = []

    search_paths.each do |dir|

      # https://github.com/puppetlabs/puppet/blob/master/lib/puppet/indirector/catalog/compiler.rb#L198

      log.info("[getTemplatesList] Recursive search: " + dir)

      files = Puppet::FileServing::Metadata.indirection.search(dir,
        :environment => catalog.environment_instance,
        :recurse     => true,
      )

      if ! files.nil?

        files.each do |file|

          # if file and text
          if file.ftype == 'file' && %x(file #{file.path + '/' + file.relative_path}) =~ /text/
  
            full_path = file.path + '/' + file.relative_path
            log.info("[getTemplatesList] Template found: " + full_path)

            item = []
            item.push(file.relative_path)
            item.push(file.path)

            result.push([file.path, file.relative_path])

          end

        end

      end

    end

    log.info(result)
    result

  end

end
