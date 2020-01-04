# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
require 'logger'  

# ---- original file header ----
#
# @summary
#   Summarise what the function does here
#
Puppet::Functions.create_function(:'pentaho::getTemplatesList') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end


  def default_impl(*args)
    

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