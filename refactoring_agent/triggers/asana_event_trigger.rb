class AsanaEventTrigger < Sublayer::Triggers::Base
  def initialize(project_id:, access_token: nil, &event_handler)
    @project_id = project_id
    @access_token = access_token || ENV["ASANA_ACCESS_TOKEN"]
    @client = Asana::Client.new do |c|
      c.authentication :access_token, @access_token
    end
    @event_handler = event_handler
  end

  def setup(agent)
    projects = @client.projects.find_all(workspace: ENV["REFACTORING_ASANA_WORKSPACE_ID"])
    project = projects.select { |project| project.gid == @project_id }.first
    events = project.events(wait: 2)
    filtered_events = events.lazy.select do |event|
      (event.resource.resource_type == "story" && event.resource.type == "comment")
    end

    filtered_events.each do |event|
      agent.instance_exec(event, &@event_handler)
    end
  end
end
