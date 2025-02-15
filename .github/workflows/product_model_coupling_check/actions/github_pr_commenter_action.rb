class GithubPRCommenterAction < Sublayer::Actions::Base
  def initialize(repo:, pr_number:, comment:)
    @repo = repo
    @pr_number = pr_number
    @comment = comment
    @client = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
  end

  def call
    @client.add_comment(@repo, @pr_number, @comment)
  end
end
