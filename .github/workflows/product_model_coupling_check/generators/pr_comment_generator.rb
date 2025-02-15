class PRCommentGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :single_string,
    name: "pr_comment",
    description: "A comment to be posted on the PR"

  def initialize(analysis:)
    @analysis = analysis
  end

  def generate
    super
  end

  def prompt
    <<-PROMPT
    You are a helpful and knowledgable tech lead tasked with maintaining the highest standards of the code base, anti-patterns like coupling and god objects are things you're trying to protect against the most.
    You are brief but helpful and positive in your responses while at the same time ensuring that the code isn't made worse.

    Based on the following analysis of a pull request, create a constructive comment to be posted on the PR.
    If there are no issues, generate a brief positive comment.

    Analysis:
    #{@analysis}

    The comment should be professional, constructive, and provide specific suggestions for improvement if issues were found.
    PROMPT
  end
end
