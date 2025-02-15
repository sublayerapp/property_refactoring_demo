class GithubFileModificationAction < GithubBase
  def initialize(repo:, branch:, steps:)
    super(repo: repo)
    @branch = branch
    @steps = steps
  end

  def call
    @steps.each do |step|
      if step.action_to_perform == "create_file"
        create_file(step)
      elsif step.action_to_perform == "modify_file"
        modify_file(step)
      end
    end
  end

  private
  def create_file(step)
    @client.create_contents(
      @repo,
      step.file_path,
      "Create #{step.file_path}",
      step.code,
      branch: @branch
    )
  end

  def modify_file(step)
    begin
      content = @client.contents(@repo, path: step.file_path, ref: @branch)
      puts "Repo: #{@repo},\n Path: #{step.file_path},\n Ref: #{@branch},\n Sha: #{content.sha}"
      @client.update_contents(
        @repo,
        step.file_path,
        "Update #{step.file_path}",
        content.sha,
        step.code,
        branch: @branch
      )
    rescue Octokit::NotFound
      create_file(step)
    end
  end
end
