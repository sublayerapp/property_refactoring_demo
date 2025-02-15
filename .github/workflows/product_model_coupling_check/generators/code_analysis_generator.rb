class CodeAnalysisGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :named_strings,
    name: "code_analysis",
    description: "Analysis of code changes in the PR",
    attributes: [
      { name: "new_coupling", description: "Description of any new coupling introduced into the Property model" },
      { name: "new_responsibilities", description: "Description of any new responsibilities added to the Property model" },
      { name: "suggestion", description: "Suggestion for improvement if issues are found" }
    ]

  def initialize(pr_details:, file_contents:)
    @pr_details = pr_details
    @file_contents = file_contents
  end

  def generate
    super
  end

  def prompt
    <<-PROMPT
    You are an expert Ruby on Rails developer tasked with analyzing changes to a Property model in a large, legacy property management application.
    The primary goal is to prevent further coupling and to avoid adding more responsibilities to this Property model at all costs.

    PR Details:
    #{@pr_details}

    File Contents:
    #{@file_contents}

    Please analyze the changes and provide:
    1. A description of any new coupling intoduced into the Property model
    2. A description of any new responsibilities added to the Property model
    3. A suggestion for improvement if any issues are found

    If no issues are found, respond with "No issues found" for each field
    PROMPT
  end
end
