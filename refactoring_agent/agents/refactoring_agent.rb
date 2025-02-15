class RefactoringAgent < Sublayer::Agents::Base
  def initialize(code:, refactoring_steps:)
    @code = code
    @refactoring_steps = refactoring_steps
    puts "Waiting for events"
  end

  trigger(
    AsanaEventTrigger.new(project_id: ENV["REFACTORING_ASANA_PROJECT_ID"]) do |event|
      puts "triggered"
      @current_event = event
      @goal_condition = false
      take_step
    end
  )

  goal_condition { @goal_condition }
  check_status { true }

  step do
    latest_comment = GetLatestAsanaCommentAction.new(task_gid: @current_event.parent.gid).call
    description = GetAsanaTaskDescriptionAction.new(task_gid: @current_event.parent.gid).call
    title = GetAsanaTaskNameAction.new(task_gid: @current_event.parent.gid).call.split(" || ").first

    refactoring_steps = RefactoringStepsGenerator.new(code: @code, refactoring_step: description, refactoring_steps: @refactoring_steps).generate
    repo = "sublayerapp/property_refactoring_demo"
    branch_name = "refactor/#{title.downcase.gsub(/\s+/, '-')}"

    GithubCreateBranchAction.new(
      repo: repo,
      base_branch: "main",
      new_branch: branch_name
    ).call

    GithubFileModificationAction.new(
      repo: repo,
      branch: branch_name,
      steps: refactoring_steps
    ).call

    GithubCreatePRAction.new(
      repo: repo,
      base: "main",
      head: branch_name,
      title: "Refactor #{title}",
      body: description
    ).call
  end
end
