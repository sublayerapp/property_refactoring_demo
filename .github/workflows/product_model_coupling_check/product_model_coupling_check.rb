require "base64"

require "sublayer"
require "octokit"

# Load all Sublayer Actions, Generators, and Agents
Dir[File.join(__dir__, "actions", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "generators", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "agents", "*.rb")].each { |file| require file }

Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
Sublayer.configuration.ai_model = "gemini-1.5-pro-latest"

# Add custom Github Action code below:
repo = ENV["GITHUB_REPOSITORY"]
pr_number = ENV["PR_NUMBER"].to_i

pr_details = GithubPRFetcherAction.new(repo: repo, pr_number: pr_number).call

analyses = pr_details[:files].map do |file|
  client = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
  file_content = client.contents(repo, path: file.filename, ref: pr_details[:pr].head.sha)

  CodeAnalysisGenerator.new(
    pr_details: pr_details[:pr].to_h,
    file_contents: Base64.decode64(file_content.content)
  ).generate
end

combined_analysis = analyses.reduce do |memo, analysis|
  {
    new_coupling: [memo[:new_coupling], analysis[:new_coupling]].join("\n"),
    new_responsibilities: [memo[:new_responsibilities], analysis[:new_responsibilities]].join("\n"),
    suggestion: [memo[:suggestion], analysis[:suggestion]].join("\n")
  }
end

comment = PRCommentGenerator.new(analysis: combined_analysis).generate

GithubPRCommenterAction.new(repo: repo, pr_number: pr_number, comment: comment).call
