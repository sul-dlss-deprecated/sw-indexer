require 'okcomputer'
require 'uri'

OkComputer.mount_at = 'status' # use /status or /status/all or /status/<name-of-check>
OkComputer.check_in_parallel = true
OkComputer::Registry.deregister 'database'

##
# REQUIRED checks

# Simple echo of the VERSION file
class VersionCheck < OkComputer::AppVersionCheck
  def version
    File.read(Rails.root.join('VERSION')).chomp
  rescue Errno::ENOENT
    raise UnknownRevision
  end
end
OkComputer::Registry.register 'version', VersionCheck.new

# Check each Solr target to see whether it's alive
class TargetsCheck < OkComputer::Check
  def targets
    # TODO: the solr.yml configuration does NOT get initialized until `after_initialize`
    # i.e., until all initializers are run. So we have to do a lazy evaluation here
    @targets ||= BaseIndexer.solr_configuration_class_name.constantize.instance.get_configuration_hash
    raise "OkComputer: Targets not configured" unless @targets.present?
    @targets
  end

  def check
    message = ""
    targets.each_pair do |k, v|
      check = OkComputer::SolrCheck.new(v['url'])
      check.check
      if check.success?
        message += "Target #{k} is up. "
      else
        mark_failure
        message += "Target #{k} is down. "
      end
    end
    mark_message message
  end
end

OkComputer::Registry.register 'targets', TargetsCheck.new
