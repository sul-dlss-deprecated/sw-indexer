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

# Check that we can reach the configured dor-services-app endpoint
class DorServicesCheck < OkComputer::AppVersionCheck
  def check
      url = "#{Settings.DOR_SERVICES_URL}/about"
      result = Faraday.new(url: url).get
      raise "OkComputer: dor-services-app at #{url} is not returning 200. Code returned = #{result.status}" unless result.status == 200
    rescue
      raise "OkComputer: dor-services-app at #{url} cannot be reached"
  end
end
OkComputer::Registry.register 'dor-services', DorServicesCheck.new

# Check each Solr target to see whether it's alive
class TargetsCheck < OkComputer::Check
  def targets
    @targets ||= Settings.SOLR_TARGETS.to_hash.deep_stringify_keys
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

OkComputer::Registry.register 'feature-targets', TargetsCheck.new
